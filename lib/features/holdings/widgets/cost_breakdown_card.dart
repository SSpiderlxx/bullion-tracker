import 'package:flutter/material.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/glass_card.dart';

class CostBreakdownCard extends StatelessWidget {
  final double purchasePrice;
  final double premium;
  final double shipping;
  final double fees;
  final double total;

  const CostBreakdownCard({
    super.key,
    required this.purchasePrice,
    required this.premium,
    required this.shipping,
    required this.fees,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cost Breakdown',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRow('Purchase Price', purchasePrice),
          const SizedBox(height: 8),
          _buildRow('Premium', premium),
          const SizedBox(height: 8),
          _buildRow('Shipping', shipping),
          const SizedBox(height: 8),
          _buildRow('Fees', fees),
          const Divider(height: 24),
          _buildRow('Total Cost', total, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildRow(String label, double amount, {bool isTotal = false}) {
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
          ),
        ),
      ],
    );
  }
}
