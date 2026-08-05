import 'package:dio/dio.dart';
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
