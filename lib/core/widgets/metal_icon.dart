import 'package:flutter/material.dart';
import '../constants/bullion_products.dart';
import '../theme/app_colors.dart';

class MetalIcon extends StatelessWidget {
  final MetalType type;
  final double size;

  const MetalIcon({
    super.key,
    required this.type,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData iconData;

    switch (type) {
      case MetalType.gold:
        color = AppColors.gold;
        iconData = Icons.circle; // Placeholder for actual coin/bar icon
        break;
      case MetalType.silver:
        color = AppColors.silver;
        iconData = Icons.circle_outlined;
        break;
      case MetalType.platinum:
        color = Colors.blueGrey;
        iconData = Icons.hexagon;
        break;
      case MetalType.palladium:
        color = Colors.grey.shade400;
        iconData = Icons.hexagon_outlined;
        break;
    }

    if (type == MetalType.gold) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.25),
        child: Image.asset(
          'assets/images/gold_bar.jpg',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallback(color, Icons.monetization_on),
        ),
      );
    } else if (type == MetalType.silver) {
      return ClipOval(
        child: Image.asset(
          'assets/images/silver_coin.jpg',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallback(color, Icons.monetization_on_outlined),
        ),
      );
    }

    return _buildFallback(color, iconData);
  }

  Widget _buildFallback(Color color, IconData iconData) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.8),
            color,
            color.withValues(alpha: 0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          iconData,
          size: size * 0.6,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
  }
}
