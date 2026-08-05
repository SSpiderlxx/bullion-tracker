import '../entities/metal_type.dart';
import '../entities/currency_code.dart';
import '../entities/metal_price.dart';

abstract class PriceRepository {
  Stream<List<MetalPrice>> watchAllPrices();
  Future<Map<MetalType, MetalPrice>> getLatestPrices(CurrencyCode currency, {bool forceRefresh = false});
  Future<List<MetalPrice>> getPriceHistory(MetalType metal, CurrencyCode currency, int days);
}
