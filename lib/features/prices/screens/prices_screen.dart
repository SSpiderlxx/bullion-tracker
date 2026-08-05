import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/price_providers.dart';
import '../../../core/widgets/shimmer_loading.dart';
import '../widgets/price_detail_card.dart';
import '../widgets/currency_selector.dart';
import '../widgets/last_updated_indicator.dart';

class PricesScreen extends HookConsumerWidget {
  const PricesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goldPriceAsync = ref.watch(goldPriceProvider);
    final silverPriceAsync = ref.watch(silverPriceProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        title: const Text(
          'Live Prices',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: AppColors.gold,
        backgroundColor: AppColors.surfaceDark,
        onRefresh: () async {
          ref.invalidate(livePricesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const CurrencySelector()
                  .animate().fadeIn().slideY(begin: 0.1),
              const SizedBox(height: 16),
              const LastUpdatedIndicator()
                  .animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
              const SizedBox(height: 24),
              goldPriceAsync.when(
                data: (price) => price != null ? PriceDetailCard(price: price)
                    .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1) : const SizedBox(),
                loading: () => const ShimmerLoading(height: 240, width: double.infinity),
                error: (e, _) => Center(child: Text('Error loading gold: $e', style: const TextStyle(color: AppColors.loss))),
              ),
              const SizedBox(height: 20),
              silverPriceAsync.when(
                data: (price) => price != null ? PriceDetailCard(price: price)
                    .animate().fadeIn(delay: 300.ms).slideY(begin: 0.1) : const SizedBox(),
                loading: () => const ShimmerLoading(height: 240, width: double.infinity),
                error: (e, _) => Center(child: Text('Error loading silver: $e', style: const TextStyle(color: AppColors.loss))),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
