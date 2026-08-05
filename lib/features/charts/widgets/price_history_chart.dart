import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';

class PriceHistoryChart extends StatelessWidget {
  final bool isGold;
  
  const PriceHistoryChart({super.key, required this.isGold});

  @override
  Widget build(BuildContext context) {
    final color = isGold ? AppColors.gold : AppColors.silver;
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 1),
              FlSpot(1, 1.2),
              FlSpot(2, 1.1),
              FlSpot(3, 1.4),
              FlSpot(4, 1.3),
            ],
            isCurved: true,
            color: color,
            barWidth: 2,
            dotData: FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
