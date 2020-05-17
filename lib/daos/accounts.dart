import 'package:moor/moor.dart';

import '../database.dart';

part 'accounts.g.dart';

@UseDao(tables: [Accounts, Transactions])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(AppDatabase db) : super(db);

  Future<List<Account>> getAllAccounts() => select(accounts).get();
  Future<Account> getAccount(int id) =>
      (select(accounts)..where((a) => a.id.equals(id))).getSingle();

  Future<int> getBalance(Account account) async {
    final startingBalance = (selectOnly(accounts)
          ..addColumns([accounts.startingBalance])
          ..where(accounts.id.equals(account.id)))
        .map((row) => row.read(accounts.startingBalance))
        .getSingle();

    final amountSum = transactions.amount.sum();
    final sum = (selectOnly(transactions)
          ..addColumns([amountSum])
          ..where(transactions.accountId.equals(account.id)))
        .map((row) => row.read(amountSum))
        .getSingle();

    return (await Future.wait([startingBalance, sum])).reduce(
      (a, b) => a + (b ?? 0),
    );
  }

  Future<int> insertAccount(Account account) => into(accounts).insert(account);
  Future<bool> updateAccount(Account account) =>
      update(accounts).replace(account);
  Future deleteAccount(Account account) => delete(accounts).delete(account);
}
