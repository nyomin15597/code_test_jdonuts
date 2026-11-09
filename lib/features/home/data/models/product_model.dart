class ProductModel {
  final int id;
  final String code;
  final String name;
  final String description;
  final int price;
  final String image;
  final bool isNew;
  final int discount;
  final String category;

  const ProductModel({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isNew,
    required this.discount,
    required this.category,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int,
      code: map['code']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      image: map['image']?.toString() ?? '',
      isNew: (map['is_new'] as num?)?.toInt() == 1,
      discount: (map['discount'] as num?)?.toInt() ?? 0,
      category: map['category']?.toString() ?? '',
    );
  }
}