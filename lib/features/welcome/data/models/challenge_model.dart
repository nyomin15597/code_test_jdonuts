class ChallengeModel {
  final int id;
  final String title;
  final String type; // donut or coffee
  final int progress;
  final int target;
  final int points;
  final String tab;

  const ChallengeModel({
    required this.id,
    required this.title,
    required this.type,
    required this.progress,
    required this.target,
    required this.points,
    required this.tab,
  });

  factory ChallengeModel.fromMap(Map<String, dynamic> map) {
    return ChallengeModel(
      id: map['id'] as int,
      title: map['title'] as String,
      type: map['type'] as String,
      progress: map['progress'] as int,
      target: map['target'] as int,
      points: map['points'] as int,
      tab: map['tab'] as String,
    );
  }

  bool get isCompleted => progress >= target;
}