import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/metal_type.dart';
import '../widgets/alert_card.dart';
import 'create_alert_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Price Alerts')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.gold,
        foregroundColor: Colors.black,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateAlertScreen())),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AlertCard(metal: MetalType.gold, targetPrice: 2000, isAbove: true, isEnabled: true).animate().fadeIn(delay: 100.ms).slideX(),
          const SizedBox(height: 12),
          const AlertCard(metal: MetalType.silver, targetPrice: 25, isAbove: false, isEnabled: false).animate().fadeIn(delay: 200.ms).slideX(),
        ],
      ),
    );
  }
}
