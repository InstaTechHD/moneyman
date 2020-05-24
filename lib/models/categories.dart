part of '../database.dart';

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<CategoryType>()();
  TextColumn get name => text().customConstraint('NOT NULL UNIQUE')();
  IntColumn get parentId =>
      integer().nullable().customConstraint('NULL REFERENCES categories(id)')();
}

enum CategoryType {
  expense,
  income,
}

extension CategoryTypeValues on CategoryType {
  static String _value(CategoryType ct) {
    switch (ct) {
      case CategoryType.expense:
        return 'Expense';
      case CategoryType.income:
        return 'Income';
    }

    return '';
  }

  String get value => _value(this);
}
