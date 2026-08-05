import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/metal_type.dart';
import '../../../data/providers/holdings_providers.dart';
import '../../../data/providers/price_providers.dart';
import '../../../data/providers/portfolio_providers.dart';
import '../widgets/stat_card.dart';
import '../widgets/performance_meter.dart';

class StatisticsScreen extends HookConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdingsAsync = ref.watch(allHoldingsProvider);
    final portfolioAsync = ref.watch(portfolioSummaryProvider);
    final currentCurrency = ref.watch(selectedCurrencyProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: holdingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
        error: (err, stack) => Center(
          child: Text('Error loading stats: $err', style: const TextStyle(color: Colors.white)),
        ),
        data: (holdings) {
          final activeHoldings = holdings.where((h) => !h.isSold).toList();

          double goldGrams = 0;
          double silverGrams = 0;
          double goldCost = 0;
          double silverCost = 0;
          double totalPremiums = 0;

          for (final h in activeHoldings) {
            totalPremiums += h.premiumPaid + h.shippingCost + h.fees;
            if (h.metalType == MetalType.gold) {
              goldGrams += h.weightInGrams;
              goldCost += h.totalCost;
            } else if (h.metalType == MetalType.silver) {
              silverGrams += h.weightInGrams;
              silverCost += h.totalCost;
            }
          }

          final goldOz = goldGrams / 31.1034768;
          final silverOz = silverGrams / 31.1034768;

          final goldAvgBuy = goldOz > 0 ? goldCost / goldOz : 0.0;
          final silverAvgBuy = silverOz > 0 ? silverCost / silverOz : 0.0;

          final returnPercent = portfolioAsync.value?.profitLossPercent ?? 0.0;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              PerformanceMeter(value: returnPercent),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Gold Avg Buy',
                      value: goldAvgBuy > 0
                          ? '${CurrencyFormatter.format(goldAvgBuy, currency: currentCurrency)} /oz'
                          : 'N/A',
                      icon: Icons.diamond,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Silver Avg Buy',
                      value: silverAvgBuy > 0
                          ? '${CurrencyFormatter.format(silverAvgBuy, currency: currentCurrency)} /oz'
                          : 'N/A',
                      icon: Icons.diamond_outlined,
                      color: AppColors.silver,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Total Gold',
                      value: '${goldOz.toStringAsFixed(2)} oz (${goldGrams.toStringAsFixed(1)}g)',
                      icon: Icons.scale,
                      color: AppColors.gold,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      title: 'Total Silver',
                      value: '${silverOz.toStringAsFixed(2)} oz (${silverGrams.toStringAsFixed(1)}g)',
                      icon: Icons.scale_outlined,
                      color: AppColors.silver,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 16),
              StatCard(
                title: 'Total Premiums & Fees',
                value: CurrencyFormatter.format(totalPremiums, currency: currentCurrency),
                icon: Icons.money_off,
                color: Colors.orange,
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 16),
              StatCard(
                title: 'Active Holdings Count',
                value: '${activeHoldings.length} item${activeHoldings.length == 1 ? '' : 's'}',
                icon: Icons.inventory_2_outlined,
                color: AppColors.gold,
              ).animate().fadeIn(delay: 400.ms),
            ],
          );
        },
      ),
    );
  }
}
