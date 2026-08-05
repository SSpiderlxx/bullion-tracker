import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../domain/entities/portfolio_summary.dart';

class HoldingsSummaryCard extends StatelessWidget {
  final PortfolioSummary summary;

  const HoldingsSummaryCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20.0),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Vault',
            style: GoogleFonts.inter(
              color: AppColors.textPrimaryDark ?? Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          _MetalRow(
            metalName: 'Gold',
            color: AppColors.gold,
            ounces: summary.totalGoldOz,
            grams: summary.totalGoldGrams,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(color: Colors.white12, height: 1),
          ),
          _MetalRow(
            metalName: 'Silver',
            color: AppColors.silver,
            ounces: summary.totalSilverOz,
            grams: summary.totalSilverGrams,
          ),
        ],
      ),
    );
  }
}

class _MetalRow extends StatelessWidget {
  final String metalName;
  final Color color;
  final double ounces;
  final double grams;

  const _MetalRow({
    required this.metalName,
    required this.color,
    required this.ounces,
    required this.grams,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(Icons.line_weight_outlined, color: color, size: 16),
            ),
            const SizedBox(width: 12),
            Text(
              metalName,
              style: GoogleFonts.inter(
                color: AppColors.textPrimaryDark ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${ounces.toStringAsFixed(3)} oz',
              style: GoogleFonts.inter(
                color: AppColors.textPrimaryDark ?? Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${grams.toStringAsFixed(1)} g',
              style: GoogleFonts.inter(
                color: AppColors.textSecondaryDark ?? Colors.grey[400],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
