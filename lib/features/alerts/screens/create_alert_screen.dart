import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/metal_type.dart';
import '../../../domain/entities/price_alert.dart';
import '../../../data/providers/alerts_providers.dart';
import '../../../data/providers/price_providers.dart';

class CreateAlertScreen extends HookConsumerWidget {
  const CreateAlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetController = useTextEditingController();
    final isGold = useState(true);
    final isAbove = useState(true);
    final currentCurrency = ref.watch(selectedCurrencyProvider);

    Future<void> saveAlert() async {
      final text = targetController.text.trim();
      final targetPrice = double.tryParse(text);
      if (targetPrice == null || targetPrice <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid target price.')),
        );
        return;
      }

      final alert = PriceAlert(
        id: const Uuid().v4(),
        metalType: isGold.value ? MetalType.gold : MetalType.silver,
        targetPrice: targetPrice,
        currency: currentCurrency,
        isAbove: isAbove.value,
        isEnabled: true,
        createdAt: DateTime.now(),
      );

      await ref.read(alertsNotifierProvider.notifier).addAlert(alert);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('New Alert'),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Gold')),
              ButtonSegment(value: false, label: Text('Silver')),
            ],
            selected: {isGold.value},
            onSelectionChanged: (s) => isGold.value = s.first,
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: targetController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: AppColors.textPrimaryDark),
            decoration: InputDecoration(
              labelText: 'Target Price (${currentCurrency.symbol})',
              labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
              border: const OutlineInputBorder(),
              prefixIcon: Icon(Icons.notifications_active, color: isGold.value ? AppColors.gold : AppColors.silver),
            ),
          ),
          const SizedBox(height: 24),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('Goes Above')),
              ButtonSegment(value: false, label: Text('Drops Below')),
            ],
            selected: {isAbove.value},
            onSelectionChanged: (s) => isAbove.value = s.first,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isGold.value ? AppColors.gold : AppColors.silver,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: saveAlert,
            child: const Text('Save Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
