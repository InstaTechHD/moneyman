import 'package:moor/moor.dart';

import '../database.dart';

part 'accounts.g.dart';

@UseDao(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(AppDatabase db) : super(db);

  Future<List<Account>> getAllAccounts() => select(accounts).get();
  Future<Account> getAccount(int id) =>
      (select(accounts)..where((a) => a.id.equals(id))).getSingle();
  Future<int> insertAccount(Account account) => into(accounts).insert(account);
  Future<bool> updateAccount(Account account) =>
      update(accounts).replace(account);
  Future deleteAccount(Account account) => delete(accounts).delete(account);
}
