import 'package:moneyman/repositories/accounts.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'accounts.g.dart';

@UseDao(tables: [Accounts, Currency, Transactions], include: {'accounts.moor'})
class AccountDao extends DatabaseAccessor<AppDatabase>
    with _$AccountDaoMixin
    implements AccountsRepository {
  AccountDao(AppDatabase db) : super(db);

  @override
  Future<List<AccountBundle>> getAll() async {
    final data = await accountBundles(const Constant(true)).get();
    return data
        .map((ad) => AccountBundle(
              account: ad.accounts,
              currency: ad.currencies,
              balance: ad.balance,
            ))
        .toList();
  }

  @override
  Future<Account> getAccount(int id) =>
      (select(accounts)..where((a) => a.id.equals(id))).getSingle();

  @override
  Future<int> getBalance(Account account) async {
    final data = await accountBundles(
      accounts.id.equals(account.id),
    ).getSingle();
    return data.balance;
  }

  @override
  Future<int> createAccount({
    @required String name,
    @required int typeId,
    @required int currencyId,
    int startingBalance,
  }) =>
      into(accounts).insert(AccountsCompanion.insert(
          name: name,
          typeId: typeId,
          currencyId: currencyId,
          startingBalance: Value(startingBalance)));

  Future<bool> updateAccount(AccountsCompanion account) =>
      update(accounts).replace(account);

  @override
  Future deleteAccount(int id) =>
      (delete(accounts)..where((a) => a.id.equals(id))).go();
}
