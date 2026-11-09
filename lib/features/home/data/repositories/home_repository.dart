import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../models/banner_model.dart';
import '../models/member_model.dart';
import '../models/product_model.dart';
import '../models/section_model.dart';
import '../models/shop_model.dart';

class HomeRepository {
  final AppDatabase database;

  HomeRepository(this.database);

  Future<Database> get _db => database.database;

  Future<List<ProductModel>> getProducts() async {
    final db = await _db;

    final result = await db.query(
      'products',
      orderBy: 'id ASC',
    );

    return result.map(ProductModel.fromMap).toList();
  }

  Future<ProductModel?> getProduct(int id) async {
    final db = await _db;

    final result = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return ProductModel.fromMap(result.first);
  }

  Future<List<BannerModel>> getBanners() async {
    final db = await _db;

    final result = await db.query(
      'banners',
      orderBy: 'sort_order ASC',
    );

    return result.map(BannerModel.fromMap).toList();
  }

  Future<List<SectionModel>> getSections() async {
    final db = await _db;

    final result = await db.query(
      'sections',
      orderBy: 'sort_order ASC',
    );

    return result.map(SectionModel.fromMap).toList();
  }

  Future<List<ShopModel>> getShops() async {
    final db = await _db;

    final result = await db.query('shops');

    return result.map(ShopModel.fromMap).toList();
  }

  Future<MemberModel?> getMember() async {
    final db = await _db;

    final result = await db.query(
      'members',
      limit: 1,
    );

    if (result.isEmpty) return null;

    return MemberModel.fromMap(result.first);
  }

  Future<List<ProductModel>> getProductsByIds(
      List<int> ids,
      ) async {
    if (ids.isEmpty) return [];

    final db = await _db;

    final placeholders = List.filled(ids.length, '?').join(',');

    final result = await db.rawQuery(
      'SELECT * FROM products WHERE id IN ($placeholders)',
      ids,
    );

    final products = result.map(ProductModel.fromMap).toList();

    final order = {
      for (var i = 0; i < ids.length; i++) ids[i]: i,
    };

    products.sort(
          (a, b) => order[a.id]!.compareTo(order[b.id]!),
    );

    return products;
  }
}