import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import '../../domain/entities/currency_code.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  late Database _db;

  // Stream controllers for reactivity
  final _holdingsController = StreamController<void>.broadcast();
  final _pricesController = StreamController<void>.broadcast();
  final _alertsController = StreamController<void>.broadcast();
  final _settingsController = StreamController<void>.broadcast();

  Stream<void> get holdingsStream => _holdingsController.stream;
  Stream<void> get pricesStream => _pricesController.stream;
  Stream<void> get alertsStream => _alertsController.stream;
  Stream<void> get settingsStream => _settingsController.stream;

  void notifyHoldings() => _holdingsController.add(null);
  void notifyPrices() => _pricesController.add(null);
  void notifyAlerts() => _alertsController.add(null);
  void notifySettings() => _settingsController.add(null);

  Database get db => _db;

  Future<void> init() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'bullion_tracker.sqlite');
    _db = sqlite3.open(dbPath);

    _createTables();
  }

  void _createTables() {
    _db.execute('''
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
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS metal_prices (
        metalType INTEGER NOT NULL,
        pricePerTroyOz REAL NOT NULL,
        currency INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        changePercent24h REAL NOT NULL,
        changeAmount24h REAL NOT NULL,
        PRIMARY KEY (metalType, currency)
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS price_alerts (
        id TEXT PRIMARY KEY,
        metalType INTEGER NOT NULL,
        targetPrice REAL NOT NULL,
        isAbove INTEGER NOT NULL,
        isEnabled INTEGER NOT NULL DEFAULT 1,
        triggeredAt TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS price_history (
        id TEXT PRIMARY KEY,
        metalType INTEGER NOT NULL,
        pricePerTroyOz REAL NOT NULL,
        currency INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    _db.execute('''
      CREATE TABLE IF NOT EXISTS app_settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        defaultCurrency INTEGER NOT NULL DEFAULT 0,
        isDarkMode INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Insert default settings if empty
    final result = _db.select('SELECT COUNT(*) as count FROM app_settings');
    if (result.first['count'] == 0) {
      _db.execute(
        'INSERT INTO app_settings (defaultCurrency, isDarkMode) VALUES (?, ?)',
        [CurrencyCode.gbp.index, 0],
      );
    }
  }

  void dispose() {
    _holdingsController.close();
    _pricesController.close();
    _alertsController.close();
    _settingsController.close();
    _db.dispose();
  }
}
