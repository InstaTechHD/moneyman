import '../daos/currencies.dart';
import '../database.dart';
import 'repository.dart';

abstract class CurrenciesRepository extends Repository<Currency, int> {
  Future<List<Currency>> getAll();
}

class CurrenciesLocalRepository implements CurrenciesRepository {
  final CurrencyDao dao;

  CurrenciesLocalRepository(AppDatabase db) : dao = CurrencyDao(db);

  @override
  Future<int> create(Currency currency) => dao.insertCurrency(currency);

  @override
  Future delete(Currency currency) => dao.deleteCurrency(currency);

  @override
  Future<Currency> get(int id) => dao.getCurrency(id);

  @override
  Future<List<Currency>> getAll() => dao.getAllCurrencies();

  @override
  Future update(Currency currency) => dao.updateCurrency(currency);
}
