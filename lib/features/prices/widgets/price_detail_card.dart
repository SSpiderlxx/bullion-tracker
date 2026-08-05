import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/profit_loss_text.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/metal_price.dart';
import '../../../domain/entities/metal_type.dart';
import '../../../data/providers/price_providers.dart';
import 'price_sparkline.dart';

class PriceDetailCard extends HookConsumerWidget {
  final MetalPrice price;

  const PriceDetailCard({
    super.key,
    required this.price,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGold = price.metalType == MetalType.gold;
    final accentColor = isGold ? AppColors.gold : AppColors.silver;
    final metalName = isGold ? 'Gold' : 'Silver';

    final historyAsync = ref.watch(priceHistoryProvider((metal: price.metalType, days: 7)));

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(24.0),
        borderRadius: BorderRadius.circular(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        isGold ? 'assets/images/gold_bar.jpg' : 'assets/images/silver_coin.jpg',
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                          ),
                          child: Center(
                            child: Text(
                              isGold ? 'Au' : 'Ag',
                              style: GoogleFonts.inter(
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      metalName,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimaryDark,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                ProfitLossText(
                  amount: price.changeAmount24h,
                  percentage: price.changePercent24h,
                  showBackground: true,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price per troy oz',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondaryDark,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyFormatter.format(price.pricePerTroyOz),
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimaryDark,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: historyAsync.when(
                    data: (history) {
                      final sparklineData = history.map((p) => p.pricePerTroyOz).toList();
                      if (sparklineData.isEmpty) {
                        return PriceSparkline(
                          data: [price.pricePerTroyOz],
                          color: accentColor,
                          isPositive: price.changeAmount24h >= 0,
                        );
                      }
                      return PriceSparkline(
                        data: sparklineData,
                        color: accentColor,
                        isPositive: price.changeAmount24h >= 0,
                      );
                    },
                    loading: () => SizedBox(
                      height: 50,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: accentColor),
                        ),
                      ),
                    ),
                    error: (_, __) => PriceSparkline(
                      data: [price.pricePerTroyOz],
                      color: accentColor,
                      isPositive: price.changeAmount24h >= 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PricePerWeight(
                  label: 'Per Gram',
                  value: price.pricePerGram,
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white12,
                ),
                _PricePerWeight(
                  label: 'Per Kilogram',
                  value: price.pricePerKg,
                  alignment: CrossAxisAlignment.end,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PricePerWeight extends StatelessWidget {
  final String label;
  final double value;
  final CrossAxisAlignment alignment;

  const _PricePerWeight({
    required this.label,
    required this.value,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textSecondaryDark,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          CurrencyFormatter.format(value),
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryDark,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
