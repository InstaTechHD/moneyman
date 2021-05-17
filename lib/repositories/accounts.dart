import 'package:flutter/foundation.dart';

import '../database.dart';

abstract class AccountsRepository {
  Future<Account> getAccount(int id);
  Future deleteAccount(int id);
  Future<List<AccountBundle>> getAll();
  Future<int> getBalance(Account account);
  Future<int> createAccount({
    @required String name,
    @required int typeId,
    @required int currencyId,
    int startingBalance,
  });
}
