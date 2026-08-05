import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../domain/repositories/alerts_repository.dart';
import '../../domain/repositories/holdings_repository.dart';
import '../../domain/repositories/price_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../repositories/alerts_repository_impl.dart';
import '../repositories/holdings_repository_impl.dart';
import '../repositories/price_repository_impl.dart';
import '../repositories/settings_repository_impl.dart';
import '../services/metal_price_api_service.dart';
import '../database/daos/alerts_dao.dart';
import '../database/daos/holdings_dao.dart';
import '../database/daos/prices_dao.dart';
import '../database/daos/settings_dao.dart';
import 'database_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

final metalPriceApiServiceProvider = Provider<MetalPriceApiService>((ref) {
  return MetalPriceApiService(ref.watch(dioProvider));
});

final holdingsRepositoryProvider = Provider<HoldingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return HoldingsRepositoryImpl(HoldingsDao(db));
});

final priceRepositoryProvider = Provider<PriceRepository>((ref) {
  final db = ref.watch(databaseProvider);
  final apiService = ref.watch(metalPriceApiServiceProvider);
  return PriceRepositoryImpl(PricesDao(db), apiService);
});

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return AlertsRepositoryImpl(AlertsDao(db));
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsRepositoryImpl(SettingsDao(db));
});
