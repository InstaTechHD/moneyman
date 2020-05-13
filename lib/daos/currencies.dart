import 'package:moor/moor.dart';

import '../database.dart';

part 'currencies.g.dart';

@UseDao(tables: [Currencies])
class CurrencyDao extends DatabaseAccessor<AppDatabase>
    with _$CurrencyDaoMixin {
  CurrencyDao(AppDatabase db) : super(db);

  Future<List<Currency>> getAllCurrencies() => select(currencies).get();
  Future<Currency> getCurrency(int id) =>
      (select(currencies)..where((t) => t.id.equals(id))).getSingle();
  Future<int> insertCurrency(Currency currency) =>
      into(currencies).insert(currency);
  Future<bool> updateCurrency(Currency currency) =>
      update(currencies).replace(currency);
  Future deleteCurrency(Currency currency) =>
      delete(currencies).delete(currency);
}
