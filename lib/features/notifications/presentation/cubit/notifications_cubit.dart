import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/notifications/data/models/NotificationModel.dart';
import 'package:kicksvibe/features/notifications/data/repositories/NotificationsRepositoryImpl.dart'; // مسار الـ Implementation
part 'notifications_state.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;
  StreamSubscription? _subscription;

  NotificationsCubit(this._repository) : super(NotificationsInitial()) {
    _loadNotifications();
  }

  void _loadNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    emit(NotificationsLoading());

    _subscription = _repository.watchNotifications(user.uid).listen((
      notifications,
    ) {
      emit(NotificationsLoaded(notifications));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
