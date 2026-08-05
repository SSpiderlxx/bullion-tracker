const String createPriceHistoryTable = '''
  CREATE TABLE IF NOT EXISTS price_history (
    id TEXT PRIMARY KEY,
    metalType INTEGER NOT NULL,
    pricePerTroyOz REAL NOT NULL,
    currency INTEGER NOT NULL,
    timestamp TEXT NOT NULL
  )
''';
