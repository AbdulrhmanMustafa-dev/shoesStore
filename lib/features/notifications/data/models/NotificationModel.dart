import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive_ce.dart';
part 'NotificationModel.g.dart';

@HiveType(typeId: 3) // تأكد إن رقم 3 مش مستخدم في موديل تاني
class NotificationModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String imageUrl;
  @HiveField(3)
  final double currentPrice;
  @HiveField(4)
  final double oldPrice;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final bool isUnread;
  @HiveField(7, defaultValue: '')
  final String productId;

  // داخل الـ Constructor:

  // داخل الـ fromJson:

  NotificationModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.currentPrice,
    required this.oldPrice,
    required this.createdAt,
    this.isUnread = true,
    required this.productId,
  });

  factory NotificationModel.fromJson(
    Map<String, dynamic> json,
    String documentId,
  ) {
    return NotificationModel(
      id: documentId,
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      currentPrice: (json['currentPrice'] ?? 0.0).toDouble(),
      oldPrice: (json['oldPrice'] ?? 0.0).toDouble(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      isUnread: json['isUnread'] ?? true,
      productId: json['productId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'currentPrice': currentPrice,
      'oldPrice': oldPrice,
      'createdAt': createdAt,
      'isUnread': isUnread,
      'productId': productId,
    };
  }
}
