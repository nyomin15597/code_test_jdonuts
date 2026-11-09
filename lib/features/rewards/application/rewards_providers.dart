import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/database_provider.dart';
import '../../welcome/data/models/challenge_model.dart';

final rewardsChallengesProvider =
FutureProvider<List<ChallengeModel>>((ref) async {
  final appDatabase = ref.watch(databaseProvider);
  final db = await appDatabase.database;

  final result = await db.query(
    'rewards_challenges',
    orderBy: 'id ASC',
  );

  return result.map(ChallengeModel.fromMap).toList();
});