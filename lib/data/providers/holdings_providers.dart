import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/holding.dart';
import 'repository_providers.dart';

final allHoldingsProvider = StreamProvider<List<Holding>>((ref) {
  final repo = ref.watch(holdingsRepositoryProvider);
  return repo.watchAllHoldings();
});

final activeHoldingsProvider = Provider<AsyncValue<List<Holding>>>((ref) {
  final asyncHoldings = ref.watch(allHoldingsProvider);
  return asyncHoldings.whenData((holdings) => 
    holdings.where((h) => !h.isSold).toList()
  );
});

final holdingByIdProvider = FutureProvider.family<Holding?, String>((ref, id) async {
  final repo = ref.watch(holdingsRepositoryProvider);
  return repo.getHoldingById(id);
});

class HoldingsNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  HoldingsNotifier(this._ref) : super(const AsyncData(null));

  Future<void> addHolding(Holding holding) async {
    state = const AsyncLoading();
    try {
      final repo = _ref.read(holdingsRepositoryProvider);
      await repo.addHolding(holding);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateHolding(Holding holding) async {
    state = const AsyncLoading();
    try {
      final repo = _ref.read(holdingsRepositoryProvider);
      await repo.updateHolding(holding);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteHolding(String id) async {
    state = const AsyncLoading();
    try {
      final repo = _ref.read(holdingsRepositoryProvider);
      await repo.deleteHolding(id);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final holdingsNotifierProvider = StateNotifierProvider<HoldingsNotifier, AsyncValue<void>>((ref) {
  return HoldingsNotifier(ref);
});
