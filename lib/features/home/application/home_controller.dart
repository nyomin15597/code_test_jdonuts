import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../../../core/network/api_client.dart';
import '../../../shared/providers/database_provider.dart';
import 'home_providers.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final homeControllerProvider = Provider<HomeController>((ref) {
  return HomeController(ref);
});

class HomeController {
  final Ref ref;

  HomeController(this.ref);

  Future<bool> refreshFromServer() async {
    final connectivity = await Connectivity().checkConnectivity();

    final hasConnection = connectivity.any(
          (item) => item != ConnectivityResult.none,
    );

    if (!hasConnection) return false;

    try {
      final data = await ref
          .read(apiClientProvider)
          .getHomeData();

      final db = await ref
          .read(databaseProvider)
          .database;

      await db.transaction((txn) async {
        await _replaceList(
          txn,
          'products',
          data['products'],
        );

        await _replaceList(
          txn,
          'banners',
          data['banners'],
        );

        await _replaceList(
          txn,
          'sections',
          data['sections'],
        );

        await _replaceList(
          txn,
          'shops',
          data['shops'],
        );

        final member = data['member'];

        if (member is Map) {
          await txn.insert(
            'members',
            Map<String, Object?>.from(member),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        await txn.insert(
          'app_meta',
          {
            'key': 'last_sync_at',
            'value': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });

      ref.invalidate(productsProvider);
      ref.invalidate(bannersProvider);
      ref.invalidate(sectionsProvider);
      ref.invalidate(shopsProvider);
      ref.invalidate(memberProvider);

      return true;
    } catch (_) {
      // Keep local database data if the API is unavailable.
      return false;
    }
  }

  Future<void> _replaceList(
      Transaction txn,
      String table,
      dynamic value,
      ) async {
    if (value is! List) return;

    final batch = txn.batch();

    for (final item in value) {
      if (item is Map) {
        batch.insert(
          table,
          Map<String, Object?>.from(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }

    await batch.commit(noResult: true);
  }
}