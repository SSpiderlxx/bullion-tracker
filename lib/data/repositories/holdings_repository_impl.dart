import '../../domain/entities/holding.dart';
import '../../domain/repositories/holdings_repository.dart';
import '../database/daos/holdings_dao.dart';

class HoldingsRepositoryImpl implements HoldingsRepository {
  final HoldingsDao _dao;

  HoldingsRepositoryImpl(this._dao);

  @override
  Stream<List<Holding>> watchAllHoldings() {
    return _dao.watchAllHoldings();
  }

  @override
  Future<List<Holding>> getAllHoldings() async {
    return _dao.getAllHoldings();
  }

  @override
  Future<Holding?> getHoldingById(String id) async {
    try {
      return _dao.getHoldingById(id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addHolding(Holding holding) async {
    _dao.insertHolding(holding);
  }

  @override
  Future<void> updateHolding(Holding holding) async {
    _dao.updateHolding(holding);
  }

  @override
  Future<void> deleteHolding(String id) async {
    _dao.deleteHolding(id);
  }
}
