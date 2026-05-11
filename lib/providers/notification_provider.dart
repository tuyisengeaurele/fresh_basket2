import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final _repo = NotificationRepository();

  List<NotificationItem> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  StreamSubscription<List<NotificationItem>>? _notifSub;
  StreamSubscription<int>? _countSub;

  List<NotificationItem> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  void initialize(String userId) {
    _notifSub?.cancel();
    _countSub?.cancel();

    _notifSub = _repo.watchNotifications(userId).listen((items) {
      _notifications = items;
      notifyListeners();
    });

    _countSub = _repo.watchUnreadCount(userId).listen((count) {
      _unreadCount = count;
      notifyListeners();
    });
  }

  Future<void> markAsRead(String userId, String notifId) async {
    await _repo.markAsRead(userId, notifId);
  }

  Future<void> markAllAsRead(String userId) async {
    await _repo.markAllAsRead(userId);
  }

  void stopListening() {
    _notifSub?.cancel();
    _countSub?.cancel();
    _notifications = [];
    _unreadCount = 0;
  }

  @override
  void dispose() {
    _notifSub?.cancel();
    _countSub?.cancel();
    super.dispose();
  }
}
