class BannerModel {
  final int id;
  final String title;
  final String image;

  const BannerModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['id'] as int,
      title: map['title']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
    );
  }
}