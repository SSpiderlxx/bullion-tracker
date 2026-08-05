import '../../domain/entities/currency_code.dart';
import '../../domain/repositories/settings_repository.dart';
import '../database/daos/settings_dao.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDao _dao;

  SettingsRepositoryImpl(this._dao);

  @override
  Stream<CurrencyCode> watchDefaultCurrency() {
    return _dao.watchSettings().map((settings) => settings?.defaultCurrency ?? CurrencyCode.gbp);
  }

  @override
  Future<CurrencyCode> getDefaultCurrency() async {
    final settings = _dao.getSettings();
    return settings?.defaultCurrency ?? CurrencyCode.gbp;
  }

  @override
  Future<void> setDefaultCurrency(CurrencyCode currency) async {
    final settings = _dao.getSettings();
    if (settings != null) {
      _dao.updateSettings(
        AppSettingData(
          defaultCurrency: currency,
          isDarkMode: settings.isDarkMode,
        ),
      );
    } else {
      _dao.insertSettings(
        AppSettingData(
          defaultCurrency: currency,
          isDarkMode: false,
        ),
      );
    }
  }

  @override
  Stream<bool> watchIsDarkMode() {
    return _dao.watchSettings().map((settings) => settings?.isDarkMode ?? false);
  }

  @override
  Future<bool> getIsDarkMode() async {
    final settings = _dao.getSettings();
    return settings?.isDarkMode ?? false;
  }

  @override
  Future<void> setIsDarkMode(bool isDark) async {
    final settings = _dao.getSettings();
    if (settings != null) {
      _dao.updateSettings(
        AppSettingData(
          defaultCurrency: settings.defaultCurrency,
          isDarkMode: isDark,
        ),
      );
    } else {
      _dao.insertSettings(
        AppSettingData(
          defaultCurrency: CurrencyCode.gbp,
          isDarkMode: isDark,
        ),
      );
    }
  }
}
