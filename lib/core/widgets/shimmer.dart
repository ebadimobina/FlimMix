import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const ShimmerLoadingBox({
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1B2332) : Colors.grey.shade300,
      highlightColor: isDark ? const Color(0xFF28344A) : Colors.grey.shade100,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: width,
          height: height,
          color: isDark ? const Color(0xFF1B2332) : Colors.white,
        ),
      ),
    );
  }
}
