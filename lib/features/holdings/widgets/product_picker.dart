import 'package:flutter/material.dart';
import '../../../core/constants/bullion_products.dart';
import '../../../domain/entities/metal_type.dart' as entity;

class ProductPicker extends StatelessWidget {
  final entity.MetalType metalType;
  final BullionProduct? selectedProduct;
  final ValueChanged<BullionProduct> onProductSelected;

  const ProductPicker({
    super.key,
    required this.metalType,
    this.selectedProduct,
    required this.onProductSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showProductBottomSheet(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedProduct?.name ?? 'Select Product',
              style: TextStyle(
                color: selectedProduct == null ? Colors.grey : null,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showProductBottomSheet(BuildContext context) {
    // Filter products based on selected metal type
    final isGold = metalType == entity.MetalType.gold;
    final products = BullionProducts.all.where((p) => isGold ? p.isGold : p.isSilver).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Product',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Text('${product.weightInGrams}g • ${product.purity} purity'),
                      trailing: selectedProduct?.id == product.id
                          ? Icon(Icons.check_circle, color: metalType.displayColor)
                          : null,
                      onTap: () {
                        onProductSelected(product);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
