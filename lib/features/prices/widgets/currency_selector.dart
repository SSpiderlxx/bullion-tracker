import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/currency_code.dart';
import '../../../data/providers/price_providers.dart';

class CurrencySelector extends HookConsumerWidget {
  const CurrencySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCurrency = ref.watch(selectedCurrencyProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: CupertinoSlidingSegmentedControl<CurrencyCode>(
        backgroundColor: Colors.transparent,
        thumbColor: AppColors.gold.withValues(alpha: 0.2),
        groupValue: selectedCurrency,
        onValueChanged: (CurrencyCode? value) {
          if (value != null) {
            ref.read(selectedCurrencyProvider.notifier).state = value;
          }
        },
        children: {
          CurrencyCode.gbp: _buildSegment('GBP (£)', selectedCurrency == CurrencyCode.gbp),
          CurrencyCode.usd: _buildSegment('USD (\$)', selectedCurrency == CurrencyCode.usd),
          CurrencyCode.eur: _buildSegment('EUR (€)', selectedCurrency == CurrencyCode.eur),
        },
      ),
    );
  }

  Widget _buildSegment(String text, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: isSelected ? AppColors.gold : AppColors.textSecondaryDark,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
