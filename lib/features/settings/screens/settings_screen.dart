import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/currency_code.dart';
import '../../../data/providers/price_providers.dart';

class SettingsScreen extends HookConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCurrency = ref.watch(selectedCurrencyProvider);

    void showCurrencyPicker() {
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.surfaceDark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Select Display Currency',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const Divider(color: Colors.white10),
                ...CurrencyCode.values.map((currency) {
                  final isSelected = currency == currentCurrency;
                  return ListTile(
                    leading: Text(
                      currency.symbol,
                      style: TextStyle(
                        color: isSelected ? AppColors.gold : AppColors.textPrimaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    title: Text(
                      currency.name.toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? AppColors.gold : AppColors.textPrimaryDark,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.gold) : null,
                    onTap: () {
                      ref.read(selectedCurrencyProvider.notifier).state = currency;
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Preferences'),
          _buildListTile(
            Icons.currency_exchange,
            'Currency',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${currentCurrency.symbol} (${currentCurrency.name.toUpperCase()})',
                  style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            onTap: showCurrencyPicker,
          ),
          _buildListTile(
            Icons.scale,
            'Weight Unit',
            trailing: const Text('Troy Oz', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          _buildListTile(
            Icons.dark_mode,
            'Theme',
            trailing: const Text('Dark Mode', style: TextStyle(color: AppColors.gold)),
          ),
          
          _buildSectionHeader('Data & Backup'),
          _buildListTile(
            Icons.import_export,
            'Import / Export Data',
            subtitle: 'CSV spreadsheet export and JSON portfolio backups',
            onTap: () => context.push('/import-export'),
          ),
          
          _buildSectionHeader('Security'),
          _buildListTile(
            Icons.fingerprint,
            'Biometric Lock',
            trailing: Switch(
              value: false,
              activeThumbColor: AppColors.gold,
              onChanged: (v) {},
            ),
          ),

          _buildSectionHeader('About Bullion Tracker'),
          _buildListTile(
            Icons.info_outline,
            'App Version',
            trailing: const Text('1.0.0+1', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          _buildListTile(
            Icons.shield_outlined,
            'License & Privacy',
            subtitle: 'Open Source MIT License',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {String? subtitle, Widget? trailing, VoidCallback? onTap}) {
    return ListTile(
      tileColor: AppColors.surfaceDark,
      leading: Icon(icon, color: AppColors.gold),
      title: Text(title, style: const TextStyle(color: AppColors.textPrimaryDark)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
