import 'dart:convert';

class SectionModel {
  final int id;
  final String title;
  final String type;
  final List<int> productIds;

  const SectionModel({
    required this.id,
    required this.title,
    required this.type,
    required this.productIds,
  });

  factory SectionModel.fromMap(Map<String, dynamic> map) {
    final decoded = jsonDecode(
      map['product_ids']?.toString() ?? '[]',
    ) as List<dynamic>;

    return SectionModel(
      id: map['id'] as int,
      title: map['title']?.toString() ?? '',
      type: map['type']?.toString() ?? '',
      productIds: decoded.map((e) => (e as num).toInt()).toList(),
    );
  }
}