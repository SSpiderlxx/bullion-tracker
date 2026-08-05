import 'package:flutter/material.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../domain/entities/metal_type.dart';

class AlertCard extends StatelessWidget {
  final MetalType metal;
  final double targetPrice;
  final bool isAbove;
  final bool isEnabled;

  const AlertCard({
    super.key,
    required this.metal,
    required this.targetPrice,
    required this.isAbove,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Icon(Icons.notifications_active, color: metal.displayColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${metal.displayName} ${isAbove ? 'Above' : 'Below'}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('\$ $targetPrice', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (val) {},
            activeColor: metal.displayColor,
          ),
        ],
      ),
    );
  }
}
