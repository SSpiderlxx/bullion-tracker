import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/animated_value.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/portfolio_summary.dart';
import 'daily_change_indicator.dart';

class PortfolioValueCard extends StatelessWidget {
  final PortfolioSummary summary;

  const PortfolioValueCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24.0),
      borderRadius: BorderRadius.circular(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Portfolio Value',
            style: GoogleFonts.inter(
              color: AppColors.textSecondaryDark ?? Colors.grey[400],
              fontSize: 15,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          AnimatedValue(
            value: summary.currentValue,
            format: (val) => CurrencyFormatter.format(val),
            style: GoogleFonts.inter(
              color: AppColors.textPrimaryDark ?? Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              letterSpacing: -1.5,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          DailyChangeIndicator(
            amount: summary.dailyChange,
            percentage: summary.dailyChangePercent,
          ),
        ],
      ),
    );
  }
}
