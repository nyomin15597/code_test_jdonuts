import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  final double height;

  const AppLoading({
    super.key,
    this.height = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, _) {
          return const SizedBox(width: 12);
        },
        itemBuilder: (context, index) {
          return Container(
            width: 145,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
          );
        },
      ),
    );
  }
}