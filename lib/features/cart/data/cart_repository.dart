import 'package:sqflite/sqflite.dart';

import '../../../core/database/app_database.dart';

class CartRepository {
  final AppDatabase database;

  CartRepository(this.database);

  Future<Database> get _db => database.database;

  Future<void> addProduct(int productId, int quantity) async {
    final db = await _db;

    await db.transaction((txn) async {
      final result = await txn.query(
        'cart',
        columns: ['quantity'],
        where: 'product_id = ?',
        whereArgs: [productId],
        limit: 1,
      );

      if (result.isEmpty) {
        await txn.insert('cart', {
          'product_id': productId,
          'quantity': quantity,
        });
      } else {
        final oldQuantity =
        (result.first['quantity'] as num).toInt();

        await txn.update(
          'cart',
          {'quantity': oldQuantity + quantity},
          where: 'product_id = ?',
          whereArgs: [productId],
        );
      }
    });
  }

  Future<void> updateQuantity(
      int productId,
      int quantity,
      ) async {
    final db = await _db;

    if (quantity <= 0) {
      await removeProduct(productId);
      return;
    }

    await db.update(
      'cart',
      {'quantity': quantity},
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> removeProduct(int productId) async {
    final db = await _db;

    await db.delete(
      'cart',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<List<Map<String, dynamic>>> getCart() async {
    final db = await _db;

    return db.rawQuery('''
      SELECT
        cart.product_id,
        cart.quantity,
        products.name,
        products.price,
        products.image
      FROM cart
      INNER JOIN products
      ON products.id = cart.product_id
    ''');
  }

  Future<int> getTotalQuantity() async {
    final db = await _db;

    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(quantity), 0) AS total FROM cart',
    );

    return (result.first['total'] as num).toInt();
  }

  Future<int> getTotalPrice() async {
    final db = await _db;

    final result = await db.rawQuery('''
      SELECT COALESCE(SUM(cart.quantity * products.price), 0) AS total
      FROM cart
      INNER JOIN products
      ON products.id = cart.product_id
    ''');

    return (result.first['total'] as num).toInt();
  }
}