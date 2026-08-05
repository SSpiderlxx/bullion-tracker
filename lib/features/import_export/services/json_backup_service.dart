import 'dart:convert';
import '../../../domain/entities/holding.dart';
import '../../../domain/entities/metal_type.dart';
import '../../../domain/entities/weight_unit.dart';

class JsonBackupService {
  String createBackup(List<Holding> holdings) {
    final data = {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'holdings': holdings
          .map((h) => {
                'id': h.id,
                'metalType': h.metalType.name,
                'productName': h.productName,
                'purchaseDate': h.purchaseDate.toIso8601String(),
                'dealer': h.dealer,
                'weightInGrams': h.weightInGrams,
                'weightUnit': h.weightUnit.name,
                'displayQuantity': h.displayQuantity,
                'purity': h.purity,
                'purchasePrice': h.purchasePrice,
                'premiumPaid': h.premiumPaid,
                'shippingCost': h.shippingCost,
                'fees': h.fees,
                'totalCost': h.totalCost,
                'notes': h.notes,
                'isSold': h.isSold,
                'soldDate': h.soldDate?.toIso8601String(),
                'soldPrice': h.soldPrice,
                'soldQuantityGrams': h.soldQuantityGrams,
                'createdAt': h.createdAt.toIso8601String(),
                'updatedAt': h.updatedAt.toIso8601String(),
              })
          .toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(data);
  }

  List<Holding> restoreBackup(String jsonString) {
    final Map<String, dynamic> decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final List<dynamic> rawHoldings = decoded['holdings'] as List<dynamic>? ?? [];

    return rawHoldings.map((item) {
      final map = item as Map<String, dynamic>;
      final metalTypeName = (map['metalType'] as String? ?? 'gold').toLowerCase();
      final metalType = MetalType.values.firstWhere(
        (m) => m.name.toLowerCase() == metalTypeName,
        orElse: () => MetalType.gold,
      );

      final unitName = (map['weightUnit'] as String? ?? 'troyOunce').toLowerCase();
      final weightUnit = WeightUnit.values.firstWhere(
        (u) => u.name.toLowerCase() == unitName,
        orElse: () => WeightUnit.troyOunce,
      );

      return Holding(
        id: map['id'] as String,
        metalType: metalType,
        productName: map['productName'] as String? ?? 'Unknown Item',
        purchaseDate: DateTime.tryParse(map['purchaseDate'] as String? ?? '') ?? DateTime.now(),
        dealer: map['dealer'] as String? ?? '',
        weightInGrams: (map['weightInGrams'] as num? ?? 0.0).toDouble(),
        weightUnit: weightUnit,
        displayQuantity: (map['displayQuantity'] as num? ?? 1.0).toDouble(),
        purity: (map['purity'] as num? ?? 1.0).toDouble(),
        purchasePrice: (map['purchasePrice'] as num? ?? 0.0).toDouble(),
        premiumPaid: (map['premiumPaid'] as num? ?? 0.0).toDouble(),
        shippingCost: (map['shippingCost'] as num? ?? 0.0).toDouble(),
        fees: (map['fees'] as num? ?? 0.0).toDouble(),
        totalCost: (map['totalCost'] as num? ?? 0.0).toDouble(),
        notes: map['notes'] as String?,
        isSold: map['isSold'] as bool? ?? false,
        soldDate: map['soldDate'] != null ? DateTime.tryParse(map['soldDate'] as String) : null,
        soldPrice: (map['soldPrice'] as num?)?.toDouble(),
        soldQuantityGrams: (map['soldQuantityGrams'] as num?)?.toDouble(),
        createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ?? DateTime.now(),
      );
    }).toList();
  }
}
