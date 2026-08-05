import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ImportExportScreen extends StatelessWidget {
  const ImportExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import / Export Data')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Export', style: TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ListTile(
            tileColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.table_chart, color: AppColors.gold),
            title: const Text('Export to CSV'),
            subtitle: const Text('Export your holdings to a spreadsheet'),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.backup, color: AppColors.gold),
            title: const Text('Export JSON Backup'),
            subtitle: const Text('Create a full backup of your data'),
            onTap: () {},
          ),
          const SizedBox(height: 32),
          const Text('Import', style: TextStyle(color: AppColors.silver, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ListTile(
            tileColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.upload_file, color: AppColors.silver),
            title: const Text('Import from CSV'),
            subtitle: const Text('Import holdings from a spreadsheet'),
            onTap: () {},
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppColors.darkSurface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            leading: const Icon(Icons.restore, color: AppColors.silver),
            title: const Text('Restore from JSON'),
            subtitle: const Text('Restore data from a backup file'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
