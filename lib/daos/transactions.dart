import 'package:moor/moor.dart';

import '../database.dart';
import '../models/transactions.dart';

part 'transactions.g.dart';

@UseDao(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(AppDatabase db) : super(db);

  Future<List<TXN>> getAllTransactions() => select(transactions).get();
  Future<TXN> getTransaction(int id) =>
      (select(transactions)..where((t) => t.id.equals(id))).getSingle();
  Future<int> insertTransaction(TXN transaction) =>
      into(transactions).insert(transaction);
  Future<bool> updateTransaction(TXN transaction) =>
      update(transactions).replace(transaction);
  Future deleteTransaction(TXN transaction) =>
      delete(transactions).delete(transaction);
}
