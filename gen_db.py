import os

files = {}

files['lib/data/database/tables/holdings_table.dart'] = '''import 'package:drift/drift.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/entities/weight_unit.dart';

class Holdings extends Table {
  TextColumn get id => text()();
  IntColumn get metalType => intEnum<MetalType>()();
  TextColumn get productName => text()();
  DateTimeColumn get purchaseDate => dateTime()();
  TextColumn get dealer => text()();
  RealColumn get weightInGrams => real()();
  IntColumn get weightUnit => intEnum<WeightUnit>()();
  RealColumn get displayQuantity => real()();
  RealColumn get purity => real()();
  RealColumn get purchasePrice => real()();
  RealColumn get premiumPaid => real()();
  RealColumn get shippingCost => real()();
  RealColumn get fees => real()();
  RealColumn get totalCost => real()();
  TextColumn get notes => text().nullable()();
  TextColumn get receiptPhotoPath => text().nullable()();
  BoolColumn get isSold => boolean().withDefault(const Constant(false))();
  DateTimeColumn get soldDate => dateTime().nullable()();
  RealColumn get soldPrice => real().nullable()();
  RealColumn get soldQuantityGrams => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
'''

files['lib/data/database/tables/metal_prices_table.dart'] = '''import 'package:drift/drift.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/entities/currency_code.dart';

class MetalPrices extends Table {
  IntColumn get metalType => intEnum<MetalType>()();
  RealColumn get pricePerTroyOz => real()();
  IntColumn get currency => intEnum<CurrencyCode>()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get changePercent24h => real()();
  RealColumn get changeAmount24h => real()();

  @override
  Set<Column> get primaryKey => {metalType, currency};
}
'''

files['lib/data/database/tables/price_alerts_table.dart'] = '''import 'package:drift/drift.dart';
import '../../domain/entities/metal_type.dart';

class PriceAlerts extends Table {
  TextColumn get id => text()();
  IntColumn get metalType => intEnum<MetalType>()();
  RealColumn get targetPrice => real()();
  BoolColumn get isAbove => boolean()();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get triggeredAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
'''

files['lib/data/database/tables/price_history_table.dart'] = '''import 'package:drift/drift.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/entities/currency_code.dart';

class PriceHistory extends Table {
  IntColumn get metalType => intEnum<MetalType>()();
  RealColumn get pricePerTroyOz => real()();
  IntColumn get currency => intEnum<CurrencyCode>()();
  DateTimeColumn get timestamp => dateTime()();

  @override
  Set<Column> get primaryKey => {metalType, currency, timestamp};
}
'''

files['lib/data/database/tables/app_settings_table.dart'] = '''import 'package:drift/drift.dart';
import '../../domain/entities/currency_code.dart';

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get defaultCurrency => intEnum<CurrencyCode>().withDefault(const Constant(0))();
  BoolColumn get isDarkMode => boolean().withDefault(const Constant(false))();
}
'''

files['lib/data/database/app_database.dart'] = '''import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../domain/entities/metal_type.dart';
import '../../domain/entities/weight_unit.dart';
import '../../domain/entities/currency_code.dart';
import 'tables/holdings_table.dart';
import 'tables/metal_prices_table.dart';
import 'tables/price_alerts_table.dart';
import 'tables/price_history_table.dart';
import 'tables/app_settings_table.dart';
import 'daos/holdings_dao.dart';
import 'daos/prices_dao.dart';
import 'daos/alerts_dao.dart';
import 'daos/settings_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Holdings, MetalPrices, PriceAlerts, PriceHistory, AppSettings],
  daos: [HoldingsDao, PricesDao, AlertsDao, SettingsDao],
)
class AppDatabase extends _\$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        // Insert default settings
        await into(appSettings).insert(
          AppSettingsCompanion.insert(
            defaultCurrency: const Value(CurrencyCode.gbp),
            isDarkMode: const Value(false),
          ),
        );
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'bullion_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
'''

files['lib/data/database/daos/holdings_dao.dart'] = '''import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/holdings_table.dart';

part 'holdings_dao.g.dart';

@DriftAccessor(tables: [Holdings])
class HoldingsDao extends DatabaseAccessor<AppDatabase> with _\$HoldingsDaoMixin {
  HoldingsDao(AppDatabase db) : super(db);

  Future<List<HoldingData>> getAllHoldings() => select(holdings).get();
  
  Stream<List<HoldingData>> watchAllHoldings() => select(holdings).watch();

  Future<HoldingData> getHoldingById(String id) {
    return (select(holdings)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> insertHolding(HoldingData holding) => into(holdings).insert(holding);

  Future<void> updateHolding(HoldingData holding) => update(holdings).replace(holding);

  Future<void> deleteHolding(String id) {
    return (delete(holdings)..where((t) => t.id.equals(id))).go();
  }
}
'''

files['lib/data/database/daos/prices_dao.dart'] = '''import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/metal_prices_table.dart';
import '../tables/price_history_table.dart';
import '../../domain/entities/metal_type.dart';
import '../../domain/entities/currency_code.dart';

part 'prices_dao.g.dart';

@DriftAccessor(tables: [MetalPrices, PriceHistory])
class PricesDao extends DatabaseAccessor<AppDatabase> with _\$PricesDaoMixin {
  PricesDao(AppDatabase db) : super(db);

  Future<List<MetalPriceData>> getAllPrices() => select(metalPrices).get();

  Stream<List<MetalPriceData>> watchAllPrices() => select(metalPrices).watch();

  Future<MetalPriceData?> getLatestPrice(MetalType metal, CurrencyCode currency) {
    return (select(metalPrices)
          ..where((t) => t.metalType.equals(metal.index))
          ..where((t) => t.currency.equals(currency.index)))
        .getSingleOrNull();
  }

  Future<void> insertOrUpdatePrice(MetalPriceData price) {
    return into(metalPrices).insertOnConflictUpdate(price);
  }

  Future<void> insertPriceHistory(List<PriceHistoryData> history) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(priceHistory, history);
    });
  }

  Future<List<PriceHistoryData>> getHistory(MetalType metal, CurrencyCode currency, int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return (select(priceHistory)
          ..where((t) => t.metalType.equals(metal.index))
          ..where((t) => t.currency.equals(currency.index))
          ..where((t) => t.timestamp.isBiggerOrEqualValue(cutoff))
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.asc)]))
        .get();
  }
}
'''

files['lib/data/database/daos/alerts_dao.dart'] = '''import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/price_alerts_table.dart';

part 'alerts_dao.g.dart';

@DriftAccessor(tables: [PriceAlerts])
class AlertsDao extends DatabaseAccessor<AppDatabase> with _\$AlertsDaoMixin {
  AlertsDao(AppDatabase db) : super(db);

  Stream<List<PriceAlertData>> watchAllAlerts() => select(priceAlerts).watch();
  
  Future<List<PriceAlertData>> getAllAlerts() => select(priceAlerts).get();

  Future<void> insertAlert(PriceAlertData alert) => into(priceAlerts).insert(alert);

  Future<void> updateAlert(PriceAlertData alert) => update(priceAlerts).replace(alert);

  Future<void> deleteAlert(String id) {
    return (delete(priceAlerts)..where((t) => t.id.equals(id))).go();
  }
}
'''

files['lib/data/database/daos/settings_dao.dart'] = '''import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/app_settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _\$SettingsDaoMixin {
  SettingsDao(AppDatabase db) : super(db);

  Future<AppSettingData> getSettings() async {
    final settings = await select(appSettings).getSingleOrNull();
    if (settings != null) return settings;
    
    final defaultSettings = AppSettingsCompanion.insert();
    final id = await into(appSettings).insert(defaultSettings);
    return (select(appSettings)..where((t) => t.id.equals(id))).getSingle();
  }

  Stream<AppSettingData> watchSettings() {
    return select(appSettings).watchSingle();
  }

  Future<void> updateSettings(AppSettingData settings) {
    return update(appSettings).replace(settings);
  }
}
'''

for path, content in files.items():
    with open(f'/Volumes/SSD/MetalTracker/{path}', 'w') as f:
        f.write(content)
print("Database generated successfully.")
