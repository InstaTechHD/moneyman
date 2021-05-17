import 'package:flutter/foundation.dart';

import '../database.dart';

abstract class CurrenciesRepository {
  Future<Currency> getCurrency(int id);
  Future<List<Currency>> getAll();
  Future deleteCurrency(int id);
  Future<int> createCurrency(
      {@required String code,
      @required String symbol,
      @required int numDecimals,
      @required bool symbolBefore,
      @required bool custom});
}
