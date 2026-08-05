import os

files = {}

files['lib/domain/entities/metal_type.dart'] = '''import 'package:flutter/material.dart';

enum MetalType {
  gold,
  silver;

  String get displayName {
    switch (this) {
      case MetalType.gold:
        return 'Gold';
      case MetalType.silver:
        return 'Silver';
    }
  }

  Color get displayColor {
    switch (this) {
      case MetalType.gold:
        return const Color(0xFFFFD700);
      case MetalType.silver:
        return const Color(0xFFC0C0C0);
    }
  }
}
'''

files['lib/domain/entities/weight_unit.dart'] = '''enum WeightUnit {
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
'''

files['lib/domain/entities/currency_code.dart'] = '''enum CurrencyCode {
  gbp,
  usd,
  eur;

  String get symbol {
    switch (this) {
      case CurrencyCode.gbp:
        return '£';
      case CurrencyCode.usd:
        return '\$';
      case CurrencyCode.eur:
        return '€';
    }
  }
}
'''

files['lib/domain/entities/holding.dart'] = '''import 'metal_type.dart';
import 'weight_unit.dart';

class Holding {
  final String id;
  final MetalType metalType;
  final String productName;
  final DateTime purchaseDate;
  final String dealer;
  final double weightInGrams;
  final WeightUnit weightUnit;
  final double displayQuantity;
  final double purity;
  final double purchasePrice;
  final double premiumPaid;
  final double shippingCost;
  final double fees;
  final double totalCost;
  final String? notes;
  final String? receiptPhotoPath;
  final bool isSold;
  final DateTime? soldDate;
  final double? soldPrice;
  final double? soldQuantityGrams;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Holding({
    required this.id,
    required this.metalType,
    required this.productName,
    required this.purchaseDate,
    required this.dealer,
    required this.weightInGrams,
    required this.weightUnit,
    required this.displayQuantity,
    required this.purity,
    required this.purchasePrice,
    required this.premiumPaid,
    required this.shippingCost,
    required this.fees,
    required this.totalCost,
    this.notes,
    this.receiptPhotoPath,
    this.isSold = false,
    this.soldDate,
    this.soldPrice,
    this.soldQuantityGrams,
    required this.createdAt,
    required this.updatedAt,
  });

  Holding copyWith({
    String? id,
    MetalType? metalType,
    String? productName,
    DateTime? purchaseDate,
    String? dealer,
    double? weightInGrams,
    WeightUnit? weightUnit,
    double? displayQuantity,
    double? purity,
    double? purchasePrice,
    double? premiumPaid,
    double? shippingCost,
    double? fees,
    double? totalCost,
    String? notes,
    String? receiptPhotoPath,
    bool? isSold,
    DateTime? soldDate,
    double? soldPrice,
    double? soldQuantityGrams,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Holding(
      id: id ?? this.id,
      metalType: metalType ?? this.metalType,
      productName: productName ?? this.productName,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      dealer: dealer ?? this.dealer,
      weightInGrams: weightInGrams ?? this.weightInGrams,
      weightUnit: weightUnit ?? this.weightUnit,
      displayQuantity: displayQuantity ?? this.displayQuantity,
      purity: purity ?? this.purity,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      premiumPaid: premiumPaid ?? this.premiumPaid,
      shippingCost: shippingCost ?? this.shippingCost,
      fees: fees ?? this.fees,
      totalCost: totalCost ?? this.totalCost,
      notes: notes ?? this.notes,
      receiptPhotoPath: receiptPhotoPath ?? this.receiptPhotoPath,
      isSold: isSold ?? this.isSold,
      soldDate: soldDate ?? this.soldDate,
      soldPrice: soldPrice ?? this.soldPrice,
      soldQuantityGrams: soldQuantityGrams ?? this.soldQuantityGrams,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
'''

files['lib/domain/entities/metal_price.dart'] = '''import 'metal_type.dart';
import 'currency_code.dart';

class MetalPrice {
  final MetalType metalType;
  final double pricePerTroyOz;
  final CurrencyCode currency;
  final DateTime timestamp;
  final double changePercent24h;
  final double changeAmount24h;

  const MetalPrice({
    required this.metalType,
    required this.pricePerTroyOz,
    required this.currency,
    required this.timestamp,
    required this.changePercent24h,
    required this.changeAmount24h,
  });

  double get pricePerGram => pricePerTroyOz / 31.1034768;
  double get pricePerKg => pricePerGram * 1000;
}
'''

files['lib/domain/entities/portfolio_summary.dart'] = '''class PortfolioSummary {
  final double totalInvested;
  final double currentValue;
  final double totalProfitLoss;
  final double profitLossPercent;
  final double goldAllocationPercent;
  final double silverAllocationPercent;
  final double totalGoldGrams;
  final double totalSilverGrams;
  final double totalGoldOz;
  final double totalSilverOz;
  final double avgCostPerGramGold;
  final double avgCostPerGramSilver;
  final double avgCostPerOzGold;
  final double avgCostPerOzSilver;
  final double totalPremiumPaid;
  final double spotValue;
  final double premiumValue;
  final double unrealisedGain;
  final double realisedGain;
  final double dailyChange;
  final double dailyChangePercent;

  const PortfolioSummary({
    required this.totalInvested,
    required this.currentValue,
    required this.totalProfitLoss,
    required this.profitLossPercent,
    required this.goldAllocationPercent,
    required this.silverAllocationPercent,
    required this.totalGoldGrams,
    required this.totalSilverGrams,
    required this.totalGoldOz,
    required this.totalSilverOz,
    required this.avgCostPerGramGold,
    required this.avgCostPerGramSilver,
    required this.avgCostPerOzGold,
    required this.avgCostPerOzSilver,
    required this.totalPremiumPaid,
    required this.spotValue,
    required this.premiumValue,
    required this.unrealisedGain,
    required this.realisedGain,
    required this.dailyChange,
    required this.dailyChangePercent,
  });
}
'''

files['lib/domain/entities/price_alert.dart'] = '''import 'metal_type.dart';

class PriceAlert {
  final String id;
  final MetalType metalType;
  final double targetPrice;
  final bool isAbove;
  final bool isEnabled;
  final DateTime? triggeredAt;
  final DateTime createdAt;

  const PriceAlert({
    required this.id,
    required this.metalType,
    required this.targetPrice,
    required this.isAbove,
    required this.isEnabled,
    this.triggeredAt,
    required this.createdAt,
  });
}
'''

files['lib/domain/entities/holding_stats.dart'] = '''import 'holding.dart';

class HoldingStats {
  final Holding? bestPurchase;
  final Holding? worstPurchase;
  final Holding? mostProfitable;
  final double avgBuyPriceGold;
  final double avgBuyPriceSilver;
  final double totalOzOwned;
  final double totalGramsOwned;
  final double historicalROI;
  final double totalPremiumPaid;
  final double currentSpotPremium;

  const HoldingStats({
    this.bestPurchase,
    this.worstPurchase,
    this.mostProfitable,
    required this.avgBuyPriceGold,
    required this.avgBuyPriceSilver,
    required this.totalOzOwned,
    required this.totalGramsOwned,
    required this.historicalROI,
    required this.totalPremiumPaid,
    required this.currentSpotPremium,
  });
}
'''

for path, content in files.items():
    with open(f'/Volumes/SSD/MetalTracker/{path}', 'w') as f:
        f.write(content)
print("Entities generated successfully.")
