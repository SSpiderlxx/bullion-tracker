import '../../domain/entities/price_alert.dart';
import '../../domain/repositories/alerts_repository.dart';
import '../database/daos/alerts_dao.dart';

class AlertsRepositoryImpl implements AlertsRepository {
  final AlertsDao _dao;

  AlertsRepositoryImpl(this._dao);

  @override
  Stream<List<PriceAlert>> watchAllAlerts() {
    return _dao.watchAllAlerts();
  }

  @override
  Future<List<PriceAlert>> getAllAlerts() async {
    return _dao.getAllAlerts();
  }

  @override
  Future<void> addAlert(PriceAlert alert) async {
    _dao.insertAlert(alert);
  }

  @override
  Future<void> updateAlert(PriceAlert alert) async {
    _dao.updateAlert(alert);
  }

  @override
  Future<void> deleteAlert(String id) async {
    _dao.deleteAlert(id);
  }
}
