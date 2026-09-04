import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/notifications/data/models/NotificationModel.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationModel>> watchNotifications(String userId);
}

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final FirebaseFirestore _firestore;

  NotificationsRepositoryImpl(this._firestore);

  @override
  Stream<List<NotificationModel>> watchNotifications(String userId) async* {
    // 1. فتح صندوق Hive الخاص بالمستخدم
    final box = await Hive.openBox<NotificationModel>('notifications_$userId');

    // 2. إرجاع البيانات المحفوظة محلياً (لو موجودة) لعرضها فوراً
    if (box.isNotEmpty) {
      yield box.values.toList();
    }

    // 3. الاستماع لفايربيز وتحديث Hive بالبيانات الجديدة
    yield* _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final remoteNotifications = snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data(), doc.id))
              .toList();

          // حفظ الداتا الجديدة في الجهاز للمرة القادمة
          box.clear();
          box.addAll(remoteNotifications);

          return remoteNotifications;
        });
  }
}
