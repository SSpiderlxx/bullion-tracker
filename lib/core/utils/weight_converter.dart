import '../../domain/entities/weight_unit.dart';

sealed class WeightConverter {
  static const double gramsPerTroyOunce = 31.1034768;

  static double toGrams(double value, WeightUnit unit) {
    switch (unit) {
      case WeightUnit.gram:
      case WeightUnit.coin:
      case WeightUnit.bar:
        return value;
      case WeightUnit.troyOunce:
        return value * gramsPerTroyOunce;
      case WeightUnit.kilogram:
        return value * 1000.0;
    }
  }

  static double fromGrams(double grams, WeightUnit toUnit) {
    switch (toUnit) {
      case WeightUnit.gram:
      case WeightUnit.coin:
      case WeightUnit.bar:
        return grams;
      case WeightUnit.troyOunce:
        return grams / gramsPerTroyOunce;
      case WeightUnit.kilogram:
        return grams / 1000.0;
    }
  }

  static double convert(double value, WeightUnit from, WeightUnit to) {
    final grams = toGrams(value, from);
    return fromGrams(grams, to);
  }

  static String getUnitSymbol(WeightUnit unit) {
    return unit.shortName;
  }
}
