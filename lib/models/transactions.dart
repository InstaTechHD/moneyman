part of '../database.dart';

@DataClassName('TXN')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().customConstraint('NOT NULL REFERENCES accounts(id)')();
  DateTimeColumn get date => dateTime()();
  BoolColumn get transfer => boolean().withDefault(const Constant(false))();
  IntColumn get status => intEnum<TransactionStatus>()();
  IntColumn get payeeId =>
      integer().nullable().customConstraint('NULL REFERENCES payee(id)')();
  IntColumn get categoryId =>
      integer().customConstraint('NOT NULL REFERENCES category(id)')();
  IntColumn get amount => integer()();
  TextColumn get notes => text().nullable()();
  BoolColumn get split => boolean().withDefault(const Constant(false))();
  IntColumn get parentId => integer()
      .nullable()
      .customConstraint('NULL REFERENCES transactions(id)')();
}

class TXNBundle {
  final TXN transaction;
  final Category category;
  final Payee payee;

  TXNBundle({required this.transaction, this.category, this.payee});
}

enum TransactionStatus {
  unreconciled,
  cleared,
  reconciled,
}

extension TransactionStatusValues on TransactionStatus {
  static String _value(TransactionStatus ts) {
    switch (ts) {
      case TransactionStatus.unreconciled:
        return 'Unreconciled';
      case TransactionStatus.cleared:
        return 'Cleared';
      case TransactionStatus.reconciled:
        return 'Reconciled';
    }

    return '';
  }

  String get value => _value(this);
}
