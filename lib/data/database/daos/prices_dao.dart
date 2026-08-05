import '../app_database.dart';
import 'package:bullion_tracker/domain/entities/metal_price.dart';
import 'package:bullion_tracker/domain/entities/metal_type.dart';
import 'package:bullion_tracker/domain/entities/currency_code.dart';

class PricesDao {
  final AppDatabase _db;

  PricesDao(this._db);

  List<MetalPrice> getAllPrices() {
    final results = _db.db.select('SELECT * FROM metal_prices');
    return results.map(_mapFromRow).toList();
  }

  Stream<List<MetalPrice>> watchAllPrices() async* {
    yield getAllPrices();
    await for (final _ in _db.pricesStream) {
      yield getAllPrices();
    }
  }

  MetalPrice? getLatestPrice(MetalType metal, CurrencyCode currency) {
    final results = _db.db.select(
      'SELECT * FROM metal_prices WHERE metalType = ? AND currency = ?',
      [metal.index, currency.index]
    );
    if (results.isEmpty) return null;
    return _mapFromRow(results.first);
  }

  void insertOrUpdatePrice(MetalPrice price) {
    _db.db.execute('''
      INSERT INTO metal_prices (
        metalType, pricePerTroyOz, currency, timestamp, changePercent24h, changeAmount24h
      ) VALUES (?, ?, ?, ?, ?, ?)
      ON CONFLICT(metalType, currency) DO UPDATE SET
        pricePerTroyOz = excluded.pricePerTroyOz,
        timestamp = excluded.timestamp,
        changePercent24h = excluded.changePercent24h,
        changeAmount24h = excluded.changeAmount24h
    ''', [
      price.metalType.index,
      price.pricePerTroyOz,
      price.currency.index,
      price.timestamp.toIso8601String(),
      price.changePercent24h,
      price.changeAmount24h,
    ]);
    _db.notifyPrices();
  }

  void insertPriceHistory(List<MetalPrice> history) {
    final stmt = _db.db.prepare('''
      INSERT OR REPLACE INTO price_history (
        id, metalType, pricePerTroyOz, currency, timestamp
      ) VALUES (?, ?, ?, ?, ?)
    ''');
    
    for (final p in history) {
      final id = '${p.metalType.name}_${p.currency.name}_${p.timestamp.millisecondsSinceEpoch}';
      stmt.execute([
        id,
        p.metalType.index,
        p.pricePerTroyOz,
        p.currency.index,
        p.timestamp.toIso8601String(),
      ]);
    }
    stmt.dispose();
  }

  List<MetalPrice> getHistory(MetalType metal, CurrencyCode currency, int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    final results = _db.db.select('''
      SELECT * FROM price_history
      WHERE metalType = ? AND currency = ? AND timestamp >= ?
      ORDER BY timestamp ASC
    ''', [
      metal.index,
      currency.index,
      cutoff.toIso8601String()
    ]);
    
    return results.map((row) => MetalPrice(
      metalType: MetalType.values[row['metalType'] as int],
      pricePerTroyOz: row['pricePerTroyOz'] as double,
      currency: CurrencyCode.values[row['currency'] as int],
      timestamp: DateTime.parse(row['timestamp'] as String),
      changePercent24h: 0.0,
      changeAmount24h: 0.0,
    )).toList();
  }

  MetalPrice _mapFromRow(Map<String, dynamic> row) {
    return MetalPrice(
      metalType: MetalType.values[row['metalType'] as int],
      pricePerTroyOz: row['pricePerTroyOz'] as double,
      currency: CurrencyCode.values[row['currency'] as int],
      timestamp: DateTime.parse(row['timestamp'] as String),
      changePercent24h: row['changePercent24h'] as double,
      changeAmount24h: row['changeAmount24h'] as double,
    );
  }
}
