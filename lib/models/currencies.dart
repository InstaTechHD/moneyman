import 'package:moor/moor.dart';

@DataClassName('Currency')
class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  // ISO 4217 unless it's a custom currency
  TextColumn get code =>
      text().customConstraint('NOT NULL UNIQUE').withLength(min: 3, max: 3)();
  TextColumn get symbol => text()();
  IntColumn get multiplier => integer()();
  BoolColumn get symbolBefore => boolean()();
}
