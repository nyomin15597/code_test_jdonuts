
import 'package:flutter/material.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../data/models/product_model.dart';

class ProductSection extends StatelessWidget {
  final String title;
  final List<ProductModel> products;
  final ValueChanged<int> onProductTap;

  const ProductSection({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
  });

  static const Color orange = Color(0xFFFF8127);

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF30343A),
                ),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_right,
                size: 19,
                color: Color(0xFF555555),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 205,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: 11),
            itemBuilder: (context, index) {
              final product = products[index];

              return InkWell(
                onTap: () => onProductTap(product.id),
                borderRadius: BorderRadius.circular(13),
                child: SizedBox(
                  width: 145,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  product.image,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) {
                                    return const Icon(
                                      Icons.bakery_dining,
                                      size: 65,
                                      color: Color(0xFFD8A27E),
                                    );
                                  },
                                ),
                              ),
                              if (product.isNew)
                                const Align(
                                  alignment: Alignment.topLeft,
                                  child: _ProductTag(
                                    label: 'New',
                                  ),
                                ),
                              if (product.discount > 0)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: _ProductTag(
                                    label: '${product.discount}% off',
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF30343A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${CurrencyFormatter.format(product.price)} MMK',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductTag extends StatelessWidget {
  final String label;

  const _ProductTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFF8127),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
