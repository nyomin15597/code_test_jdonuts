import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/connectivity_service.dart';

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(isOnlineProvider);

    if (online) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 20,bottom: 8,
        left: 16,right: 16
      ),
      color: Colors.orange.shade100,
      child: const Row(
        children: [
          Icon(Icons.wifi_off, size: 18),
          SizedBox(width: 8),
          Text(
            'You are offline. Showing saved data.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}