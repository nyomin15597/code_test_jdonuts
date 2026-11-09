import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/database_provider.dart';
import '../data/repositories/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final database = ref.watch(databaseProvider);

  return HomeRepository(database);
});

final productsProvider = FutureProvider((ref) {
  return ref.watch(homeRepositoryProvider).getProducts();
});

final bannersProvider = FutureProvider((ref) {
  return ref.watch(homeRepositoryProvider).getBanners();
});

final sectionsProvider = FutureProvider((ref) {
  return ref.watch(homeRepositoryProvider).getSections();
});

final shopsProvider = FutureProvider((ref) {
  return ref.watch(homeRepositoryProvider).getShops();
});

final memberProvider = FutureProvider((ref) {
  return ref.watch(homeRepositoryProvider).getMember();
});

final productProvider = FutureProvider.family((ref, int id) {
  return ref.watch(homeRepositoryProvider).getProduct(id);
});

final sectionProductsProvider =
FutureProvider.family((ref, List<int> ids) {
  return ref.watch(homeRepositoryProvider).getProductsByIds(ids);
});