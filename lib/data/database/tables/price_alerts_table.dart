const String createPriceAlertsTable = '''
  CREATE TABLE IF NOT EXISTS price_alerts (
    id TEXT PRIMARY KEY,
    metalType INTEGER NOT NULL,
    targetPrice REAL NOT NULL,
    isAbove INTEGER NOT NULL,
    isEnabled INTEGER NOT NULL DEFAULT 1,
    triggeredAt TEXT,
    createdAt TEXT NOT NULL
  )
''';
