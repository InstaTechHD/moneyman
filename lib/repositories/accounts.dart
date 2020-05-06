import '../daos/accounts.dart';
import '../database.dart';
import 'repository.dart';

abstract class AccountsRepository extends Repository<Account, int> {}

class AccountsLocalRepository implements AccountsRepository {
  final AccountDao dao;

  AccountsLocalRepository(AppDatabase db) : dao = AccountDao(db);

  @override
  Future<int> create(Account account) => dao.insertAccount(account);

  @override
  Future delete(Account account) => dao.deleteAccount(account);

  @override
  Future<Account> get(int id) => dao.getAccount(id);

  @override
  Future<List<Account>> getAll() => dao.getAllAccounts();

  @override
  Future update(Account account) => dao.updateAccount(account);
}
