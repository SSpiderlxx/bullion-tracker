import 'dart:convert';

class JsonBackupService {
  Future<String> createBackup(Map<String, dynamic> data) async {
    return jsonEncode(data);
  }

  Future<Map<String, dynamic>> restoreBackup(String jsonString) async {
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }
}
