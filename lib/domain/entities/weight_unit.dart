enum WeightUnit {
  troyOunce,
  gram,
  kilogram,
  coin,
  bar;

  String get displayName {
    switch (this) {
      case WeightUnit.troyOunce:
        return 'Troy Ounce (oz)';
      case WeightUnit.gram:
        return 'Gram (g)';
      case WeightUnit.kilogram:
        return 'Kilogram (kg)';
      case WeightUnit.coin:
        return 'Coin';
      case WeightUnit.bar:
        return 'Bar';
    }
  }

  String get shortName {
    switch (this) {
      case WeightUnit.troyOunce:
        return 'oz';
      case WeightUnit.gram:
        return 'g';
      case WeightUnit.kilogram:
        return 'kg';
      case WeightUnit.coin:
        return 'coin';
      case WeightUnit.bar:
        return 'bar';
    }
  }
}
