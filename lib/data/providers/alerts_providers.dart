import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/price_alert.dart';
import 'repository_providers.dart';

final allAlertsProvider = FutureProvider<List<PriceAlert>>((ref) async {
  final repo = ref.watch(alertsRepositoryProvider);
  return repo.getAllAlerts();
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
      final alerts = await repo.getAllAlerts();
      state = AsyncValue.data(alerts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addAlert(PriceAlert alert) async {
    final repo = ref.read(alertsRepositoryProvider);
    await repo.addAlert(alert);
    await loadAlerts();
  }

  Future<void> toggleAlert(PriceAlert alert, bool isEnabled) async {
    final repo = ref.read(alertsRepositoryProvider);
    final updated = PriceAlert(
      id: alert.id,
      metalType: alert.metalType,
      targetPrice: alert.targetPrice,
      currency: alert.currency,
      isAbove: alert.isAbove,
      isEnabled: isEnabled,
      triggeredAt: alert.triggeredAt,
      createdAt: alert.createdAt,
    );
    await repo.updateAlert(updated);
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
