import 'package:moneyman/repositories/accounts.dart';

import '../database.dart';

class AccountsService {
  final AccountsRepository repo;

  /// Initializes the service with [repo] as its repository.
  AccountsService(this.repo);

  Future<Account> getAccount(int id) => repo.get(id);
  Future<List<Account>> getAccounts() => repo.getAll();
  Future addAccount(Account account) => repo.create(account);
}
