import 'package:moor/moor.dart';

@DataClassName('TXN')
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountID =>
      integer().customConstraint('NOT NULL REFERENCES accounts(id)')();
  IntColumn get typeID => integer()();
  DateTimeColumn get date => dateTime()();
  IntColumn get statusID => integer()();
  IntColumn get payeeID =>
      integer().nullable().customConstraint('NULL REFERENCES payee(id)')();
  IntColumn get categoryID =>
      integer().customConstraint('NOT NULL REFERENCES category(id)')();
  IntColumn get amount => integer()();
  TextColumn get notes => text().nullable()();
  BoolColumn get split => boolean().withDefault(const Constant(false))();
  IntColumn get parentID => integer()
      .nullable()
      .customConstraint('NULL REFERENCES transactions(id)')();
}
