import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';
import 'package:kicksvibe/features/favourite/domain/repositories/favorite_repository.dart';

@LazySingleton(as: FavoriteRepository)
class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl(this._auth, this._firestore);

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  Stream<List<ProductModel>> watchFavorites() {
    return _auth.authStateChanges().asyncExpand((user) {
      if (user == null) return Stream.value(const <ProductModel>[]);
      return _watchUserFavorites(user.uid);
    });
  }

  Stream<List<ProductModel>> _watchUserFavorites(String userId) async* {
    final box = await Hive.openBox<ProductModel>('favorites_$userId');
    if (box.isNotEmpty) {
      yield box.values.toList(growable: false);
    }

    yield* _favoritesCollection(userId).snapshots().asyncMap((snapshot) async {
      final products = snapshot.docs
          .map(
            (document) => ProductModel.fromJson(document.data(), document.id),
          )
          .toList(growable: false);
      await box.clear();
      await box.addAll(products);
      return products;
    });
  }

  @override
  Future<void> toggle(ProductModel product) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const FavoriteAuthenticationException();
    }

    final document = _favoritesCollection(user.uid).doc(product.id);
    final snapshot = await document.get();
    if (snapshot.exists) {
      await document.delete();
      return;
    }

    await document.set({
      ...product.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  CollectionReference<Map<String, dynamic>> _favoritesCollection(
    String userId,
  ) {
    return _firestore.collection('users').doc(userId).collection('favorites');
  }
}

class FavoriteAuthenticationException implements Exception {
  const FavoriteAuthenticationException();
}
