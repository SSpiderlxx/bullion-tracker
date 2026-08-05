import 'metal_type.dart';
import 'currency_code.dart';

class MetalPrice {
  final MetalType metalType;
  final double pricePerTroyOz;
  final CurrencyCode currency;
  final DateTime timestamp;
  final double changePercent24h;
  final double changeAmount24h;

  const MetalPrice({
    required this.metalType,
    required this.pricePerTroyOz,
    required this.currency,
    required this.timestamp,
    required this.changePercent24h,
    required this.changeAmount24h,
  });

  double get pricePerGram => pricePerTroyOz / 31.1034768;
  double get pricePerKg => pricePerGram * 1000;
}
