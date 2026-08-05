import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/holding.dart';
import '../widgets/sale_summary_card.dart';
import '../../../data/providers/holdings_providers.dart';

class SellHoldingScreen extends HookConsumerWidget {
  final Holding holding;

  const SellHoldingScreen({
    super.key,
    required this.holding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saleDate = useState<DateTime>(DateTime.now());
    final quantityController = useTextEditingController(text: holding.displayQuantity.toString());
    final salePriceController = useTextEditingController();
    
    final salePriceValue = useListenableSelector(salePriceController, () => double.tryParse(salePriceController.text) ?? 0.0);

    void confirmSale() {
      if (salePriceController.text.isEmpty) return;

      final updatedHolding = holding.copyWith(
        isSold: true,
        soldDate: saleDate.value,
        soldPrice: salePriceValue,
        soldQuantityGrams: holding.weightInGrams, // Assuming selling all
        updatedAt: DateTime.now(),
      );

      ref.read(holdingsNotifierProvider.notifier).updateHolding(updatedHolding);

      Navigator.pop(context); // close sell screen
      Navigator.pop(context); // close detail screen
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Holding'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: holding.metalType.displayColor.withOpacity(0.2),
              child: Icon(
                holding.metalType.name == 'gold' ? Icons.monetization_on : Icons.circle,
                color: holding.metalType.displayColor,
              ),
            ),
            title: Text(holding.productName),
            subtitle: Text('${holding.displayQuantity} ${holding.weightUnit.shortName}'),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: saleDate.value,
                firstDate: holding.purchaseDate,
                lastDate: DateTime.now(),
              );
              if (date != null) saleDate.value = date;
            },
            child: InputDecorator(
              decoration: const InputDecoration(labelText: 'Sale Date', border: OutlineInputBorder()),
              child: Text(DateFormat.yMMMd().format(saleDate.value)),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: quantityController,
            decoration: const InputDecoration(labelText: 'Quantity to Sell', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            readOnly: true, // simplified full sell for now
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: salePriceController,
            decoration: const InputDecoration(labelText: 'Total Sale Proceeds', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 32),
          if (salePriceValue > 0)
            SaleSummaryCard(
              salePrice: salePriceValue,
              totalCost: holding.totalCost,
              profitLoss: salePriceValue - holding.totalCost,
            ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: salePriceValue > 0 ? confirmSale : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Confirm Sale'),
          ),
        ],
      ),
    );
  }
}
