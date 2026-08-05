import '../entities/currency_code.dart';

abstract class SettingsRepository {
  Stream<CurrencyCode> watchDefaultCurrency();
  Future<CurrencyCode> getDefaultCurrency();
  Future<void> setDefaultCurrency(CurrencyCode currency);
  
  Stream<bool> watchIsDarkMode();
  Future<bool> getIsDarkMode();
  Future<void> setIsDarkMode(bool isDark);
}
