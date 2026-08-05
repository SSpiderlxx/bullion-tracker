import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/metal_icon.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/price_alert.dart';

class AlertCard extends StatelessWidget {
  final PriceAlert alert;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onDelete;

  const AlertCard({
    super.key,
    required this.alert,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          MetalIcon(type: alert.metalType, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${alert.metalType.displayName} ${alert.isAbove ? 'Rises Above' : 'Drops Below'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryDark,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.format(alert.targetPrice, currency: alert.currency),
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: alert.isEnabled,
            onChanged: onToggle,
            activeThumbColor: alert.metalType.displayColor,
          ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
