import 'package:moor/moor.dart';

import '../database.dart';

part 'accounts.g.dart';

@UseDao(tables: [Accounts, Currency, Transactions], include: {'accounts.moor'})
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(AppDatabase db) : super(db);

  Future<List<AccountBundle>> getAllAccounts() async {
    final data = await accountBundles(const Constant(true)).get();
    return data
        .map((ad) => AccountBundle(
              account: ad.accounts,
              currency: ad.currencies,
              balance: ad.balance,
            ))
        .toList();
  }

  Future<Account> getAccount(int id) =>
      (select(accounts)..where((a) => a.id.equals(id))).getSingle();

  Future<int> getBalance(Account account) async {
    final data = await accountBundles(
      accounts.id.equals(account.id),
    ).getSingle();
    return data.balance;
  }

  Future<int> insertAccount(Account account) => into(accounts).insert(account);
  Future<bool> updateAccount(Account account) =>
      update(accounts).replace(account);
  Future deleteAccount(Account account) => delete(accounts).delete(account);
}
