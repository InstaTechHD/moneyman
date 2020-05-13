import '../database.dart';
import '../repositories/currencies.dart';

class CurrenciesService {
  final CurrenciesRepository repo;

  /// Initializes the service with [repo] as its repository.
  CurrenciesService(this.repo);

  Future<Currency> getCurrency(int id) => repo.get(id);
  Future<List<Currency>> getCurrencies() => repo.getAll();
  Future addCurrency(Currency currency) => repo.create(currency);
}
