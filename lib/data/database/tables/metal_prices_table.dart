const String createMetalPricesTable = '''
  CREATE TABLE IF NOT EXISTS metal_prices (
    metalType INTEGER NOT NULL,
    pricePerTroyOz REAL NOT NULL,
    currency INTEGER NOT NULL,
    timestamp TEXT NOT NULL,
    changePercent24h REAL NOT NULL,
    changeAmount24h REAL NOT NULL,
    PRIMARY KEY (metalType, currency)
  )
''';
