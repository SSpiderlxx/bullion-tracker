class PortfolioSummary {
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
