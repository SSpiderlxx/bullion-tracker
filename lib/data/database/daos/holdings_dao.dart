import '../app_database.dart';
import 'package:bullion_tracker/domain/entities/holding.dart';
import 'package:bullion_tracker/domain/entities/metal_type.dart';
import 'package:bullion_tracker/domain/entities/weight_unit.dart';

class HoldingsDao {
  final AppDatabase _db;

  HoldingsDao(this._db);

  List<Holding> getAllHoldings() {
    final results = _db.db.select('SELECT * FROM holdings');
    return results.map(_mapFromRow).toList();
  }
  
  Stream<List<Holding>> watchAllHoldings() async* {
    yield getAllHoldings();
    await for (final _ in _db.holdingsStream) {
      yield getAllHoldings();
    }
  }

  Holding? getHoldingById(String id) {
    final results = _db.db.select('SELECT * FROM holdings WHERE id = ?', [id]);
    if (results.isEmpty) return null;
    return _mapFromRow(results.first);
  }

  void insertHolding(Holding holding) {
    _db.db.execute('''
      INSERT INTO holdings (
        id, metalType, productName, purchaseDate, dealer, weightInGrams,
        weightUnit, displayQuantity, purity, purchasePrice, premiumPaid,
        shippingCost, fees, totalCost, notes, receiptPhotoPath, isSold,
        soldDate, soldPrice, soldQuantityGrams, createdAt, updatedAt
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      holding.id,
      holding.metalType.index,
      holding.productName,
      holding.purchaseDate.toIso8601String(),
      holding.dealer,
      holding.weightInGrams,
      holding.weightUnit.index,
      holding.displayQuantity,
      holding.purity,
      holding.purchasePrice,
      holding.premiumPaid,
      holding.shippingCost,
      holding.fees,
      holding.totalCost,
      holding.notes,
      holding.receiptPhotoPath,
      holding.isSold ? 1 : 0,
      holding.soldDate?.toIso8601String(),
      holding.soldPrice,
      holding.soldQuantityGrams,
      holding.createdAt.toIso8601String(),
      holding.updatedAt.toIso8601String(),
    ]);
    _db.notifyHoldings();
  }

  void updateHolding(Holding holding) {
    _db.db.execute('''
      UPDATE holdings SET
        metalType = ?, productName = ?, purchaseDate = ?, dealer = ?,
        weightInGrams = ?, weightUnit = ?, displayQuantity = ?, purity = ?,
        purchasePrice = ?, premiumPaid = ?, shippingCost = ?, fees = ?,
        totalCost = ?, notes = ?, receiptPhotoPath = ?, isSold = ?,
        soldDate = ?, soldPrice = ?, soldQuantityGrams = ?, createdAt = ?,
        updatedAt = ?
      WHERE id = ?
    ''', [
      holding.metalType.index,
      holding.productName,
      holding.purchaseDate.toIso8601String(),
      holding.dealer,
      holding.weightInGrams,
      holding.weightUnit.index,
      holding.displayQuantity,
      holding.purity,
      holding.purchasePrice,
      holding.premiumPaid,
      holding.shippingCost,
      holding.fees,
      holding.totalCost,
      holding.notes,
      holding.receiptPhotoPath,
      holding.isSold ? 1 : 0,
      holding.soldDate?.toIso8601String(),
      holding.soldPrice,
      holding.soldQuantityGrams,
      holding.createdAt.toIso8601String(),
      holding.updatedAt.toIso8601String(),
      holding.id,
    ]);
    _db.notifyHoldings();
  }

  void deleteHolding(String id) {
    _db.db.execute('DELETE FROM holdings WHERE id = ?', [id]);
    _db.notifyHoldings();
  }

  Holding _mapFromRow(Map<String, dynamic> row) {
    return Holding(
      id: row['id'] as String,
      metalType: MetalType.values[row['metalType'] as int],
      productName: row['productName'] as String,
      purchaseDate: DateTime.parse(row['purchaseDate'] as String),
      dealer: row['dealer'] as String,
      weightInGrams: row['weightInGrams'] as double,
      weightUnit: WeightUnit.values[row['weightUnit'] as int],
      displayQuantity: row['displayQuantity'] as double,
      purity: row['purity'] as double,
      purchasePrice: row['purchasePrice'] as double,
      premiumPaid: row['premiumPaid'] as double,
      shippingCost: row['shippingCost'] as double,
      fees: row['fees'] as double,
      totalCost: row['totalCost'] as double,
      notes: row['notes'] as String?,
      receiptPhotoPath: row['receiptPhotoPath'] as String?,
      isSold: (row['isSold'] as int) == 1,
      soldDate: row['soldDate'] != null ? DateTime.parse(row['soldDate'] as String) : null,
      soldPrice: row['soldPrice'] as double?,
      soldQuantityGrams: row['soldQuantityGrams'] as double?,
      createdAt: DateTime.parse(row['createdAt'] as String),
      updatedAt: DateTime.parse(row['updatedAt'] as String),
    );
  }
}
