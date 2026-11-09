import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jdonuts/core/constants/app_colors.dart';

import '../../../../core/widgets/app_error.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../application/home_controller.dart';
import '../application/home_providers.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/member_card.dart';
import 'widgets/product_section.dart';
import 'widgets/shop_section.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(homeControllerProvider).refreshFromServer();
      }
    });
  }

  Future<void> _refresh() async {
    await ref.read(homeControllerProvider).refreshFromServer();

    ref.invalidate(productsProvider);
    ref.invalidate(bannersProvider);
    ref.invalidate(sectionsProvider);
    ref.invalidate(shopsProvider);
    ref.invalidate(memberProvider);
  }

  @override
  Widget build(BuildContext context) {
    final member = ref.watch(memberProvider);
    final banners = ref.watch(bannersProvider);
    final sections = ref.watch(sectionsProvider);
    final shops = ref.watch(shopsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const OfflineBanner(),

          Expanded(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 18),
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFFEAD0),
                          Color(0xFFFFE0C2),
                          Color(0xFFF4F5F7),
                        ],
                        stops: [0.0, 0.65, 1.0],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        // Member profile header.
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: member.when(
                                  data: (data) {
                                    if (data == null) {
                                      return const Text(
                                        'Member profile not found.',
                                      );
                                    }

                                    return MemberCard(member: data);
                                  },
                                  loading: () => const SizedBox(
                                    height: 85,
                                    child: AppLoading(),
                                  ),
                                  error: (error, stack) => const Text(
                                    'Unable to load member profile.',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),

                        // Promotion banners.
                        Padding(
                          padding: const EdgeInsets.only(left: 16, bottom: 24),
                          child: banners.when(
                            data: (data) => BannerCarousel(banners: data),
                            loading: () => const SizedBox(
                              height: 165,
                              child: AppLoading(),
                            ),
                            error: (error, stack) => const Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: AppError(
                                message: 'Unable to load banners.',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Product sections.
                  sections.when(
                    data: (items) {
                      if (items.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No products available.'),
                        );
                      }

                      return Column(
                        children: items.map((section) {
                          final products = ref.watch(
                            sectionProductsProvider(
                              section.productIds,
                            ),
                          );

                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 22, left: 15, right: 15
                            ),
                            child: products.when(
                              data: (data) => ProductSection(
                                title: section.title,
                                products: data,
                                onProductTap: (id) {
                                  context.push('/product/$id');
                                },
                              ),
                              loading: () => const SizedBox(
                                height: 190,
                                child: AppLoading(),
                              ),
                              error: (error, stack) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  '${section.title} could not be loaded.',
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const SizedBox(
                      height: 200,
                      child: AppLoading(),
                    ),
                    error: (error, stack) => const AppError(
                      message: 'Unable to load product sections.',
                    ),
                  ),

                  // Nearby shops section.
                  shops.when(
                    data: (data) => ShopSection(shops: data),
                    loading: () => const SizedBox(
                      height: 180,
                      child: AppLoading(),
                    ),
                    error: (error, stack) => const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Unable to load nearby shops.'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}