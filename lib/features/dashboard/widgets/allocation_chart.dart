import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../domain/entities/portfolio_summary.dart';

class AllocationChart extends StatelessWidget {
  final PortfolioSummary summary;

  const AllocationChart({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final goldPerc = summary.goldAllocationPercent;
    final silverPerc = summary.silverAllocationPercent;
    
    // Fallback if empty portfolio
    final hasAllocations = goldPerc > 0 || silverPerc > 0;

    return GlassCard(
      padding: const EdgeInsets.all(20.0),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Portfolio Allocation',
            style: GoogleFonts.inter(
              color: AppColors.textPrimaryDark,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 60,
                    startDegreeOffset: -90,
                    sections: hasAllocations
                        ? [
                            PieChartSectionData(
                              color: AppColors.gold,
                              value: goldPerc,
                              title: '${goldPerc.toStringAsFixed(1)}%',
                              radius: 20,
                              titleStyle: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              color: AppColors.silver,
                              value: silverPerc,
                              title: '${silverPerc.toStringAsFixed(1)}%',
                              radius: 20,
                              titleStyle: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ]
                        : [
                            PieChartSectionData(
                              color: AppColors.surfaceDark,
                              value: 100,
                              title: '',
                              radius: 20,
                            ),
                          ],
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 800),
                  swapAnimationCurve: Curves.easeInOutBack,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Metals',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondaryDark,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '100%',
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimaryDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LegendItem(color: AppColors.gold, label: 'Gold'),
              _LegendItem(color: AppColors.silver, label: 'Silver'),
            ],
          )
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
