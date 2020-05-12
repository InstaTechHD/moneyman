part of '../database.dart';

class Payees extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().customConstraint('NOT NULL UNIQUE')();
}
