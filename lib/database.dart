import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:xdg_directories/xdg_directories.dart' as xdg;

part 'database.g.dart';
part 'models/accounts.dart';
part 'models/categories.dart';
part 'models/currencies.dart';
part 'models/payees.dart';
part 'models/transactions.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    Directory dbFolder;
    if (Platform.isLinux) {
      // Since path_provider doesn't currently support Linux, figure it out here
      dbFolder = Directory(p.join(xdg.dataHome.path, 'moneyman'));
      if (!await dbFolder.exists()) await dbFolder.create();
    } else {
      dbFolder = await getApplicationDocumentsDirectory();
    }

    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file, logStatements: true);
  });
}

@UseMoor(tables: [
  Accounts,
  Categories,
  Currencies,
  Payees,
  Transactions,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON;');
        },
        onCreate: (details) async {
          await details.createAll();
          await _insertInitialData();
          await _insertDummyData();
        },
      );

  Future _insertInitialData() async {
    await batch((batch) {
      batch.insertAll(currencies, [
        Currency(
          id: 1,
          code: 'USD',
          symbol: '\$',
          multiplier: 100,
          symbolBefore: true,
        ),
        Currency(
          id: 2,
          code: 'EUR',
          symbol: '€',
          multiplier: 100,
          symbolBefore: true,
        ),
        Currency(
          id: 3,
          code: 'SEK',
          symbol: 'kr',
          multiplier: 100,
          symbolBefore: false,
        )
      ]);
    });
  }

  Future _insertDummyData() async {
    await batch((batch) {
      batch.insertAll(accounts, [
        Account(
          id: 1,
          name: 'Main',
          typeId: 1,
          currencyId: 1,
        ),
        Account(
          id: 2,
          name: 'Savings',
          typeId: 1,
          currencyId: 2,
        ),
        Account(
          id: 3,
          name: 'Wallet',
          typeId: 1,
          currencyId: 3,
        )
      ]);

      batch.insertAll(payees, [
        Payee(id: 1, name: 'Grocery Store'),
        Payee(id: 2, name: 'Employer'),
      ]);

      batch.insertAll(categories, [
        Category(id: 1, typeId: 1, name: 'Food'),
        Category(id: 2, typeId: 1, name: 'Wages'),
      ]);

      // Main account
      batch.insertAll(transactions, [
        TransactionsCompanion.insert(
          accountId: 1,
          typeId: 1,
          date: DateTime(2020, 3, 4),
          statusId: 1,
          payeeId: const Value(2),
          categoryId: 2,
          amount: 3750,
          notes: const Value('Overtime work'),
        ),
        TransactionsCompanion.insert(
          accountId: 1,
          typeId: 1,
          date: DateTime(2020, 3, 4),
          statusId: 1,
          payeeId: const Value(1),
          categoryId: 1,
          amount: -2493,
          notes: const Value('Vegetables and chicken'),
        ),
        TransactionsCompanion.insert(
          accountId: 1,
          typeId: 1,
          date: DateTime(2020, 3, 18),
          statusId: 1,
          payeeId: const Value(2),
          categoryId: 2,
          amount: 50900,
        ),
        TransactionsCompanion.insert(
          accountId: 1,
          typeId: 1,
          date: DateTime(2020, 4, 2),
          statusId: 1,
          payeeId: const Value(1),
          categoryId: 1,
          amount: -5902,
        ),
        TransactionsCompanion.insert(
          accountId: 1,
          typeId: 1,
          date: DateTime(2020, 4, 2),
          statusId: 1,
          payeeId: const Value(1),
          categoryId: 1,
          amount: -902,
          notes: const Value('Weekend snacks'),
        ),
        TransactionsCompanion.insert(
          accountId: 1,
          typeId: 1,
          date: DateTime(2020, 4, 9),
          statusId: 1,
          payeeId: const Value(1),
          categoryId: 1,
          amount: -1922,
        ),
      ]);
    });
  }
}
