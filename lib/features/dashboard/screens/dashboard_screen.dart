import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/portfolio_providers.dart';
import '../../../data/providers/price_providers.dart';
import '../widgets/portfolio_value_card.dart';
import '../widgets/pnl_card.dart';
import '../widgets/metal_price_card.dart';
import '../widgets/allocation_chart.dart';
import '../widgets/holdings_summary_card.dart';
import '../widgets/quick_actions_row.dart';
import '../../../core/widgets/shimmer_loading.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioAsync = ref.watch(portfolioSummaryProvider);
    final goldPriceAsync = ref.watch(goldPriceProvider);
    final silverPriceAsync = ref.watch(silverPriceProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: RefreshIndicator(
        color: AppColors.gold,
        backgroundColor: AppColors.surfaceDark,
        onRefresh: () async {
          ref.invalidate(portfolioSummaryProvider);
          ref.invalidate(goldPriceProvider);
          ref.invalidate(silverPriceProvider);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar(
              expandedHeight: 70.0,
              floating: true,
              pinned: true,
              backgroundColor: AppColors.backgroundDark.withOpacity(0.9),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        'assets/icons/bullion_logo.jpg',
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.shield, color: AppColors.gold, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.gold, Color(0xFFFFE066)],
                      ).createShader(bounds),
                      child: const Text(
                        'Bullion Tracker',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: portfolioAsync.when(
                data: (summary) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      PortfolioValueCard(summary: summary)
                          .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 16),
                      PnlCard(summary: summary)
                          .animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: goldPriceAsync.when(
                              data: (price) => price != null ? MetalPriceCard(price: price) : const SizedBox(),
                              loading: () => const ShimmerLoading(height: 100, width: double.infinity),
                              error: (_, __) => const SizedBox(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: silverPriceAsync.when(
                              data: (price) => price != null ? MetalPriceCard(price: price) : const SizedBox(),
                              loading: () => const ShimmerLoading(height: 100, width: double.infinity),
                              error: (_, __) => const SizedBox(),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 16),
                      AllocationChart(summary: summary)
                          .animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 16),
                      HoldingsSummaryCard(summary: summary)
                          .animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 24),
                      const QuickActionsRow()
                          .animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.1, duration: 400.ms, curve: Curves.easeOutCubic),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ShimmerLoading(height: 180, width: double.infinity),
                      SizedBox(height: 16),
                      ShimmerLoading(height: 120, width: double.infinity),
                    ],
                  ),
                ),
                error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: AppColors.loss))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
