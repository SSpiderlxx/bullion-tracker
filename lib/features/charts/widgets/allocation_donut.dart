import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class AllocationDonut extends StatelessWidget {
  const AllocationDonut({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 80,
        sections: [
          PieChartSectionData(
            color: AppColors.gold,
            value: 70,
            title: '70%',
            radius: 30,
            titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            color: AppColors.silver,
            value: 30,
            title: '30%',
            radius: 30,
            titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
