import 'package:flutter/foundation.dart';

import '../database.dart';
import '../repositories/currencies.dart';

class CurrenciesService {
  final CurrenciesRepository repo;

  /// Initializes the service with [repo] as its repository.
  CurrenciesService(this.repo);

  Future<Currency> getCurrency(int id) => repo.getCurrency(id);
  Future<List<Currency>> getCurrencies() => repo.getAll();
  Future<int> createCurrency(
          {@required String code,
          @required String symbol,
          @required int numDecimals,
          @required bool symbolBefore,
          @required bool custom}) =>
      repo.createCurrency(
          code: code,
          symbol: symbol,
          numDecimals: numDecimals,
          symbolBefore: symbolBefore,
          custom: custom);
}
