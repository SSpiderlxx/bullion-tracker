import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class PurchaseHistoryChart extends StatelessWidget {
  const PurchaseHistoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: AppColors.gold)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: AppColors.silver)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 14, color: AppColors.gold)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 15, color: AppColors.silver)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 13, color: AppColors.gold)]),
        ],
      ),
    );
  }
}
