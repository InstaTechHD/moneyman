import '../database.dart';
import '../repositories/accounts.dart';

class AccountsService {
  final AccountsRepository repo;

  /// Initializes the service with [repo] as its repository.
  AccountsService(this.repo);

  Future<Account> getAccount(int id) => repo.get(id);
  Future<List<AccountBundle>> getAccounts() => repo.getAll();
  Future addAccount(Account account) => repo.create(account);
  Future<int> getBalance(Account account) => repo.getBalance(account);
}
