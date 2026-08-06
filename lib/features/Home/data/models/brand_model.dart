
import 'package:hive_ce/hive_ce.dart';
part 'brand_model.g.dart';
@HiveType(typeId: 1)
class BrandModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String iconUrl;

  BrandModel({required this.id, required this.title, required this.iconUrl});
  factory BrandModel.fromJson(Map<String, dynamic> json, String documentId) {
    return BrandModel(
      id: documentId,
      title: json['title'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
    );
  }
}
