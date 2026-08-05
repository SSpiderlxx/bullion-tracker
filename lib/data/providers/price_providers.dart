import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/currency_code.dart';
import '../../domain/entities/metal_price.dart';
import '../../domain/entities/metal_type.dart';
import 'repository_providers.dart';

final selectedCurrencyProvider = StateProvider<CurrencyCode>((ref) => CurrencyCode.gbp);

final livePricesProvider = StreamProvider<Map<MetalType, MetalPrice>>((ref) async* {
  final repo = ref.watch(priceRepositoryProvider);
  final currency = ref.watch(selectedCurrencyProvider);
  
  // Initial fetch
  yield await repo.getLatestPrices(currency);
  
  // Auto-refresh every 60 seconds
  final stream = Stream.periodic(const Duration(seconds: 60), (_) {
    return repo.getLatestPrices(currency, forceRefresh: true);
  }).asyncMap((event) => event);
  
  yield* stream;
});

final goldPriceProvider = Provider<AsyncValue<MetalPrice?>>((ref) {
  return ref.watch(livePricesProvider).whenData((prices) => prices[MetalType.gold]);
});

final silverPriceProvider = Provider<AsyncValue<MetalPrice?>>((ref) {
  return ref.watch(livePricesProvider).whenData((prices) => prices[MetalType.silver]);
});

final priceHistoryProvider = FutureProvider.family<List<MetalPrice>, ({MetalType metal, int days})>((ref, args) async {
  final repo = ref.watch(priceRepositoryProvider);
  final currency = ref.watch(selectedCurrencyProvider);
  return repo.getPriceHistory(args.metal, currency, args.days);
});
final spotPriceProvider = Provider.family<double, MetalType>((ref, metal) {
  final prices = ref.watch(livePricesProvider).value;
  return prices?[metal]?.pricePerTroyOz ?? 0.0;
});
