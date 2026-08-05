import 'package:csv/csv.dart';
import '../../../domain/entities/holding.dart';
import '../../../domain/entities/metal_type.dart';
import '../../../domain/entities/weight_unit.dart';

class CsvService {
  String exportHoldingsToCsv(List<Holding> holdings) {
    final List<List<dynamic>> rows = [
      [
        'ID',
        'Metal Type',
        'Product Name',
        'Purchase Date',
        'Dealer',
        'Weight (Grams)',
        'Weight Unit',
        'Quantity',
        'Purity',
        'Purchase Price',
        'Premium Paid',
        'Shipping Cost',
        'Fees',
        'Total Cost',
        'Notes',
        'Is Sold',
        'Sold Date',
        'Sold Price',
      ],
      ...holdings.map((h) => [
            h.id,
            h.metalType.name,
            h.productName,
            h.purchaseDate.toIso8601String(),
            h.dealer,
            h.weightInGrams,
            h.weightUnit.name,
            h.displayQuantity,
            h.purity,
            h.purchasePrice,
            h.premiumPaid,
            h.shippingCost,
            h.fees,
            h.totalCost,
            h.notes ?? '',
            h.isSold ? 1 : 0,
            h.soldDate?.toIso8601String() ?? '',
            h.soldPrice ?? '',
          ]),
    ];

    return const ListToCsvConverter().convert(rows);
  }

  List<Holding> importHoldingsFromCsv(String csvData) {
    final List<List<dynamic>> rows = const CsvToListConverter().convert(csvData);
    if (rows.isEmpty || rows.length == 1) return [];

    final holdings = <Holding>[];
    // Skip header row
    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 14) continue;

      try {
        final metalTypeName = row[1].toString().toLowerCase();
        final metalType = MetalType.values.firstWhere(
          (m) => m.name.toLowerCase() == metalTypeName,
          orElse: () => MetalType.gold,
        );

        final unitName = row[6].toString().toLowerCase();
        final weightUnit = WeightUnit.values.firstWhere(
          (u) => u.name.toLowerCase() == unitName,
          orElse: () => WeightUnit.troyOunce,
        );

        holdings.add(
          Holding(
            id: row[0].toString(),
            metalType: metalType,
            productName: row[2].toString(),
            purchaseDate: DateTime.tryParse(row[3].toString()) ?? DateTime.now(),
            dealer: row[4].toString(),
            weightInGrams: (row[5] as num).toDouble(),
            weightUnit: weightUnit,
            displayQuantity: (row[7] as num).toDouble(),
            purity: (row[8] as num).toDouble(),
            purchasePrice: (row[9] as num).toDouble(),
            premiumPaid: (row[10] as num).toDouble(),
            shippingCost: (row[11] as num).toDouble(),
            fees: (row[12] as num).toDouble(),
            totalCost: (row[13] as num).toDouble(),
            notes: row.length > 14 && row[14].toString().isNotEmpty ? row[14].toString() : null,
            isSold: row.length > 15 ? (row[15] == 1 || row[15].toString() == 'true') : false,
            soldDate: row.length > 16 && row[16].toString().isNotEmpty ? DateTime.tryParse(row[16].toString()) : null,
            soldPrice: row.length > 17 && row[17].toString().isNotEmpty ? double.tryParse(row[17].toString()) : null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      } catch (e) {
        // Skip malformed rows
      }
    }

    return holdings;
  }
}
