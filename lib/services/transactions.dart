import 'package:flutter/foundation.dart';

import '../database.dart';
import '../repositories/transactions.dart';

class TransactionsService {
  final TransactionsRepository repo;

  /// Initializes the service with [repo] as its repository.
  TransactionsService(this.repo);

  Future<TXN> getTransaction(int id) => repo.getTransaction(id);
  Future<List<TXNBundle>> getTransactions(Account account) =>
      repo.getAll(account.id);

  Future<int> createTransaction(
          {@required int accountId,
          @required int typeId,
          @required DateTime date,
          @required int statusId,
          int payeeId,
          @required int categoryId,
          @required int amount,
          String notes,
          bool split,
          int parentId}) =>
      repo.createTransaction(
          accountId: accountId,
          typeId: typeId,
          date: date,
          statusId: statusId,
          payeeId: payeeId,
          categoryId: categoryId,
          amount: amount,
          notes: notes,
          split: split,
          parentId: parentId);
}
