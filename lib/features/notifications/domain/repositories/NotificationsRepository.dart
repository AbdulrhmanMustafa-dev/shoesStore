import 'package:kicksvibe/features/notifications/data/models/NotificationModel.dart';

abstract class NotificationsRepository {
  Stream<List<NotificationModel>> watchNotifications(String userId);
}
