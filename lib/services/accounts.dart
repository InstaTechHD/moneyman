import 'package:flutter/foundation.dart';

import '../database.dart';
import '../repositories/accounts.dart';

class AccountsService {
  final AccountsRepository repo;

  /// Initializes the service with [repo] as its repository.
  AccountsService(this.repo);

  Future<Account> getAccount(int id) => repo.getAccount(id);
  Future<List<AccountBundle>> getAccounts() => repo.getAll();
  Future<int> createAccount({
    @required String name,
    @required AccountType type,
    @required int currencyId,
    int startingBalance,
  }) =>
      repo.createAccount(
          name: name,
          typeId: type.index,
          currencyId: currencyId,
          startingBalance: startingBalance);
  Future<int> getBalance(Account account) => repo.getBalance(account);
}
