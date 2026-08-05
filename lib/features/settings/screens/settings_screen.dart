import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _buildSectionHeader('Preferences'),
          _buildListTile(Icons.currency_pound, 'Currency', trailing: const Text('GBP')),
          _buildListTile(Icons.scale, 'Weight Unit', trailing: const Text('Troy Oz')),
          _buildListTile(Icons.dark_mode, 'Theme', trailing: const Text('System')),
          
          _buildSectionHeader('Security'),
          _buildListTile(Icons.fingerprint, 'Biometric Lock', trailing: Switch(value: false, onChanged: (v){})),
          
          _buildSectionHeader('Data'),
          _buildListTile(Icons.cloud_upload, 'Cloud Backup', trailing: Switch(value: true, onChanged: (v){})),
          _buildListTile(Icons.file_download, 'Export to CSV'),
          _buildListTile(Icons.backup, 'Export JSON Backup'),
          _buildListTile(Icons.restore, 'Import Data'),
          
          _buildSectionHeader('About'),
          _buildListTile(Icons.info, 'App Version', trailing: const Text('1.0.0')),
          _buildListTile(Icons.privacy_tip, 'Privacy Policy'),
          _buildListTile(Icons.description, 'Terms of Service'),
          
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.loss, foregroundColor: Colors.white),
              onPressed: () {},
              child: const Text('Sign Out'),
            ),
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
        style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, {Widget? trailing}) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: trailing is Switch ? null : () {},
    );
  }
}
