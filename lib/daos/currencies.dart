import 'package:moneyman/repositories/currencies.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'currencies.g.dart';

@UseDao(tables: [Currencies])
class CurrencyDao extends DatabaseAccessor<AppDatabase>
    with _$CurrencyDaoMixin
    implements CurrenciesRepository {
  CurrencyDao(AppDatabase db) : super(db);

  @override
  Future<List<Currency>> getAll() => select(currencies).get();

  @override
  Future<Currency> getCurrency(int id) =>
      (select(currencies)..where((t) => t.id.equals(id))).getSingle();

  @override
  Future<int> createCurrency({
    required String code,
    required String symbol,
    required int numDecimals,
    required bool symbolBefore,
    required bool custom,
  }) =>
      into(currencies).insert(CurrenciesCompanion.insert(
          code: code,
          symbol: symbol,
          numDecimals: numDecimals,
          symbolBefore: symbolBefore,
          custom: custom));

  Future<bool> updateCurrency(Currency currency) =>
      update(currencies).replace(currency);

  @override
  Future deleteCurrency(int id) =>
      (delete(currencies)..where((c) => c.id.equals(id))).go();
}
