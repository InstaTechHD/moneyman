import 'package:moor/moor.dart';

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get typeID => integer()();
  TextColumn get name => text().customConstraint('NOT NULL UNIQUE')();
  IntColumn get parentID =>
      integer().nullable().customConstraint('NULL REFERENCES categories(id)')();
}
