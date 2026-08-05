enum MetalType { gold, silver, platinum, palladium }

sealed class BullionProducts {
  static const List<BullionProduct> all = [
    // Gold Products
    BullionProduct(
      id: 'gold_britannia_1oz',
      name: 'Britannia',
      metalType: MetalType.gold,
      weightInGrams: 31.1035,
      purity: 999.9,
    ),
    BullionProduct(
      id: 'gold_sovereign',
      name: 'Sovereign',
      metalType: MetalType.gold,
      weightInGrams: 7.322,
      purity: 916.7,
    ),
    BullionProduct(
      id: 'gold_half_sovereign',
      name: 'Half Sovereign',
      metalType: MetalType.gold,
      weightInGrams: 3.661,
      purity: 916.7,
    ),
    BullionProduct(
      id: 'gold_krugerrand_1oz',
      name: 'Krugerrand',
      metalType: MetalType.gold,
      weightInGrams: 31.1035,
      purity: 916.7,
    ),
    BullionProduct(
      id: 'gold_maple_leaf_1oz',
      name: 'Maple Leaf',
      metalType: MetalType.gold,
      weightInGrams: 31.1035,
      purity: 999.9,
    ),
    BullionProduct(
      id: 'gold_american_eagle_1oz',
      name: 'American Eagle',
      metalType: MetalType.gold,
      weightInGrams: 31.1035,
      purity: 916.7,
    ),
    // Silver Products
    BullionProduct(
      id: 'silver_britannia_1oz',
      name: 'Britannia',
      metalType: MetalType.silver,
      weightInGrams: 31.1035,
      purity: 999.0,
    ),
    BullionProduct(
      id: 'silver_maple_leaf_1oz',
      name: 'Maple Leaf',
      metalType: MetalType.silver,
      weightInGrams: 31.1035,
      purity: 999.9,
    ),
    BullionProduct(
      id: 'silver_philharmonic_1oz',
      name: 'Philharmonic',
      metalType: MetalType.silver,
      weightInGrams: 31.1035,
      purity: 999.0,
    ),
    BullionProduct(
      id: 'silver_kangaroo_1oz',
      name: 'Kangaroo',
      metalType: MetalType.silver,
      weightInGrams: 31.1035,
      purity: 999.9,
    ),
    BullionProduct(
      id: 'silver_generic_bar_1oz',
      name: 'Generic Bar (1 oz)',
      metalType: MetalType.silver,
      weightInGrams: 31.1035,
      purity: 999.0,
    ),
    BullionProduct(
      id: 'silver_generic_bar_100g',
      name: 'Generic Bar (100g)',
      metalType: MetalType.silver,
      weightInGrams: 100.0,
      purity: 999.0,
    ),
    BullionProduct(
      id: 'silver_generic_bar_1kg',
      name: 'Generic Bar (1kg)',
      metalType: MetalType.silver,
      weightInGrams: 1000.0,
      purity: 999.0,
    ),
  ];
}

class BullionProduct {
  final String id;
  final String name;
  final MetalType metalType;
  final double weightInGrams;
  final double purity;

  const BullionProduct({
    required this.id,
    required this.name,
    required this.metalType,
    required this.weightInGrams,
    required this.purity,
  });

  bool get isGold => metalType == MetalType.gold;
  bool get isSilver => metalType == MetalType.silver;
}
