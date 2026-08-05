import '../entities/price_alert.dart';

abstract class AlertsRepository {
  Stream<List<PriceAlert>> watchAllAlerts();
  Future<List<PriceAlert>> getAllAlerts();
  Future<void> addAlert(PriceAlert alert);
  Future<void> updateAlert(PriceAlert alert);
  Future<void> deleteAlert(String id);
}
