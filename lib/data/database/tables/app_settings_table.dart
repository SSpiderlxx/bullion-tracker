const String createAppSettingsTable = '''
  CREATE TABLE IF NOT EXISTS app_settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    defaultCurrency INTEGER NOT NULL DEFAULT 0,
    isDarkMode INTEGER NOT NULL DEFAULT 0
  )
''';
