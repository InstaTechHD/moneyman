import 'package:moneyman/repositories/transactions.dart';
import 'package:moor/moor.dart';

import '../database.dart';

part 'transactions.g.dart';

@UseDao(tables: [Transactions, Categories, Payees])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin
    implements TransactionsRepository {
  TransactionDao(AppDatabase db) : super(db);

  @override
  Future<List<TXNBundle>> getAll(int accountId) async {
    dynamic expr = select(transactions)
      ..where((t) => t.accountId.equals(accountId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        (t) => OrderingTerm(expression: t.id, mode: OrderingMode.desc),
      ]);

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

  @override
  Future<TXN> getTransaction(int id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingle();

  @override
  Future<int> createTransaction({
    @required int accountId,
    @required int typeId,
    @required DateTime date,
    @required int statusId,
    int payeeId,
    @required int categoryId,
    @required int amount,
    String notes,
    bool split,
    int parentId,
  }) =>
      into(transactions).insert(TransactionsCompanion.insert(
          accountId: accountId,
          typeId: typeId,
          date: date,
          statusId: statusId,
          payeeId: Value(payeeId),
          categoryId: categoryId,
          amount: amount,
          notes: Value(notes),
          split: Value(split),
          parentId: Value(parentId)));

  Future<bool> updateTransaction(TXN transaction) =>
      update(transactions).replace(transaction);
  Future deleteTransaction(TXN transaction) =>
      delete(transactions).delete(transaction);
}
