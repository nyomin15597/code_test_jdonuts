import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/database/database_seeder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseSeeder.seed();

  runApp(
    const ProviderScope(
      child: JDonutsApp(),
    ),
  );
}