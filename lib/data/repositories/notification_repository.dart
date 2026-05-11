import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> payload;
  final bool isRead;
  final DateTime createdAt;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.payload,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return NotificationItem(
      id: doc.id,
      title: m['title'] ?? '',
      body: m['body'] ?? '',
      type: m['type'] ?? '',
      payload: Map<String, dynamic>.from(m['payload'] ?? {}),
      isRead: m['isRead'] ?? false,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'body': body,
        'type': type,
        'payload': payload,
        'isRead': isRead,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}

class NotificationRepository {
  Stream<List<NotificationItem>> watchNotifications(String userId) =>
      FirebaseService.notifications(userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(NotificationItem.fromDoc).toList());

  Stream<int> watchUnreadCount(String userId) =>
      FirebaseService.notifications(userId)
          .where('isRead', isEqualTo: false)
          .snapshots()
          .map((s) => s.size);

  Future<void> markAsRead(String userId, String notifId) async {
    await FirebaseService.notifications(userId).doc(notifId).update({
      'isRead': true,
    });
  }

  Future<void> markAllAsRead(String userId) async {
    final snap = await FirebaseService.notifications(userId)
        .where('isRead', isEqualTo: false)
        .get();
    final batch = FirebaseService.firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<void> saveNotification({
    required String userId,
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? payload,
  }) async {
    await FirebaseService.notifications(userId).add({
      'title': title,
      'body': body,
      'type': type,
      'payload': payload ?? {},
      'isRead': false,
      'createdAt': Timestamp.fromDate(DateTime.now()),
    });
  }
}
