
import 'package:flutter/material.dart';
import '../../data/models/shop_model.dart';

class ShopSection extends StatelessWidget {
  final List<ShopModel> shops;

  const ShopSection({
    super.key,
    required this.shops,
  });

  static const Color blue = Color(0xFF55CBE5);

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 22),
      decoration: const BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "There are 4 J'Donut shops",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Text(
            'near you. 😊',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 235,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: shops.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final shop = shops[index];

                return Container(
                  width: 250,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(11),
                        child: Image.asset(
                          shop.image,
                          width: double.infinity,
                          height: 115,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) {
                            return Container(
                              height: 115,
                              color: const Color(0xFFECECEC),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.store,
                                size: 45,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        shop.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        shop.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.25,
                          color: Color(0xFF777777),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'Order Online',
                        style: TextStyle(
                          color: Color(0xFFE95B9B),
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
