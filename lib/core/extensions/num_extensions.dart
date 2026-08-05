import '../utils/currency_formatter.dart';
import '../utils/weight_converter.dart';

extension NumExtensions on num {
  String toCurrency({CurrencyCode currency = CurrencyCode.gbp}) {
    return CurrencyFormatter.format(this.toDouble(), currency: currency);
  }

  String toCompactCurrency({CurrencyCode currency = CurrencyCode.gbp}) {
    return CurrencyFormatter.formatCompact(this.toDouble(), currency: currency);
  }

  String toPnL({CurrencyCode currency = CurrencyCode.gbp}) {
    return CurrencyFormatter.formatPnL(this.toDouble(), currency: currency);
  }

  String toWeightString([WeightUnit unit = WeightUnit.grams, int decimals = 2]) {
    final value = this.toDouble();
    return '${value.toStringAsFixed(decimals)} ${WeightConverter.getUnitSymbol(unit)}';
  }
}
