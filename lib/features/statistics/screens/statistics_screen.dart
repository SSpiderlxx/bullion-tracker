import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/performance_meter.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PerformanceMeter(value: 12.5),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: StatCard(title: 'Gold Avg Buy', value: '£1,450 /oz', icon: Icons.diamond, color: AppColors.gold)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: 'Silver Avg Buy', value: '£22.50 /oz', icon: Icons.diamond_outlined, color: AppColors.silver)),
            ],
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: StatCard(title: 'Total Gold', value: '4.5 oz', icon: Icons.scale, color: AppColors.gold)),
              const SizedBox(width: 16),
              Expanded(child: StatCard(title: 'Total Silver', value: '120 oz', icon: Icons.scale, color: AppColors.silver)),
            ],
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 16),
          const StatCard(title: 'Total Premium Paid', value: '£450.00', icon: Icons.money_off, color: Colors.orange).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),
          const StatCard(title: 'Best Purchase', value: '1oz Gold Britannia (+24%)', icon: Icons.arrow_upward, color: AppColors.profit).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 16),
          const StatCard(title: 'Worst Purchase', value: '1kg Silver Bar (-5%)', icon: Icons.arrow_downward, color: AppColors.loss).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }
}
