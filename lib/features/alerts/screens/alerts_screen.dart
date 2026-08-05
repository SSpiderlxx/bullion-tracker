import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../data/providers/alerts_providers.dart';
import '../widgets/alert_card.dart';
import 'create_alert_screen.dart';

class AlertsScreen extends HookConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alertsAsync = ref.watch(alertsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Price Alerts'),
        backgroundColor: AppColors.surfaceDark,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateAlertScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: alertsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.gold)),
        error: (err, stack) => Center(
          child: Text('Error loading alerts: $err', style: const TextStyle(color: Colors.white)),
        ),
        data: (alerts) {
          if (alerts.isEmpty) {
            return EmptyState(
              icon: Icons.notifications_off_outlined,
              title: 'No Active Price Alerts',
              message: 'Set up price alerts for Gold and Silver to get notified when prices reach your targets.',
              buttonText: 'Create First Alert',
              onButtonPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateAlertScreen()),
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.gold,
            backgroundColor: AppColors.surfaceDark,
            onRefresh: () async {
              await ref.read(alertsNotifierProvider.notifier).loadAlerts();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return AlertCard(
                  alert: alert,
                  onToggle: (enabled) {
                    ref.read(alertsNotifierProvider.notifier).toggleAlert(alert, enabled);
                  },
                  onDelete: () {
                    ref.read(alertsNotifierProvider.notifier).deleteAlert(alert.id);
                  },
                ).animate().fadeIn(delay: (index * 50).ms).slideX();
              },
            ),
          );
        },
      ),
    );
  }
}
