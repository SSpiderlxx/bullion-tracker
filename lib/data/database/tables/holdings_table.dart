const String createHoldingsTable = '''
  CREATE TABLE IF NOT EXISTS holdings (
    id TEXT PRIMARY KEY,
    metalType INTEGER NOT NULL,
    productName TEXT NOT NULL,
    purchaseDate TEXT NOT NULL,
    dealer TEXT NOT NULL,
    weightInGrams REAL NOT NULL,
    weightUnit INTEGER NOT NULL,
    displayQuantity REAL NOT NULL,
    purity REAL NOT NULL,
    purchasePrice REAL NOT NULL,
    premiumPaid REAL NOT NULL,
    shippingCost REAL NOT NULL,
    fees REAL NOT NULL,
    totalCost REAL NOT NULL,
    notes TEXT,
    receiptPhotoPath TEXT,
    isSold INTEGER NOT NULL DEFAULT 0,
    soldDate TEXT,
    soldPrice REAL,
    soldQuantityGrams REAL,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL
  )
''';
