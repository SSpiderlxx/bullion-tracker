import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/portfolio_chart.dart';
import '../widgets/allocation_donut.dart';
import '../widgets/price_history_chart.dart';
import '../widgets/purchase_history_chart.dart';
import '../widgets/period_selector.dart';

class ChartsScreen extends HookConsumerWidget {
  const ChartsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 4);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.darkTextSecondary,
          tabs: const [
            Tab(text: 'Portfolio'),
            Tab(text: 'Allocation'),
            Tab(text: 'Prices'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          _PortfolioTab().animate().fadeIn(),
          _AllocationTab().animate().fadeIn(),
          _PricesTab().animate().fadeIn(),
          _HistoryTab().animate().fadeIn(),
        ],
      ),
    );
  }
}

class _PortfolioTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PeriodSelector(),
        const SizedBox(height: 24),
        const SizedBox(
          height: 300,
          child: PortfolioChart(),
        ),
      ],
    );
  }
}

class _AllocationTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(
          height: 300,
          child: AllocationDonut(),
        ),
      ],
    );
  }
}

class _PricesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PeriodSelector(),
        const SizedBox(height: 24),
        const Text('Gold', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const SizedBox(
          height: 200,
          child: PriceHistoryChart(isGold: true),
        ),
        const SizedBox(height: 32),
        const Text('Silver', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const SizedBox(
          height: 200,
          child: PriceHistoryChart(isGold: false),
        ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(
          height: 300,
          child: PurchaseHistoryChart(),
        ),
      ],
    );
  }
}
