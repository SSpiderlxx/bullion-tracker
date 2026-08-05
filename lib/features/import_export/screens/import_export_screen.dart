import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/providers/holdings_providers.dart';
import '../services/csv_service.dart';
import '../services/json_backup_service.dart';

class ImportExportScreen extends HookConsumerWidget {
  const ImportExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holdingsAsync = ref.watch(allHoldingsProvider);

    Future<void> exportCsv() async {
      final holdings = holdingsAsync.value ?? [];
      if (holdings.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No holdings available to export.')),
        );
        return;
      }

      final csvData = CsvService().exportHoldingsToCsv(holdings);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/bullion_holdings.csv');
      await file.writeAsString(csvData);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Bullion Tracker CSV Export',
      );
    }

    Future<void> exportJson() async {
      final holdings = holdingsAsync.value ?? [];
      if (holdings.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No holdings available to export.')),
        );
        return;
      }

      final jsonData = JsonBackupService().createBackup(holdings);
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/bullion_backup.json');
      await file.writeAsString(jsonData);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Bullion Tracker JSON Backup',
      );
    }

    Future<void> importCsv() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final csvContent = await file.readAsString();
        final newHoldings = CsvService().importHoldingsFromCsv(csvContent);

        if (newHoldings.isNotEmpty) {
          for (final h in newHoldings) {
            await ref.read(holdingsNotifierProvider.notifier).addHolding(h);
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Successfully imported ${newHoldings.length} holdings!')),
            );
          }
        }
      }
    }

    Future<void> importJson() async {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonContent = await file.readAsString();
        final newHoldings = JsonBackupService().restoreBackup(jsonContent);

        if (newHoldings.isNotEmpty) {
          for (final h in newHoldings) {
            await ref.read(holdingsNotifierProvider.notifier).addHolding(h);
          }
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Successfully restored ${newHoldings.length} holdings from backup!')),
            );
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Import / Export Data'),
        backgroundColor: AppColors.surfaceDark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Export Options', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ListTile(
            tileColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.table_chart, color: AppColors.gold),
            title: const Text('Export to CSV', style: TextStyle(color: AppColors.textPrimaryDark)),
            subtitle: const Text('Export your holdings to a CSV spreadsheet', style: TextStyle(color: AppColors.textSecondaryDark)),
            onTap: exportCsv,
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.backup, color: AppColors.gold),
            title: const Text('Export JSON Backup', style: TextStyle(color: AppColors.textPrimaryDark)),
            subtitle: const Text('Create a full backup of your portfolio data', style: TextStyle(color: AppColors.textSecondaryDark)),
            onTap: exportJson,
          ),
          const SizedBox(height: 32),
          const Text('Import Options', style: TextStyle(color: AppColors.silver, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ListTile(
            tileColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.upload_file, color: AppColors.silver),
            title: const Text('Import from CSV', style: TextStyle(color: AppColors.textPrimaryDark)),
            subtitle: const Text('Import holdings from a CSV spreadsheet', style: TextStyle(color: AppColors.textSecondaryDark)),
            onTap: importCsv,
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.restore, color: AppColors.silver),
            title: const Text('Restore from JSON', style: TextStyle(color: AppColors.textPrimaryDark)),
            subtitle: const Text('Restore portfolio data from a backup file', style: TextStyle(color: AppColors.textSecondaryDark)),
            onTap: importJson,
          ),
        ],
      ),
    );
  }
}
