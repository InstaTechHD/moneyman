import 'package:moor/moor.dart';

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get typeId => integer()();
  TextColumn get name => text().customConstraint('NOT NULL UNIQUE')();
  IntColumn get parentId =>
      integer().nullable().customConstraint('NULL REFERENCES categories(id)')();
}
