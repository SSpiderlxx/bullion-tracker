import 'package:flutter/material.dart';
import '../utils/currency_formatter.dart';

class ProfitLossText extends StatelessWidget {
  final double amount;
  final double? percentage;
  final TextStyle? style;
  final bool showBackground;

  const ProfitLossText({
    super.key,
    required this.amount,
    this.percentage,
    this.style,
    this.showBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final isProfit = amount >= 0;
    final color = CurrencyFormatter.getPnLColor(amount);
    final formattedAmount = CurrencyFormatter.formatPnL(amount);
    final icon = isProfit ? Icons.arrow_upward : Icons.arrow_downward;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: style?.fontSize ?? 14),
        const SizedBox(width: 4),
        Text(
          formattedAmount,
          style: (style ?? const TextStyle()).copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (percentage != null) ...[
          const SizedBox(width: 4),
          Text(
            '(${percentage!.toStringAsFixed(2)}%)',
            style: (style ?? const TextStyle()).copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    if (showBackground) {
      content = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      );
    }

    return content;
  }
}
