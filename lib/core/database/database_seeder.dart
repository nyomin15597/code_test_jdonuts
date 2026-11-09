
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class DatabaseSeeder {
  static const String seedVersion = '2.0.0';

  static Future<void> seed() async {
    final db = await AppDatabase.instance.database;

    final meta = await db.query(
      'app_meta',
      where: 'key = ?',
      whereArgs: ['seed_version'],
      limit: 1,
    );

    // Already seeded with the latest version.
    if (meta.isNotEmpty &&
        meta.first['value'] == seedVersion) {
      return;
    }

    final jsonString = await rootBundle.loadString(
      'assets/data/seed_data.json',
    );

    final Map<String, dynamic> data =
    jsonDecode(jsonString) as Map<String, dynamic>;

    // Rewards challenges
    final challenges = [
      {
        'id': 1,
        'title': 'Eat 4 Coco donuts',
        'type': 'donut',
        'progress': 4,
        'target': 4,
        'points': 100,
        'tab': 'earn',
      },
      {
        'id': 2,
        'title': 'Eat 4 Coco donuts',
        'type': 'donut',
        'progress': 1,
        'target': 4,
        'points': 100,
        'tab': 'earn',
      },
      {
        'id': 3,
        'title': 'Drink 12 cups americano',
        'type': 'coffee',
        'progress': 9,
        'target': 12,
        'points': 100,
        'tab': 'earn',
      },
      {
        'id': 4,
        'title': 'Share a donut with a friend',
        'type': 'donut',
        'progress': 1,
        'target': 1,
        'points': 50,
        'tab': 'gift',
      },
    ];

    await db.transaction((txn) async {
      // Products
      for (final item in data['products'] ?? []) {
        await txn.insert(
          'products',
          Map<String, Object?>.from(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Banners
      for (final item in data['banners'] ?? []) {
        await txn.insert(
          'banners',
          Map<String, Object?>.from(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Sections
      for (final item in data['sections'] ?? []) {
        await txn.insert(
          'sections',
          Map<String, Object?>.from(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Shops
      for (final item in data['shops'] ?? []) {
        await txn.insert(
          'shops',
          Map<String, Object?>.from(item),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Member
      await txn.insert(
        'members',
        Map<String, Object?>.from(data['member']),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Rewards challenges
      for (final challenge in challenges) {
        await txn.insert(
          'rewards_challenges',
          challenge,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Update seed version
      await txn.insert(
        'app_meta',
        {
          'key': 'seed_version',
          'value': seedVersion,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }
}
