class BrandModel {
  final String id;
  final String title;
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
