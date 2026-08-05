import '../entities/holding.dart';

abstract class HoldingsRepository {
  Stream<List<Holding>> watchAllHoldings();
  Future<List<Holding>> getAllHoldings();
  Future<Holding?> getHoldingById(String id);
  Future<void> addHolding(Holding holding);
  Future<void> updateHolding(Holding holding);
  Future<void> deleteHolding(String id);
}
