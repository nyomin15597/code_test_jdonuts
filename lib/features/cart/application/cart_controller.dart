import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/database_provider.dart';
import '../data/cart_repository.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepository(ref.watch(databaseProvider));
});

final cartItemsProvider =
FutureProvider<List<Map<String, dynamic>>>((ref) {
  return ref.watch(cartRepositoryProvider).getCart();
});

final cartQuantityProvider = FutureProvider<int>((ref) {
  return ref.watch(cartRepositoryProvider).getTotalQuantity();
});

final cartTotalProvider = FutureProvider<int>((ref) {
  return ref.watch(cartRepositoryProvider).getTotalPrice();
});

final cartControllerProvider = Provider<CartController>((ref) {
  return CartController(ref);
});

class CartController {
  final Ref ref;

  CartController(this.ref);

  Future<void> addProduct(
      int productId,
      int quantity,
      ) async {
    await ref.read(cartRepositoryProvider).addProduct(
      productId,
      quantity,
    );

    _refresh();
  }

  Future<void> removeProduct(int productId) async {
    await ref.read(cartRepositoryProvider).removeProduct(productId);

    _refresh();
  }

  void _refresh() {
    ref.invalidate(cartItemsProvider);
    ref.invalidate(cartQuantityProvider);
    ref.invalidate(cartTotalProvider);
  }
}