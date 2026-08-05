import os

files = {}

files['lib/data/repositories/holdings_repository_impl.dart'] = '''import '../../domain/entities/holding.dart';
import '../../domain/repositories/holdings_repository.dart';
import '../database/daos/holdings_dao.dart';
import '../database/app_database.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/entities/weight_unit.dart';

class HoldingsRepositoryImpl implements HoldingsRepository {
  final HoldingsDao _dao;

  HoldingsRepositoryImpl(this._dao);

  Holding _mapToDomain(HoldingData data) {
    return Holding(
      id: data.id,
      metalType: data.metalType,
      productName: data.productName,
      purchaseDate: data.purchaseDate,
      dealer: data.dealer,
      weightInGrams: data.weightInGrams,
      weightUnit: data.weightUnit,
      displayQuantity: data.displayQuantity,
      purity: data.purity,
      purchasePrice: data.purchasePrice,
      premiumPaid: data.premiumPaid,
      shippingCost: data.shippingCost,
      fees: data.fees,
      totalCost: data.totalCost,
      notes: data.notes,
      receiptPhotoPath: data.receiptPhotoPath,
      isSold: data.isSold,
      soldDate: data.soldDate,
      soldPrice: data.soldPrice,
      soldQuantityGrams: data.soldQuantityGrams,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  HoldingData _mapToData(Holding holding) {
    return HoldingData(
      id: holding.id,
      metalType: holding.metalType,
      productName: holding.productName,
      purchaseDate: holding.purchaseDate,
      dealer: holding.dealer,
      weightInGrams: holding.weightInGrams,
      weightUnit: holding.weightUnit,
      displayQuantity: holding.displayQuantity,
      purity: holding.purity,
      purchasePrice: holding.purchasePrice,
      premiumPaid: holding.premiumPaid,
      shippingCost: holding.shippingCost,
      fees: holding.fees,
      totalCost: holding.totalCost,
      notes: holding.notes,
      receiptPhotoPath: holding.receiptPhotoPath,
      isSold: holding.isSold,
      soldDate: holding.soldDate,
      soldPrice: holding.soldPrice,
      soldQuantityGrams: holding.soldQuantityGrams,
      createdAt: holding.createdAt,
      updatedAt: holding.updatedAt,
    );
  }

  @override
  Stream<List<Holding>> watchAllHoldings() {
    return _dao.watchAllHoldings().map(
      (list) => list.map(_mapToDomain).toList(),
    );
  }

  @override
  Future<List<Holding>> getAllHoldings() async {
    final data = await _dao.getAllHoldings();
    return data.map(_mapToDomain).toList();
  }

  @override
  Future<Holding?> getHoldingById(String id) async {
    try {
      final data = await _dao.getHoldingById(id);
      return _mapToDomain(data);
    } catch (e) {
      return null; // Handle not found
    }
  }

  @override
  Future<void> addHolding(Holding holding) async {
    await _dao.insertHolding(_mapToData(holding));
  }

  @override
  Future<void> updateHolding(Holding holding) async {
    await _dao.updateHolding(_mapToData(holding));
  }

  @override
  Future<void> deleteHolding(String id) async {
    await _dao.deleteHolding(id);
  }
}
'''

files['lib/data/repositories/price_repository_impl.dart'] = '''import '../../domain/entities/currency_code.dart';
import '../../domain/entities/metal_price.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/repositories/price_repository.dart';
import '../database/app_database.dart';
import '../database/daos/prices_dao.dart';
import '../services/metal_price_api_service.dart';

class PriceRepositoryImpl implements PriceRepository {
  final PricesDao _dao;
  final MetalPriceApiService _apiService;

  PriceRepositoryImpl(this._dao, this._apiService);

  MetalPrice _mapToDomain(MetalPriceData data) {
    return MetalPrice(
      metalType: data.metalType,
      pricePerTroyOz: data.pricePerTroyOz,
      currency: data.currency,
      timestamp: data.timestamp,
      changePercent24h: data.changePercent24h,
      changeAmount24h: data.changeAmount24h,
    );
  }

  MetalPriceData _mapToData(MetalPrice price) {
    return MetalPriceData(
      metalType: price.metalType,
      pricePerTroyOz: price.pricePerTroyOz,
      currency: price.currency,
      timestamp: price.timestamp,
      changePercent24h: price.changePercent24h,
      changeAmount24h: price.changeAmount24h,
    );
  }

  @override
  Stream<List<MetalPrice>> watchAllPrices() {
    return _dao.watchAllPrices().map(
      (list) => list.map(_mapToDomain).toList(),
    );
  }

  @override
  Future<Map<MetalType, MetalPrice>> getLatestPrices(CurrencyCode currency, {bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final gold = await _dao.getLatestPrice(MetalType.gold, currency);
      final silver = await _dao.getLatestPrice(MetalType.silver, currency);
      
      if (gold != null && silver != null) {
        final now = DateTime.now();
        // Return cache if it's less than 5 minutes old
        if (now.difference(gold.timestamp).inMinutes < 5) {
          return {
            MetalType.gold: _mapToDomain(gold),
            MetalType.silver: _mapToDomain(silver),
          };
        }
      }
    }

    try {
      final prices = await _apiService.fetchLatestPrices(currency);
      
      for (final price in prices.values) {
        await _dao.insertOrUpdatePrice(_mapToData(price));
      }
      
      return prices;
    } catch (e) {
      // Fallback to cache if network fails
      final gold = await _dao.getLatestPrice(MetalType.gold, currency);
      final silver = await _dao.getLatestPrice(MetalType.silver, currency);
      
      if (gold != null && silver != null) {
        return {
          MetalType.gold: _mapToDomain(gold),
          MetalType.silver: _mapToDomain(silver),
        };
      }
      rethrow;
    }
  }

  @override
  Future<List<MetalPrice>> getPriceHistory(MetalType metal, CurrencyCode currency, int days) async {
    // Attempt to fetch from API
    try {
      final apiHistory = await _apiService.fetchPriceHistory(metal, currency, days);
      if (apiHistory.isNotEmpty) {
        await _dao.insertPriceHistory(apiHistory.map((p) => PriceHistoryData(
          metalType: p.metalType,
          pricePerTroyOz: p.pricePerTroyOz,
          currency: p.currency,
          timestamp: p.timestamp,
        )).toList());
        return apiHistory;
      }
    } catch (_) {}

    // Fallback to cache
    final data = await _dao.getHistory(metal, currency, days);
    return data.map((d) => MetalPrice(
      metalType: d.metalType,
      pricePerTroyOz: d.pricePerTroyOz,
      currency: d.currency,
      timestamp: d.timestamp,
      changePercent24h: 0.0,
      changeAmount24h: 0.0,
    )).toList();
  }
}
'''

files['lib/data/repositories/alerts_repository_impl.dart'] = '''import '../../domain/entities/price_alert.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../database/app_database.dart';
import '../database/daos/alerts_dao.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsDao _dao;

  AlertsRepositoryImpl(this._dao);

  PriceAlert _mapToDomain(PriceAlertData data) {
    return PriceAlert(
      id: data.id,
      metalType: data.metalType,
      targetPrice: data.targetPrice,
      isAbove: data.isAbove,
      isEnabled: data.isEnabled,
      triggeredAt: data.triggeredAt,
      createdAt: data.createdAt,
    );
  }

  PriceAlertData _mapToData(PriceAlert alert) {
    return PriceAlertData(
      id: alert.id,
      metalType: alert.metalType,
      targetPrice: alert.targetPrice,
      isAbove: alert.isAbove,
      isEnabled: alert.isEnabled,
      triggeredAt: alert.triggeredAt,
      createdAt: alert.createdAt,
    );
  }

  @override
  Stream<List<PriceAlert>> watchAllAlerts() {
    return _dao.watchAllAlerts().map((list) => list.map(_mapToDomain).toList());
  }

  @override
  Future<List<PriceAlert>> getAllAlerts() async {
    final data = await _dao.getAllAlerts();
    return data.map(_mapToDomain).toList();
  }

  @override
  Future<void> addAlert(PriceAlert alert) async {
    await _dao.insertAlert(_mapToData(alert));
  }

  @override
  Future<void> updateAlert(PriceAlert alert) async {
    await _dao.updateAlert(_mapToData(alert));
  }

  @override
  Future<void> deleteAlert(String id) async {
    await _dao.deleteAlert(id);
  }
}
'''

files['lib/data/repositories/settings_repository_impl.dart'] = '''import '../../domain/entities/currency_code.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/daos/settings_dao.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDao _dao;

  SettingsRepositoryImpl(this._dao);

  @override
  Stream<CurrencyCode> watchDefaultCurrency() {
    return _dao.watchSettings().map((settings) => settings.defaultCurrency);
  }

  @override
  Future<CurrencyCode> getDefaultCurrency() async {
    final settings = await _dao.getSettings();
    return settings.defaultCurrency;
  }

  @override
  Future<void> setDefaultCurrency(CurrencyCode currency) async {
    final settings = await _dao.getSettings();
    await _dao.updateSettings(settings.copyWith(defaultCurrency: currency));
  }

  @override
  Stream<bool> watchIsDarkMode() {
    return _dao.watchSettings().map((settings) => settings.isDarkMode);
  }

  @override
  Future<bool> getIsDarkMode() async {
    final settings = await _dao.getSettings();
    return settings.isDarkMode;
  }

  @override
  Future<void> setIsDarkMode(bool isDark) async {
    final settings = await _dao.getSettings();
    await _dao.updateSettings(settings.copyWith(isDarkMode: isDark));
  }
}
'''

files['lib/data/providers/database_provider.dart'] = '''import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() {
    db.close();
  });
  return db;
});
'''

files['lib/data/providers/repository_providers.dart'] = '''import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../../domain/repositories/holdings_repository.dart';
import '../../domain/repositories/price_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../repositories/alerts_repository_impl.dart';
import '../repositories/holdings_repository_impl.dart';
import '../repositories/price_repository_impl.dart';
import '../repositories/settings_repository_impl.dart';
import '../services/metal_price_api_service.dart';
import 'database_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final apiServiceProvider = Provider<MetalPriceApiService>((ref) {
  return MetalPriceApiService(ref.watch(dioProvider));
});

final holdingsRepositoryProvider = Provider<HoldingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return HoldingsRepositoryImpl(db.holdingsDao);
});

final priceRepositoryProvider = Provider<PriceRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final api = ref.watch(apiServiceProvider);
  return PriceRepositoryImpl(db.pricesDao, api);
});

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AlertsRepositoryImpl(db.alertsDao);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsRepositoryImpl(db.settingsDao);
});
'''

files['lib/data/providers/price_providers.dart'] = '''import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/currency_code.dart';
import '../../domain/entities/metal_price.dart';
import '../../domain/entities/metal_type.dart';
import 'repository_providers.dart';

final currentCurrencyProvider = StateProvider<CurrencyCode>((ref) => CurrencyCode.gbp);

final latestPricesProvider = FutureProvider<Map<MetalType, MetalPrice>>((ref) async {
  final repo = ref.watch(priceRepositoryProvider);
  final currency = ref.watch(currentCurrencyProvider);
  return repo.getLatestPrices(currency, forceRefresh: false);
});

final autoRefreshPricesProvider = Provider<void>((ref) {
  final timer = Timer.periodic(const Duration(minutes: 5), (timer) {
    ref.invalidate(latestPricesProvider);
  });
  ref.onDispose(() => timer.cancel());
});
'''

files['lib/data/providers/holdings_providers.dart'] = '''import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/holding.dart';
import 'repository_providers.dart';

final holdingsStreamProvider = StreamProvider<List<Holding>>((ref) {
  final repo = ref.watch(holdingsRepositoryProvider);
  return repo.watchAllHoldings();
});

final holdingsNotifierProvider = StateNotifierProvider<HoldingsNotifier, AsyncValue<List<Holding>>>((ref) {
  return HoldingsNotifier(ref);
});

class HoldingsNotifier extends StateNotifier<AsyncValue<List<Holding>>> {
  final Ref _ref;

  HoldingsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadHoldings();
  }

  Future<void> _loadHoldings() async {
    try {
      final repo = _ref.read(holdingsRepositoryProvider);
      final holdings = await repo.getAllHoldings();
      state = AsyncValue.data(holdings);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addHolding(Holding holding) async {
    await _ref.read(holdingsRepositoryProvider).addHolding(holding);
    await _loadHoldings();
  }

  Future<void> updateHolding(Holding holding) async {
    await _ref.read(holdingsRepositoryProvider).updateHolding(holding);
    await _loadHoldings();
  }

  Future<void> deleteHolding(String id) async {
    await _ref.read(holdingsRepositoryProvider).deleteHolding(id);
    await _loadHoldings();
  }
}
'''

files['lib/data/providers/portfolio_providers.dart'] = '''import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/entities/portfolio_summary.dart';
import 'holdings_providers.dart';
import 'price_providers.dart';
import 'package:decimal/decimal.dart';

final portfolioSummaryProvider = Provider<AsyncValue<PortfolioSummary>>((ref) {
  final holdingsAsync = ref.watch(holdingsStreamProvider);
  final pricesAsync = ref.watch(latestPricesProvider);

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
'''

for path, content in files.items():
    with open(f'/Volumes/SSD/MetalTracker/{path}', 'w') as f:
        f.write(content)
print("Repositories and providers generated successfully.")
