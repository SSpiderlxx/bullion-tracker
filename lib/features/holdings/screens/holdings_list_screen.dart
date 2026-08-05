import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../domain/entities/holding.dart';
import '../../../domain/entities/metal_type.dart';
import '../../../core/widgets/empty_state.dart';
import '../widgets/holding_card.dart';
import 'add_holding_screen.dart';
import 'holding_detail_screen.dart';

import '../../../data/providers/holdings_providers.dart';
import '../../../data/providers/price_providers.dart';


class HoldingsListScreen extends HookConsumerWidget {
  const HoldingsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdingsAsync = ref.watch(allHoldingsProvider);
    final goldPriceAsync = ref.watch(goldPriceProvider);
    final silverPriceAsync = ref.watch(silverPriceProvider);
    
    final selectedFilter = useState<String>('All');
    final searchQuery = useState<String>('');

    return Scaffold(
      body: holdingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (holdings) {
          final filteredHoldings = holdings.where((h) {
            if (searchQuery.value.isNotEmpty && !h.productName.toLowerCase().contains(searchQuery.value.toLowerCase())) {
              return false;
            }
            if (selectedFilter.value == 'Gold' && h.metalType != MetalType.gold) return false;
            if (selectedFilter.value == 'Silver' && h.metalType != MetalType.silver) return false;
            if (selectedFilter.value == 'Sold' && !h.isSold) return false;
            if (selectedFilter.value != 'Sold' && h.isSold) return false;
            return true;
          }).toList()
            ..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

          return CustomScrollView(
            slivers: [
              SliverAppBar.large(
                title: const Text('My Holdings'),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search holdings...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                        onChanged: (value) => searchQuery.value = value,
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: ['All', 'Gold', 'Silver', 'Sold'].map((filter) {
                            final isSelected = selectedFilter.value == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FilterChip(
                                label: Text(filter),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) selectedFilter.value = filter;
                                },
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                selectedColor: Theme.of(context).colorScheme.primaryContainer,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (filteredHoldings.isEmpty)
                SliverFillRemaining(
                  child: EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No Holdings Found',
                    message: holdings.isEmpty 
                        ? 'Add your first precious metal holding to start tracking your portfolio.'
                        : 'No holdings match your current filters.',
                    buttonText: holdings.isEmpty ? 'Add Holding' : null,
                    onButtonPressed: holdings.isEmpty ? () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AddHoldingScreen()));
                    } : null,
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final holding = filteredHoldings[index];
                        
                        double spot = 0.0;
                        if (holding.metalType == MetalType.gold) {
                          spot = goldPriceAsync.valueOrNull?.pricePerGram ?? 0.0;
                        } else {
                          spot = silverPriceAsync.valueOrNull?.pricePerGram ?? 0.0;
                        }
                        
                        final currentValue = holding.isSold ? holding.soldPrice ?? 0 : spot * holding.weightInGrams;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: HoldingCard(
                            holding: holding,
                            currentValue: currentValue,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HoldingDetailScreen(holding: holding),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: filteredHoldings.length,
                    ),
                  ),
                ),
            ],
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHoldingScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
