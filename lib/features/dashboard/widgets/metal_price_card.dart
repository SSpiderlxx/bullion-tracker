import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/profit_loss_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/metal_price.dart';
import '../../../domain/entities/metal_type.dart';

class MetalPriceCard extends StatelessWidget {
  final MetalPrice price;

  const MetalPriceCard({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final isGold = price.metalType == MetalType.gold;
    final accentColor = isGold ? AppColors.gold : AppColors.silver;
    final name = isGold ? 'Gold' : 'Silver';

    return GlassCard(
      padding: const EdgeInsets.all(16.0),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  isGold ? 'assets/images/gold_bar.jpg' : 'assets/images/silver_coin.jpg',
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: GoogleFonts.inter(
                  color: AppColors.textSecondaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            CurrencyFormatter.format(price.pricePerTroyOz),
            style: GoogleFonts.inter(
              color: AppColors.textPrimaryDark,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          ProfitLossText(
            amount: price.changeAmount24h,
            percentage: price.changePercent24h,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            showBackground: false,
          ),
        ],
      ),
    );
  }
}
