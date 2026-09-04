import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<dynamic> items;
  final double totalCost;
  final String paymentMethod;
  final String address;
  final DateTime createdAt;
  final String status;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalCost,
    required this.paymentMethod,
    required this.address,
    required this.createdAt,
    this.status = 'Processing', // حالة الطلب الافتراضية
  });

  // تحويل البيانات لـ Map عشان نرفعها لـ Firebase
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'items': items
          .map(
            (e) => {
              'productId': e.product.id,
              'name': e.product.name,
              'price': e.product.price,
              'quantity': e.quantity,
              'size': e.selectedSize,
              'image': e.product.images.isNotEmpty
                  ? e.product.images.first
                  : '',
            },
          )
          .toList(),
      'totalCost': totalCost,
      'paymentMethod': paymentMethod,
      'address': address,
      'createdAt': Timestamp.fromDate(createdAt),
      'status': status,
    };
  }

  // 💡 إضافة دالة القراءة من فايربيز
  factory OrderModel.fromJson(Map<String, dynamic> json, String documentId) {
    return OrderModel(
      id: documentId,
      userId: json['userId'] ?? '',
      // هنقرأ المنتجات كقائمة من الـ Maps لتسهيل عرضها في الـ UI
      items: json['items'] ?? [],
      totalCost: (json['totalCost'] ?? 0.0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',
      address: json['address'] ?? '',
      createdAt: _readDate(json['createdAt']),
      status: json['status'] ?? 'Processing',
    );
  }

  static DateTime _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }
}
