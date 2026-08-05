import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';

class PerformanceMeter extends StatelessWidget {
  final double value;

  const PerformanceMeter({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final isProfit = value >= 0;
    final color = isProfit ? AppColors.profit : AppColors.loss;

    return GlassCard(
      child: Column(
        children: [
          const Text('Historical ROI', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(isProfit ? Icons.arrow_upward : Icons.arrow_downward, color: color),
              Text(
                '${value.abs()}%',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
