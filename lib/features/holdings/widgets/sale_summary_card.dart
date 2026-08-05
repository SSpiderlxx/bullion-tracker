import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/glass_card.dart';

class SaleSummaryCard extends StatelessWidget {
  final double salePrice;
  final double totalCost;
  final double profitLoss;

  const SaleSummaryCard({
    super.key,
    required this.salePrice,
    required this.totalCost,
    required this.profitLoss,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sale Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRow('Total Sale Price', salePrice),
          const SizedBox(height: 8),
          _buildRow('Original Cost', totalCost),
          const Divider(height: 24),
          _buildRow(
            'Profit / Loss',
            profitLoss,
            isTotal: true,
            color: CurrencyFormatter.getPnLColor(profitLoss),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double amount, {bool isTotal = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          CurrencyFormatter.format(amount),
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
            color: color,
          ),
        ),
      ],
    );
  }
}
