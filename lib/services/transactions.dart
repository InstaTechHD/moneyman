import '../database.dart';
import '../repositories/transactions.dart';

class TransactionsService {
  final TransactionsRepository repo;

  /// Initializes the service with [repo] as its repository.
  TransactionsService(this.repo);

  Future<TXN> getTransaction(int id) => repo.get(id);
  Future<List<TXN>> getTransactions() => repo.getAll();
  Future addTransaction(TXN transaction) => repo.create(transaction);
}
