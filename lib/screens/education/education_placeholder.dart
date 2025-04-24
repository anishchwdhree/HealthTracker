import 'package:flutter/material.dart';

class EducationPlaceholderImage extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const EducationPlaceholderImage({
    super.key,
    required this.icon,
    required this.color,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          icon,
          size: size,
          color: color,
        ),
      ),
    );
  }
}
