import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/price_alert.dart';
import 'repository_providers.dart';

final allAlertsProvider = FutureProvider<List<PriceAlert>>((ref) async {
  final repo = ref.watch(alertsRepositoryProvider);
  return repo.getAlerts();
});

class AlertsNotifier extends StateNotifier<AsyncValue<List<PriceAlert>>> {
  final Ref ref;

  AlertsNotifier(this.ref) : super(const AsyncValue.loading()) {
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(alertsRepositoryProvider);
      final alerts = await repo.getAlerts();
      state = AsyncValue.data(alerts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAlert(PriceAlert alert) async {
    final repo = ref.read(alertsRepositoryProvider);
    await repo.createAlert(alert);
    await loadAlerts();
  }

  Future<void> toggleAlert(String id, bool isEnabled) async {
    final repo = ref.read(alertsRepositoryProvider);
    await repo.toggleAlert(id, isEnabled);
    await loadAlerts();
  }

  Future<void> deleteAlert(String id) async {
    final repo = ref.read(alertsRepositoryProvider);
    await repo.deleteAlert(id);
    await loadAlerts();
  }
}

final alertsNotifierProvider =
    StateNotifierProvider<AlertsNotifier, AsyncValue<List<PriceAlert>>>((ref) {
  return AlertsNotifier(ref);
});
