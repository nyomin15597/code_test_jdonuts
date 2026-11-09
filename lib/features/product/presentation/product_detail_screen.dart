import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../cart/application/cart_controller.dart';
import '../../home/application/home_providers.dart';
import '../application/product_controller.dart';

class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  static const Color blue = Color(0xFF55CBE5);
  static const Color orange = Color(0xFFFF801C);
  static const Color background = Color(0xFFF0F1F2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(productProvider(productId));
    final quantity = ref.watch(productQuantityProvider(productId));

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: product.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: blue),
          ),
          error: (error, stack) => const Center(
            child: Text('Unable to load product.'),
          ),
          data: (item) {
            if (item == null) {
              return const Center(child: Text('Product not found.'));
            }

            final total = item.price * quantity;

            return Column(
              children: [
                // Back button.
                SizedBox(
                  height: 58,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    child: Column(
                      children: [
                        // Main product card.
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.code,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFF92999E),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF202328),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${CurrencyFormatter.format(item.price)} MMK',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (item.isNew)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 13,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: orange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Text(
                                        'New',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Product image.
                              SizedBox(
                                width: double.infinity,
                                height: 245,
                                child: Image.asset(
                                  item.image,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) {
                                    return const Icon(
                                      Icons.bakery_dining,
                                      size: 130,
                                      color: Color(0xFFD89B72),
                                    );
                                  },
                                ),
                              ),

                              // Quantity selector.
                              Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F1F2),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _QuantityButton(
                                        icon: Icons.remove,
                                        onTap: quantity > 1
                                            ? () {
                                          ref
                                              .read(
                                            productQuantityProvider(
                                              productId,
                                            ).notifier,
                                          )
                                              .state--;
                                        }
                                            : null,
                                      ),
                                      SizedBox(
                                        width: 48,
                                        child: Text(
                                          '$quantity',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      _QuantityButton(
                                        icon: Icons.add,
                                        onTap: () {
                                          ref
                                              .read(
                                            productQuantityProvider(
                                              productId,
                                            ).notifier,
                                          )
                                              .state++;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Product description.
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 55,
                              child: Column(
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF8CCB48),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.question_mark,
                                      size: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    "What's\nthis?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      height: 1.2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 1,
                              height: 65,
                              color: const Color(0xFFD7DADD),
                              margin: const EdgeInsets.only(right: 12),
                            ),

                            Expanded(
                              child: Text(
                                item.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  height: 1.55,
                                  color: Color(0xFF858B90),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Add to cart.
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await ref
                                    .read(cartControllerProvider)
                                    .addProduct(productId, quantity);

                                ref
                                    .read(
                                  productQuantityProvider(
                                    productId,
                                  ).notifier,
                                )
                                    .state = 1;

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Added to cart successfully.',
                                      ),
                                    ),
                                  );
                              } catch (error) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Could not add product to cart.',
                                      ),
                                    ),
                                  );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const StadiumBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'ADD TO CART',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  height: 20,
                                  width: 1,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${CurrencyFormatter.format(total)} MMK',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF55CBE5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 27,
          height: 27,
          child: Icon(
            icon,
            size: 17,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
