class ShopModel {
  final int id;
  final String name;
  final String address;
  final String image;
  final String distance;

  const ShopModel({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.distance,
  });

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'] as int,
      name: map['name']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      distance: map['distance']?.toString() ?? '',
    );
  }
}