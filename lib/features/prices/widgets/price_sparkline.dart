import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceSparkline extends StatelessWidget {
  final List<double> data;
  final Color color;
  final bool isPositive;

  const PriceSparkline({
    super.key,
    required this.data,
    required this.color,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox(height: 60);

    final minY = data.reduce((a, b) => a < b ? a : b);
    final maxY = data.reduce((a, b) => a > b ? a : b);
    final range = maxY - minY;
    
    // Add some padding to Y axis to prevent cutting off the line
    final adjustedMinY = minY - (range * 0.1);
    final adjustedMaxY = maxY + (range * 0.1);

    final spots = List.generate(
      data.length,
      (index) => FlSpot(index.toDouble(), data[index]),
    );

    final gradientColors = [
      color.withValues(alpha: 0.5),
      color.withValues(alpha: 0.0),
    ];

    return SizedBox(
      height: 60,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (data.length - 1).toDouble(),
          minY: adjustedMinY,
          maxY: adjustedMaxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: color,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }
}
