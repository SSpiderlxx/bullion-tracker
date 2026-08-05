import os

files = {}

files['lib/data/services/metal_price_api_service.dart'] = '''import 'package:dio/dio.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/entities/currency_code.dart';
import '../../domain/entities/metal_price.dart';

class MetalPriceApiService {
  final Dio _dio;
  
  // Note: Replace with an actual API key or use a different free service if this requires one.
  // Using a mock implementation for free tier if no key is provided, or a generic free endpoint.
  static const String _baseUrl = 'https://api.metalpriceapi.com/v1';
  static const String _apiKey = 'YOUR_API_KEY'; // TODO: inject from environment

  MetalPriceApiService(this._dio);

  Future<Map<MetalType, MetalPrice>> fetchLatestPrices(CurrencyCode currency) async {
    try {
      final response = await _dio.get(
        '\$_baseUrl/latest',
        queryParameters: {
          'api_key': _apiKey,
          'base': currency.name.toUpperCase(),
          'currencies': 'XAU,XAG',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final rates = data['rates'] as Map<String, dynamic>;
          
          final now = DateTime.now();
          
          final goldRate = 1 / (rates['XAU'] as num).toDouble();
          final silverRate = 1 / (rates['XAG'] as num).toDouble();
          
          return {
            MetalType.gold: MetalPrice(
              metalType: MetalType.gold,
              pricePerTroyOz: goldRate,
              currency: currency,
              timestamp: now,
              changePercent24h: 0.0, // API might not provide this directly in /latest
              changeAmount24h: 0.0,
            ),
            MetalType.silver: MetalPrice(
              metalType: MetalType.silver,
              pricePerTroyOz: silverRate,
              currency: currency,
              timestamp: now,
              changePercent24h: 0.0,
              changeAmount24h: 0.0,
            ),
          };
        }
      }
      throw Exception('Failed to fetch metal prices');
    } catch (e) {
      throw Exception('Network error: \$e');
    }
  }

  Future<List<MetalPrice>> fetchPriceHistory(MetalType metal, CurrencyCode currency, int days) async {
    // Implement history fetch based on API documentation
    // Placeholder returning empty list for now
    return [];
  }
}
'''

files['lib/domain/repositories/holdings_repository.dart'] = '''import '../entities/holding.dart';

abstract class HoldingsRepository {
  Stream<List<Holding>> watchAllHoldings();
  Future<List<Holding>> getAllHoldings();
  Future<Holding?> getHoldingById(String id);
  Future<void> addHolding(Holding holding);
  Future<void> updateHolding(Holding holding);
  Future<void> deleteHolding(String id);
}
'''

files['lib/domain/repositories/price_repository.dart'] = '''import '../entities/metal_type.dart';
import '../entities/currency_code.dart';
import '../entities/metal_price.dart';

abstract class PriceRepository {
  Stream<List<MetalPrice>> watchAllPrices();
  Future<Map<MetalType, MetalPrice>> getLatestPrices(CurrencyCode currency, {bool forceRefresh = false});
  Future<List<MetalPrice>> getPriceHistory(MetalType metal, CurrencyCode currency, int days);
}
'''

files['lib/domain/repositories/alerts_repository.dart'] = '''import '../entities/price_alert.dart';

abstract class AlertsRepository {
  Stream<List<PriceAlert>> watchAllAlerts();
  Future<List<PriceAlert>> getAllAlerts();
  Future<void> addAlert(PriceAlert alert);
  Future<void> updateAlert(PriceAlert alert);
  Future<void> deleteAlert(String id);
}
'''

files['lib/domain/repositories/settings_repository.dart'] = '''import '../entities/currency_code.dart';

abstract class SettingsRepository {
  Stream<CurrencyCode> watchDefaultCurrency();
  Future<CurrencyCode> getDefaultCurrency();
  Future<void> setDefaultCurrency(CurrencyCode currency);
  
  Stream<bool> watchIsDarkMode();
  Future<bool> getIsDarkMode();
  Future<void> setIsDarkMode(bool isDark);
}
'''

for path, content in files.items():
    with open(f'/Volumes/SSD/MetalTracker/{path}', 'w') as f:
        f.write(content)
print("Interfaces generated successfully.")
