
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/app_constants.dart';

class AppDatabase {
    AppDatabase._();

    static final AppDatabase instance = AppDatabase._();

    Database? _database;

    Future<Database> get database async {
        if (_database != null) return _database!;

        _database = await _initDatabase();
        return _database!;
    }

    Future<Database> _initDatabase() async {
        final dbPath = await getDatabasesPath();

        final path = join(
            dbPath,
            AppConstants.databaseName,
        );

        return openDatabase(
            path,
            version: AppConstants.databaseVersion,
            onConfigure: (db) async {
                await db.execute('PRAGMA foreign_keys = ON');
            },
            onCreate: _onCreate,
            onUpgrade: _onUpgrade,
        );
    }

// =========================
// CREATE DATABASE
// =========================

    Future<void> _onCreate(
        Database db,
        int version,
        ) async {

// PRODUCTS
        await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        code TEXT,
        name TEXT,
        description TEXT,
        price INTEGER,
        image TEXT,
        is_new INTEGER DEFAULT 0,
        discount INTEGER DEFAULT 0,
        category TEXT
      )
    ''');

// BANNERS
        await db.execute('''
      CREATE TABLE banners (
        id INTEGER PRIMARY KEY,
        title TEXT,
        image TEXT,
        sort_order INTEGER
      )
    ''');

// SECTIONS
        await db.execute('''
      CREATE TABLE sections (
        id INTEGER PRIMARY KEY,
        title TEXT,
        type TEXT,
        product_ids TEXT,
        sort_order INTEGER
      )
    ''');

// SHOPS
        await db.execute('''
      CREATE TABLE shops (
        id INTEGER PRIMARY KEY,
        name TEXT,
        address TEXT,
        image TEXT,
        distance TEXT
      )
    ''');

// MEMBERS
        await db.execute('''
      CREATE TABLE members (
        id INTEGER PRIMARY KEY,
        name TEXT,
        image TEXT,
        tier TEXT,
        points INTEGER,
        next_tier TEXT,
        points_to_next INTEGER
      )
    ''');

// CART
        await db.execute('''
      CREATE TABLE cart (
        product_id INTEGER PRIMARY KEY,
        quantity INTEGER NOT NULL,
        FOREIGN KEY(product_id)
          REFERENCES products(id)
      )
    ''');

// REWARDS CHALLENGES
        await db.execute('''
      CREATE TABLE rewards_challenges (
        id INTEGER PRIMARY KEY,
        title TEXT NOT NULL,
        type TEXT NOT NULL,
        progress INTEGER NOT NULL,
        target INTEGER NOT NULL,
        points INTEGER NOT NULL,
        tab TEXT NOT NULL
      )
    ''');

// APP META
        await db.execute('''
      CREATE TABLE app_meta (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

// USER PROFILE
        await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        phone TEXT NOT NULL UNIQUE,
        first_name TEXT,
        last_name TEXT,
        dob TEXT
      )
    ''');
    }

// =========================
// DATABASE MIGRATION
// =========================

    Future<void> _onUpgrade(
        Database db,
        int oldVersion,
        int newVersion,
        ) async {

// VERSION 1 -> 2
        if (oldVersion < 2) {
            await db.execute('''
        CREATE TABLE IF NOT EXISTS rewards_challenges (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          type TEXT NOT NULL,
          progress INTEGER NOT NULL,
          target INTEGER NOT NULL,
          points INTEGER NOT NULL,
          tab TEXT NOT NULL
        )
      ''');
        }

// VERSION 2 -> 3
        if (oldVersion < 3) {
            await db.execute('''
        CREATE TABLE IF NOT EXISTS user_profile (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          phone TEXT NOT NULL UNIQUE,
          first_name TEXT,
          last_name TEXT,
          dob TEXT
        )
      ''');
        }
    }

// =========================
// USER PROFILE OPERATIONS
// =========================

    Future<void> saveUser({
        required String phone,
        required String firstName,
        required String lastName,
        required String dob,
    }) async {
        final db = await database;

        await db.insert(
            'user_profile',
            {
                'phone': phone,
                'first_name': firstName,
                'last_name': lastName,
                'dob': dob,
            },
            conflictAlgorithm: ConflictAlgorithm.replace,
        );
    }

    Future<Map<String, dynamic>?> getUser(
        String phone,
        ) async {
        final db = await database;

        final result = await db.query(
            'user_profile',
            where: 'phone = ?',
            whereArgs: [phone],
            limit: 1,
        );

        if (result.isEmpty) return null;

        return result.first;
    }

    Future<void> deleteUser(String phone) async {
        final db = await database;

        await db.delete(
            'user_profile',
            where: 'phone = ?',
            whereArgs: [phone],
        );
    }

// =========================
// CLOSE DATABASE
// =========================

    Future<void> close() async {
        await _database?.close();
        _database = null;
    }
}