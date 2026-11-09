class MemberModel {
  final int id;
  final String name;
  final String image;
  final String tier;
  final int points;
  final String nextTier;
  final int pointsToNext;

  const MemberModel({
    required this.id,
    required this.name,
    required this.image,
    required this.tier,
    required this.points,
    required this.nextTier,
    required this.pointsToNext,
  });

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['id'] as int,
      name: map['name']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      tier: map['tier']?.toString() ?? '',
      points: (map['points'] as num?)?.toInt() ?? 0,
      nextTier: map['next_tier']?.toString() ?? '',
      pointsToNext: (map['points_to_next'] as num?)?.toInt() ?? 0,
    );
  }
}