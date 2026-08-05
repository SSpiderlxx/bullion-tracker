import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/entities/portfolio_summary.dart';
import 'holdings_providers.dart';
import 'price_providers.dart';
import 'package:decimal/decimal.dart';

final portfolioSummaryProvider = Provider<AsyncValue<PortfolioSummary>>((ref) {
  final holdingsAsync = ref.watch(allHoldingsProvider);
  final pricesAsync = ref.watch(livePricesProvider);

  if (holdingsAsync is AsyncLoading || pricesAsync is AsyncLoading) {
    return const AsyncValue.loading();
  }

  if (holdingsAsync is AsyncError) {
    return AsyncValue.error(holdingsAsync.error!, holdingsAsync.stackTrace!);
  }

  if (pricesAsync is AsyncError) {
    return AsyncValue.error(pricesAsync.error!, pricesAsync.stackTrace!);
  }

  final holdings = holdingsAsync.value ?? [];
  final prices = pricesAsync.value ?? {};
  
  if (prices.isEmpty) {
     return const AsyncValue.loading();
  }

  double totalInvested = 0;
  double currentValue = 0;
  double totalGoldGrams = 0;
  double totalSilverGrams = 0;
  double totalPremiumPaid = 0;

  final goldPricePerGram = Decimal.parse(prices[MetalType.gold]!.pricePerGram.toString());
  final silverPricePerGram = Decimal.parse(prices[MetalType.silver]!.pricePerGram.toString());

  for (final holding in holdings) {
    if (holding.isSold) continue;

    totalInvested += holding.totalCost;
    totalPremiumPaid += holding.premiumPaid;

    final weight = Decimal.parse(holding.weightInGrams.toString());
    final purity = Decimal.parse(holding.purity.toString());
    final pureWeight = weight * purity;

    if (holding.metalType == MetalType.gold) {
      totalGoldGrams += pureWeight.toDouble();
      currentValue += (pureWeight * goldPricePerGram).toDouble();
    } else {
      totalSilverGrams += pureWeight.toDouble();
      currentValue += (pureWeight * silverPricePerGram).toDouble();
    }
  }

  final totalProfitLoss = currentValue - totalInvested;
  final profitLossPercent = totalInvested > 0 ? (totalProfitLoss / totalInvested) * 100 : 0.0;
  
  final goldValue = totalGoldGrams * goldPricePerGram.toDouble();
  final silverValue = totalSilverGrams * silverPricePerGram.toDouble();
  
  final goldAllocationPercent = currentValue > 0 ? (goldValue / currentValue) * 100 : 0.0;
  final silverAllocationPercent = currentValue > 0 ? (silverValue / currentValue) * 100 : 0.0;

  final totalGoldOz = totalGoldGrams / 31.1034768;
  final totalSilverOz = totalSilverGrams / 31.1034768;

  return AsyncValue.data(PortfolioSummary(
    totalInvested: totalInvested,
    currentValue: currentValue,
    totalProfitLoss: totalProfitLoss,
    profitLossPercent: profitLossPercent,
    goldAllocationPercent: goldAllocationPercent,
    silverAllocationPercent: silverAllocationPercent,
    totalGoldGrams: totalGoldGrams,
    totalSilverGrams: totalSilverGrams,
    totalGoldOz: totalGoldOz,
    totalSilverOz: totalSilverOz,
    avgCostPerGramGold: 0.0, // Calculate properly based on gold holdings only
    avgCostPerGramSilver: 0.0,
    avgCostPerOzGold: 0.0,
    avgCostPerOzSilver: 0.0,
    totalPremiumPaid: totalPremiumPaid,
    spotValue: currentValue, // Simplified
    premiumValue: 0.0,
    unrealisedGain: totalProfitLoss,
    realisedGain: 0.0, // Calculate from sold holdings
    dailyChange: 0.0,
    dailyChangePercent: 0.0,
  ));
});
