import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PlaceholderImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final IconData icon;

  const PlaceholderImage({
    super.key,
    required this.imagePath,
    this.width = 300,
    this.height = 300,
    this.icon = Icons.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 80,
          color: Colors.white.withAlpha(204), // 0.8 opacity = 204 alpha (255 * 0.8)
        ),
      ),
    );
  }
}
