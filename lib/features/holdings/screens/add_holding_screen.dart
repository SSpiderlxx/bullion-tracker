import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/holding.dart';
import '../../../domain/entities/metal_type.dart';
import '../../../domain/entities/weight_unit.dart';
import '../../../core/constants/bullion_products.dart' hide MetalType;
import '../widgets/metal_type_selector.dart';
import '../widgets/product_picker.dart';
import '../../../data/providers/holdings_providers.dart';

class AddHoldingScreen extends HookConsumerWidget {
  final Holding? holding;

  const AddHoldingScreen({
    super.key,
    this.holding,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    final isEditing = holding != null;
    
    final selectedMetal = useState<MetalType>(holding?.metalType ?? MetalType.gold);
    final selectedProduct = useState<BullionProduct?>(null);
    final purchaseDate = useState<DateTime>(holding?.purchaseDate ?? DateTime.now());
    
    final nameController = useTextEditingController(text: holding?.productName);
    final dealerController = useTextEditingController(text: holding?.dealer);
    final quantityController = useTextEditingController(text: holding?.displayQuantity.toString());
    final purityController = useTextEditingController(text: holding?.purity.toString());
    final purchasePriceController = useTextEditingController(text: holding?.purchasePrice.toString());
    final premiumController = useTextEditingController(text: holding?.premiumPaid.toString() ?? '0');
    final shippingController = useTextEditingController(text: holding?.shippingCost.toString() ?? '0');
    final feesController = useTextEditingController(text: holding?.fees.toString() ?? '0');
    final notesController = useTextEditingController(text: holding?.notes);
    
    final selectedUnit = useState<WeightUnit>(holding?.weightUnit ?? WeightUnit.troyOunce);

    void calculateTotal() {
      // Basic auto-calculation could be added here
    }

    void onProductSelected(BullionProduct product) {
      selectedProduct.value = product;
      nameController.text = product.name;
      purityController.text = product.purity.toString();
      quantityController.text = '1';
      selectedUnit.value = WeightUnit.coin; 
    }

    void saveHolding() {
      if (formKey.currentState!.validate()) {
        final newHolding = Holding(
          id: holding?.id ?? const Uuid().v4(),
          metalType: selectedMetal.value,
          productName: nameController.text,
          purchaseDate: purchaseDate.value,
          dealer: dealerController.text,
          weightInGrams: selectedProduct.value?.weightInGrams ?? double.tryParse(quantityController.text) ?? 0, // Mock calc
          weightUnit: selectedUnit.value,
          displayQuantity: double.tryParse(quantityController.text) ?? 1,
          purity: double.tryParse(purityController.text) ?? 999.0,
          purchasePrice: double.tryParse(purchasePriceController.text) ?? 0,
          premiumPaid: double.tryParse(premiumController.text) ?? 0,
          shippingCost: double.tryParse(shippingController.text) ?? 0,
          fees: double.tryParse(feesController.text) ?? 0,
          totalCost: (double.tryParse(purchasePriceController.text) ?? 0) +
                     (double.tryParse(premiumController.text) ?? 0) +
                     (double.tryParse(shippingController.text) ?? 0) +
                     (double.tryParse(feesController.text) ?? 0),
                     notes: notesController.text,
          createdAt: holding?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        if (isEditing) {
          ref.read(holdingsNotifierProvider.notifier).updateHolding(newHolding);
        } else {
          ref.read(holdingsNotifierProvider.notifier).addHolding(newHolding);
        }

        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Holding' : 'Add Holding'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: saveHolding,
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            MetalTypeSelector(
              selectedType: selectedMetal.value,
              onChanged: (type) {
                selectedMetal.value = type;
                selectedProduct.value = null; // Reset product on type change
              },
            ),
            const SizedBox(height: 24),
            Text('Product Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ProductPicker(
              metalType: selectedMetal.value,
              selectedProduct: selectedProduct.value,
              onProductSelected: onProductSelected,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Custom Product Name', border: OutlineInputBorder()),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<WeightUnit>(
                    value: selectedUnit.value,
                    decoration: const InputDecoration(labelText: 'Unit', border: OutlineInputBorder()),
                    items: WeightUnit.values.map((u) {
                      return DropdownMenuItem(value: u, child: Text(u.displayName));
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) selectedUnit.value = v;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: purityController,
              decoration: const InputDecoration(labelText: 'Purity (e.g. 999.9)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            Text('Purchase Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: purchaseDate.value,
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) purchaseDate.value = date;
              },
              child: InputDecorator(
                decoration: const InputDecoration(labelText: 'Purchase Date', border: OutlineInputBorder()),
                child: Text(DateFormat.yMMMd().format(purchaseDate.value)),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: dealerController,
              decoration: const InputDecoration(labelText: 'Dealer Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            Text('Cost Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: purchasePriceController,
                    decoration: const InputDecoration(labelText: 'Purchase Price', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => calculateTotal(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: premiumController,
                    decoration: const InputDecoration(labelText: 'Premium', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => calculateTotal(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: shippingController,
                    decoration: const InputDecoration(labelText: 'Shipping', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => calculateTotal(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: feesController,
                    decoration: const InputDecoration(labelText: 'Fees', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => calculateTotal(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: notesController,
              decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: saveHolding,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Holding'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
