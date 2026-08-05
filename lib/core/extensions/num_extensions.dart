import '../utils/currency_formatter.dart';
import '../utils/weight_converter.dart';
import '../../domain/entities/currency_code.dart';
import '../../domain/entities/weight_unit.dart';

extension NumExtensions on num {
  String toCurrency({CurrencyCode currency = CurrencyCode.gbp}) {
    return CurrencyFormatter.format(toDouble(), currency: currency);
  }

  String toCompactCurrency({CurrencyCode currency = CurrencyCode.gbp}) {
    return CurrencyFormatter.formatCompact(toDouble(), currency: currency);
  }

  String toPnL({CurrencyCode currency = CurrencyCode.gbp}) {
    return CurrencyFormatter.formatPnL(toDouble(), currency: currency);
  }

  String toWeightString([WeightUnit unit = WeightUnit.gram, int decimals = 2]) {
    final value = toDouble();
    return '${value.toStringAsFixed(decimals)} ${WeightConverter.getUnitSymbol(unit)}';
  }
}
