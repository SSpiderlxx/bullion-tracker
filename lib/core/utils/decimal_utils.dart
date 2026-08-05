import 'package:decimal/decimal.dart';

sealed class DecimalUtils {
  /// Parses a double to Decimal safely
  static Decimal fromDouble(double value) => Decimal.parse(value.toString());

  /// Parses a string to Decimal safely
  static Decimal fromString(String value) {
    try {
      return Decimal.parse(value);
    } catch (_) {
      return Decimal.zero;
    }
  }

  /// Multiply two decimals
  static Decimal multiply(Decimal a, Decimal b) => a * b;

  /// Divide a by b
  static Decimal divide(Decimal a, Decimal b) {
    if (b == Decimal.zero) return Decimal.zero;
    return (a / b).toDecimal(scaleOnInfinitePrecision: 8);
  }

  /// Add two decimals
  static Decimal add(Decimal a, Decimal b) => a + b;

  /// Subtract b from a
  static Decimal subtract(Decimal a, Decimal b) => a - b;

  /// Round to currency precision (2 decimal places)
  static Decimal roundToCurrency(Decimal value) =>
      Decimal.parse(value.toStringAsFixed(2));

  /// Calculates percentage difference: ((current - previous) / previous) * 100
  static Decimal percentageChange(Decimal current, Decimal previous) {
    if (previous == Decimal.zero) return Decimal.zero;
    final diff = current - previous;
    return (diff / previous).toDecimal(scaleOnInfinitePrecision: 4) *
        Decimal.fromInt(100);
  }
}
