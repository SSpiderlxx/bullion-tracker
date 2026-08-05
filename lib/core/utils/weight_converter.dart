enum WeightUnit {
  grams,
  troyOunces,
  kilograms,
}

sealed class WeightConverter {
  static const double gramsPerTroyOunce = 31.1034768;

  static double toGrams(double value, WeightUnit unit) {
    switch (unit) {
      case WeightUnit.grams:
        return value;
      case WeightUnit.troyOunces:
        return value * gramsPerTroyOunce;
      case WeightUnit.kilograms:
        return value * 1000.0;
    }
  }

  static double fromGrams(double grams, WeightUnit toUnit) {
    switch (toUnit) {
      case WeightUnit.grams:
        return grams;
      case WeightUnit.troyOunces:
        return grams / gramsPerTroyOunce;
      case WeightUnit.kilograms:
        return grams / 1000.0;
    }
  }

  static double convert(double value, WeightUnit from, WeightUnit to) {
    final grams = toGrams(value, from);
    return fromGrams(grams, to);
  }

  static String getUnitSymbol(WeightUnit unit) {
    switch (unit) {
      case WeightUnit.grams:
        return 'g';
      case WeightUnit.troyOunces:
        return 'oz';
      case WeightUnit.kilograms:
        return 'kg';
    }
  }
}
