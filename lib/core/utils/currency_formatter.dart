import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum CurrencyCode {
  gbp('GBP', '£'),
  usd('USD', r'$'),
  eur('EUR', '€');

  final String code;
  final String symbol;

  const CurrencyCode(this.code, this.symbol);
}

sealed class CurrencyFormatter {
  static String format(double amount, {CurrencyCode currency = CurrencyCode.gbp}) {
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static String formatCompact(double amount, {CurrencyCode currency = CurrencyCode.gbp}) {
    final formatter = NumberFormat.compactCurrency(
      symbol: currency.symbol,
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  static Color getPnLColor(double value) {
    if (value > 0) return AppColors.profit;
    if (value < 0) return AppColors.loss;
    return Colors.grey;
  }

  static String formatPnL(double amount, {CurrencyCode currency = CurrencyCode.gbp}) {
    final prefix = amount >= 0 ? '+' : '';
    final formatter = NumberFormat.currency(
      symbol: currency.symbol,
      decimalDigits: 2,
    );
    return '$prefix${formatter.format(amount)}';
  }
}
