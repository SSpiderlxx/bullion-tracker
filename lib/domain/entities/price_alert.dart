import 'metal_type.dart';

class PriceAlert {
  final String id;
  final MetalType metalType;
  final double targetPrice;
  final bool isAbove;
  final bool isEnabled;
  final DateTime? triggeredAt;
  final DateTime createdAt;

  const PriceAlert({
    required this.id,
    required this.metalType,
    required this.targetPrice,
    required this.isAbove,
    required this.isEnabled,
    this.triggeredAt,
    required this.createdAt,
  });
}
