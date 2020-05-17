import 'package:moor/moor.dart';

import '../database.dart';

part 'accounts.g.dart';

@UseDao(tables: [Accounts, Transactions])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(AppDatabase db) : super(db);

  Future<List<Account>> getAllAccounts() => select(accounts).get();
  Future<Account> getAccount(int id) =>
      (select(accounts)..where((a) => a.id.equals(id))).getSingle();

  Future<int> getBalance(Account account) {
    final amountSum = transactions.amount.sum();
    final query = selectOnly(transactions)
      ..addColumns([amountSum])
      ..where(transactions.accountId.equals(account.id));

    return query.map((row) => row.read(amountSum)).getSingle();
  }

  Future<int> insertAccount(Account account) => into(accounts).insert(account);
  Future<bool> updateAccount(Account account) =>
      update(accounts).replace(account);
  Future deleteAccount(Account account) => delete(accounts).delete(account);
}
