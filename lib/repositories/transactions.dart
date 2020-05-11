import '../daos/transactions.dart';
import '../database.dart';
import 'repository.dart';

abstract class TransactionsRepository extends Repository<TXN, int> {
  Future<List<TXN>> getAll(int accountId);
}

class TransactionsLocalRepository implements TransactionsRepository {
  final TransactionDao dao;

  TransactionsLocalRepository(AppDatabase db) : dao = TransactionDao(db);

  @override
  Future<int> create(TXN transaction) => dao.insertTransaction(transaction);

  @override
  Future delete(TXN transaction) => dao.deleteTransaction(transaction);

  @override
  Future<TXN> get(int id) => dao.getTransaction(id);

  @override
  Future<List<TXN>> getAll(int accountId) => dao.getAllTransactions(accountId);

  @override
  Future update(TXN transaction) => dao.updateTransaction(transaction);
}
