import 'package:moor/moor.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 30)();
  IntColumn get typeId => integer()();
  IntColumn get currencyId =>
      integer().customConstraint('NOT NULL REFERENCES currencies(id)')();
}
