import '../app_database.dart';
import 'package:bullion_tracker/domain/entities/price_alert.dart';
import 'package:bullion_tracker/domain/entities/metal_type.dart';

class AlertsDao {
  final AppDatabase _db;

  AlertsDao(this._db);

  List<PriceAlert> getAllAlerts() {
    final results = _db.db.select('SELECT * FROM price_alerts');
    return results.map(_mapFromRow).toList();
  }

  Stream<List<PriceAlert>> watchAllAlerts() async* {
    yield getAllAlerts();
    await for (final _ in _db.alertsStream) {
      yield getAllAlerts();
    }
  }

  void insertAlert(PriceAlert alert) {
    _db.db.execute('''
      INSERT INTO price_alerts (
        id, metalType, targetPrice, isAbove, isEnabled, triggeredAt, createdAt
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      alert.id,
      alert.metalType.index,
      alert.targetPrice,
      alert.isAbove ? 1 : 0,
      alert.isEnabled ? 1 : 0,
      alert.triggeredAt?.toIso8601String(),
      alert.createdAt.toIso8601String(),
    ]);
    _db.notifyAlerts();
  }

  void updateAlert(PriceAlert alert) {
    _db.db.execute('''
      UPDATE price_alerts SET
        metalType = ?, targetPrice = ?, isAbove = ?, isEnabled = ?,
        triggeredAt = ?, createdAt = ?
      WHERE id = ?
    ''', [
      alert.metalType.index,
      alert.targetPrice,
      alert.isAbove ? 1 : 0,
      alert.isEnabled ? 1 : 0,
      alert.triggeredAt?.toIso8601String(),
      alert.createdAt.toIso8601String(),
      alert.id,
    ]);
    _db.notifyAlerts();
  }

  void deleteAlert(String id) {
    _db.db.execute('DELETE FROM price_alerts WHERE id = ?', [id]);
    _db.notifyAlerts();
  }

  PriceAlert _mapFromRow(Map<String, dynamic> row) {
    return PriceAlert(
      id: row['id'] as String,
      metalType: MetalType.values[row['metalType'] as int],
      targetPrice: row['targetPrice'] as double,
      isAbove: (row['isAbove'] as int) == 1,
      isEnabled: (row['isEnabled'] as int) == 1,
      triggeredAt: row['triggeredAt'] != null ? DateTime.parse(row['triggeredAt'] as String) : null,
      createdAt: DateTime.parse(row['createdAt'] as String),
    );
  }
}
