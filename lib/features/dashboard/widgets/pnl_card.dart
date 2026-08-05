import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/profit_loss_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/portfolio_summary.dart';

class PnlCard extends StatelessWidget {
  final PortfolioSummary summary;

  const PnlCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final isProfit = summary.totalProfitLoss >= 0;
    final glowColor = isProfit ? AppColors.profit : AppColors.loss;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Invested',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondaryDark ?? Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  CurrencyFormatter.format(summary.totalInvested),
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimaryDark ?? Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              width: 1,
              height: 40,
              color: AppColors.surfaceDark.withOpacity(0.5),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'All-Time P&L',
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondaryDark ?? Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ProfitLossText(
                  amount: summary.totalProfitLoss,
                  percentage: summary.profitLossPercent,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  showBackground: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
