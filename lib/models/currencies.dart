part of '../database.dart';

@DataClassName('Currency')
class Currencies extends Table {
  IntColumn get id => integer().autoIncrement()();
  // ISO 4217 unless it's a custom currency
  TextColumn get code =>
      text().customConstraint('NOT NULL UNIQUE').withLength(min: 3, max: 3)();
  TextColumn get symbol => text()();
  IntColumn get numDecimals => integer()();
  BoolColumn get symbolBefore => boolean()();
  BoolColumn get custom => boolean()();
}

extension ModelMethods on Currency {
  int amountDivisor() => pow(10, numDecimals).toInt();

  String formatAmount(int amount) {
    String customPattern = '#,##0.';
    customPattern += '0' * numDecimals;

    if (symbolBefore) {
      customPattern = '\u00A4$customPattern';
    } else {
      customPattern += '\u00A0\u00A4';
    }

    return NumberFormat.currency(
      symbol: symbol,
      customPattern: customPattern,
    ).format(amount / amountDivisor());
  }
}
