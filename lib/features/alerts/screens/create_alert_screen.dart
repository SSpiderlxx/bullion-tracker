import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../core/theme/app_colors.dart';

class CreateAlertScreen extends HookConsumerWidget {
  const CreateAlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetController = useTextEditingController();
    final isGold = useState(true);
    final isAbove = useState(true);

    return Scaffold(
      appBar: AppBar(title: const Text('New Alert')),
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
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Target Price',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
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
              backgroundColor: AppColors.gold,
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Save Alert', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
