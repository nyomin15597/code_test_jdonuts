import 'package:flutter_riverpod/flutter_riverpod.dart';

final productQuantityProvider =
StateProvider.family<int, int>((ref, productId) => 1);