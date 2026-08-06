import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';

part 'favourite_state.dart';

@lazySingleton
class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit(this._auth, this._firestore) : super(FavoriteState()) {
    _authSubscription = _auth.authStateChanges().listen(_watchUserFavorites);
  }

  // 1. تعريف المتغيرات اللي كانت مسببة الخط الأحمر عندك
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _favoritesSubscription;

  // 2. دالة مراقبة المستخدم الحالي وتحميل المفضلة من Firebase
void _watchUserFavorites(User? user) {
    _favoritesSubscription?.cancel();
    final box = Hive.box<ProductModel>('favoritesBox');

    if (user == null) {
      box.clear();
      emit(FavoriteState());
      return;
    }

    // 1. عرض الكاش المحفوظ فوراً
    emit(FavoriteState(favoriteProducts: box.values.toList()));

    // 2. الاستماع لتحديثات Firebase ومزامنتها مع الكاش
    _favoritesSubscription = _favoritesCollection(user.uid).snapshots().listen(
      (snapshot) {
        if (isClosed) return;
        final products = snapshot.docs
            .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
            .toList();

        // تحديث قاعدة البيانات المحلية
        box.clear();
        box.addAll(products);

        emit(FavoriteState(favoriteProducts: products));
      },
      onError: (error, stackTrace) {
        if (isClosed) return;
        emit(state.copyWith(errorMessage: 'Could not load favourites.'));
      },
    );
  }

  CollectionReference<Map<String, dynamic>> _favoritesCollection(
    String userId,
  ) {
    return _firestore.collection('users').doc(userId).collection('favorites');
  }

  // 3. إضافة أو حذف المنتج من المفضلة في Firebase مباشرة
  Future<void> toggleFavorite(ProductModel product) async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(state.copyWith(errorMessage: 'Please sign in to save favourites.'));
      return;
    }
    final document = _favoritesCollection(user.uid).doc(product.id);
    try {
      if (isFavorite(product.id)) {
        await document.delete();
      } else {
        await document.set({
          ...product.toJson(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } on FirebaseException {
      if (isClosed) return;
      emit(
        state.copyWith(
          errorMessage: 'Could not update favourites. Please try again.',
        ),
      );
    }
  }

  // 4. فحص هل المنتج موجود في المفضلة
  bool isFavorite(String productId) {
    return state.favoriteProducts.any((element) => element.id == productId);
  }

  // 5. إغلاق الـ Subscriptions لحماية الذاكرة (No Memory Leaks)
  @override
  Future<void> close() async {
    await _favoritesSubscription?.cancel();
    await _authSubscription?.cancel();
    return super.close();
  }
}
