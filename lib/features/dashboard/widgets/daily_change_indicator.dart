import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

class DailyChangeIndicator extends StatelessWidget {
  final double amount;
  final double percentage;

  const DailyChangeIndicator({
    super.key,
    required this.amount,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = amount >= 0;
    final color = isPositive ? AppColors.profit : AppColors.loss;
    final icon = isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    final prefix = isPositive ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            '$prefix${CurrencyFormatter.format(amount)} (${percentage.toStringAsFixed(2)}%)',
            style: GoogleFonts.inter(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Today',
            style: GoogleFonts.inter(
              color: color.withOpacity(0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
