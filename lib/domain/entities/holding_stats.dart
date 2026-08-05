import 'holding.dart';

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
