import '../../domain/entities/currency_code.dart';
import '../../domain/entities/metal_price.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/repositories/price_repository.dart';
import '../database/daos/prices_dao.dart';
import '../services/metal_price_api_service.dart';

class PriceRepositoryImpl implements PriceRepository {
  final PricesDao _dao;
  final MetalPriceApiService _apiService;

  PriceRepositoryImpl(this._dao, this._apiService);

  @override
  Stream<List<MetalPrice>> watchAllPrices() {
    return _dao.watchAllPrices();
  }

  @override
  Future<Map<MetalType, MetalPrice>> getLatestPrices(CurrencyCode currency, {bool forceRefresh = false}) async {
    final Map<MetalType, MetalPrice> results = {};
    
    if (!forceRefresh) {
      for (final metal in MetalType.values) {
        final cached = _dao.getLatestPrice(metal, currency);
        if (cached != null) {
          final diff = DateTime.now().difference(cached.timestamp);
          if (diff.inMinutes < 5) {
            results[metal] = cached;
          }
        }
      }
    }

    if (results.length == MetalType.values.length) {
      return results;
    }

    try {
      final freshPrices = await _apiService.fetchLatestPrices(currency);
      for (final price in freshPrices.values) {
        _dao.insertOrUpdatePrice(price);
        results[price.metalType] = price;
      }
      return results;
    } catch (e) {
      // On failure, return whatever is cached even if stale
      for (final metal in MetalType.values) {
        final cached = _dao.getLatestPrice(metal, currency);
        if (cached != null && !results.containsKey(metal)) {
          results[metal] = cached;
        }
      }
      if (results.isEmpty) {
        throw Exception('Failed to fetch prices and no cached data available');
      }
      return results;
    }
  }

  @override
  Future<List<MetalPrice>> getPriceHistory(MetalType metal, CurrencyCode currency, int days) async {
    try {
      final history = await _apiService.fetchPriceHistory(metal, currency, days);
      if (history.isNotEmpty) {
        _dao.insertPriceHistory(history);
      }
    } catch (e) {
      // Ignore network errors, fallback to cache
    }

    final cachedHistory = _dao.getHistory(metal, currency, days);
    return cachedHistory;
  }
}
