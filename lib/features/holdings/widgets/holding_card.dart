import 'package:flutter/material.dart';
import '../../../domain/entities/holding.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/metal_icon.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HoldingCard extends StatelessWidget {
  final Holding holding;
  final double currentValue; // Passed in or calculated elsewhere
  final VoidCallback onTap;

  const HoldingCard({
    super.key,
    required this.holding,
    required this.currentValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final profitLoss = currentValue - holding.totalCost;
    final profitLossPercent = holding.totalCost > 0 ? (profitLoss / holding.totalCost) * 100 : 0.0;
    final isProfit = profitLoss >= 0;

    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    MetalIcon(type: holding.metalType, size: 42),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          holding.productName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '${holding.displayQuantity} ${holding.weightUnit.shortName}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                              ),
                            ),
                            if (holding.dealer.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  holding.dealer,
                                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                if (holding.isSold)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('SOLD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Value',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Text(
                      CurrencyFormatter.format(currentValue),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Return',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Row(
                      children: [
                        Icon(
                          isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                          color: CurrencyFormatter.getPnLColor(profitLoss),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          CurrencyFormatter.formatPnL(profitLoss),
                          style: TextStyle(
                            color: CurrencyFormatter.getPnLColor(profitLoss),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' (${profitLossPercent.toStringAsFixed(2)}%)',
                          style: TextStyle(
                            color: CurrencyFormatter.getPnLColor(profitLoss),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
