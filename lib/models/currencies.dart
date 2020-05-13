part of '../database.dart';

@DataClassName('Currency')
class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  // ISO 4217 unless it's a custom currency
  TextColumn get code =>
      text().customConstraint('NOT NULL UNIQUE').withLength(min: 3, max: 3)();
  TextColumn get symbol => text()();
  IntColumn get divisor => integer()();
  BoolColumn get symbolBefore => boolean()();
  BoolColumn get custom => boolean()();
}

extension ModelMethods on Currency {
  String formatAmount(int amount) {
    return NumberFormat.simpleCurrency(name: code).format(amount / divisor);
  }
}
