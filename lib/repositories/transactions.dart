import 'package:flutter/foundation.dart';

import '../database.dart';

abstract class TransactionsRepository {
  Future<TXN> getTransaction(int id);
  Future<List<TXNBundle>> getAll(int accountId);

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
  });
}
