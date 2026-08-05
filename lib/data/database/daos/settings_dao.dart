import '../app_database.dart';
import 'package:bullion_tracker/domain/entities/currency_code.dart';

class AppSettingData {
  final CurrencyCode defaultCurrency;
  final bool isDarkMode;

  const AppSettingData({
    required this.defaultCurrency,
    required this.isDarkMode,
  });
}

class SettingsDao {
  final AppDatabase _db;

  SettingsDao(this._db);

  AppSettingData? getSettings() {
    final results = _db.db.select('SELECT * FROM app_settings ORDER BY id DESC LIMIT 1');
    if (results.isEmpty) return null;
    return _mapFromRow(results.first);
  }

  Stream<AppSettingData?> watchSettings() async* {
    yield getSettings();
    await for (final _ in _db.settingsStream) {
      yield getSettings();
    }
  }

  void updateSettings(AppSettingData settings) {
    _db.db.execute('''
      UPDATE app_settings SET
        defaultCurrency = ?, isDarkMode = ?
      WHERE id = (SELECT id FROM app_settings ORDER BY id DESC LIMIT 1)
    ''', [
      settings.defaultCurrency.index,
      settings.isDarkMode ? 1 : 0,
    ]);
    _db.notifySettings();
  }
  
  void insertSettings(AppSettingData settings) {
     _db.db.execute('''
      INSERT INTO app_settings (defaultCurrency, isDarkMode) VALUES (?, ?)
    ''', [
      settings.defaultCurrency.index,
      settings.isDarkMode ? 1 : 0,
    ]);
    _db.notifySettings();
  }

  AppSettingData _mapFromRow(Map<String, dynamic> row) {
    return AppSettingData(
      defaultCurrency: CurrencyCode.values[row['defaultCurrency'] as int],
      isDarkMode: (row['isDarkMode'] as int) == 1,
    );
  }
}
