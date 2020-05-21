part of '../database.dart';

@DataClassName('TXN')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId =>
      integer().customConstraint('NOT NULL REFERENCES accounts(id)')();
  IntColumn get typeId => integer()();
  DateTimeColumn get date => dateTime()();
  IntColumn get statusId => integer()();
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

  TXNBundle({@required this.transaction, this.category, this.payee});
}
