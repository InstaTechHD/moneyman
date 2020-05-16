import 'package:moor/moor.dart';

import '../database.dart';

part 'transactions.g.dart';

@UseDao(tables: [Transactions, Categories, Payees])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Future<List<TXNBundle>> getAllTransactions(int accountId) async {
    dynamic expr = select(transactions)
      ..where((t) => t.accountId.equals(accountId));

    expr = expr.join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(transactions.categoryId),
      )
    ]);

    expr = expr.join([
      leftOuterJoin(
        payees,
        payees.id.equalsExp(transactions.payeeId),
      )
    ]);

    // Cast as the correct list type because the analyzer complains
    return (await expr.get()).map<TXNBundle>((row) {
      return TXNBundle(
        transaction: row.readTable(transactions) as TXN,
        category: row.readTable(categories) as Category,
        payee: row.readTable(payees) as Payee,
      );
    }).toList() as List<TXNBundle>;
  }

  Future<TXN> getTransaction(int id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingle();
  Future<int> insertTransaction(TXN transaction) =>
      into(transactions).insert(transaction);
  Future<bool> updateTransaction(TXN transaction) =>
      update(transactions).replace(transaction);
  Future deleteTransaction(TXN transaction) =>
      delete(transactions).delete(transaction);
}
