import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/holding.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/cost_breakdown_card.dart';
import 'add_holding_screen.dart';
import 'sell_holding_screen.dart';
import '../../../data/providers/holdings_providers.dart';

class HoldingDetailScreen extends HookConsumerWidget {
  final Holding holding;

  const HoldingDetailScreen({
    super.key,
    required this.holding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spotPrice = ref.watch(spotPriceProvider(holding.metalType));
    final currentValue = holding.isSold ? (holding.soldPrice ?? 0) : spotPrice * holding.weightInGrams;
    final profitLoss = currentValue - holding.totalCost;
    final isProfit = profitLoss >= 0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: holding.metalType.displayColor.withOpacity(0.1),
                child: Center(
                  child: Hero(
                    tag: 'metal_icon_${holding.id}',
                    child: Icon(
                      holding.metalType.name == 'gold' ? Icons.monetization_on : Icons.circle,
                      size: 80,
                      color: holding.metalType.displayColor,
                    ),
                  ),
                ),
              ),
              title: Text(holding.productName, style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color)),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddHoldingScreen(holding: holding)),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _confirmDelete(context, ref),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Current Value', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.format(currentValue),
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                              color: CurrencyFormatter.getPnLColor(profitLoss),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              CurrencyFormatter.formatPnL(profitLoss),
                              style: TextStyle(
                                color: CurrencyFormatter.getPnLColor(profitLoss),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CostBreakdownCard(
                    purchasePrice: holding.purchasePrice,
                    premium: holding.premiumPaid,
                    shipping: holding.shippingCost,
                    fees: holding.fees,
                    total: holding.totalCost,
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildDetailRow('Dealer', holding.dealer),
                        const SizedBox(height: 8),
                        _buildDetailRow('Date', DateFormat.yMMMd().format(holding.purchaseDate)),
                        const SizedBox(height: 8),
                        _buildDetailRow('Weight', '${holding.displayQuantity} ${holding.weightUnit.shortName} (${holding.weightInGrams}g)'),
                        const SizedBox(height: 8),
                        _buildDetailRow('Purity', '${holding.purity}'),
                        if (holding.notes != null && holding.notes!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text('Notes', style: Theme.of(context).textTheme.labelLarge),
                          const SizedBox(height: 4),
                          Text(holding.notes!),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !holding.isSold ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SellHoldingScreen(holding: holding)),
              );
            },
            label: const Text('Sell Holding', style: TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.sell),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ) : null,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Holding?'),
        content: const Text('Are you sure you want to delete this holding? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(holdingsNotifierProvider.notifier).deleteHolding(holding.id);
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // close screen
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
