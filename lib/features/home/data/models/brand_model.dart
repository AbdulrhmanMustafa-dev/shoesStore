import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';
part 'brand_model.g.dart';

@HiveType(typeId: 1)
class BrandModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String iconUrl;

  const BrandModel({
    required this.id,
    required this.title,
    required this.iconUrl,
  });

  @override
  List<Object?> get props => [id, title, iconUrl];

  factory BrandModel.fromJson(Map<String, dynamic> json, String documentId) {
    return BrandModel(
      id: documentId,
      title: json['title'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
    );
  }
}
