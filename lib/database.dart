import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
          await _insertDemoData();
        },
      );

  Future _insertInitialData() async {
    final initialData = json.decode(
      await rootBundle.loadString('assets/data/initial.json'),
    );
    final initialCurrencies = initialData['currencies']
        .map<Currency>((c) => Currency.fromJson(c as Map<String, dynamic>))
        .toList() as List<Insertable<Currency>>;
    final initialCategories = initialData['categories']
        .map<Category>((c) => Category.fromJson(c as Map<String, dynamic>))
        .toList() as List<Insertable<Category>>;

    await batch((batch) {
      batch.insertAll(currencies, initialCurrencies);
      batch.insertAll(categories, initialCategories);
    });
  }

  Future _insertDemoData() async {
    final demoData = json.decode(
      await rootBundle.loadString('assets/data/demo.json'),
    );
    final demoAccounts = demoData['accounts']
        .map<Account>((c) => Account.fromJson(c as Map<String, dynamic>))
        .toList() as List<Insertable<Account>>;

    final demoPayees = demoData['payees']
        .map<Payee>((c) => Payee.fromJson(c as Map<String, dynamic>))
        .toList() as List<Insertable<Payee>>;

    final demoTransactions = demoData['transactions']
        .map<TXN>((c) => TXN.fromJson(c as Map<String, dynamic>))
        .toList() as List<Insertable<TXN>>;

    await batch((batch) {
      batch.insertAll(accounts, demoAccounts);
      batch.insertAll(payees, demoPayees);
      batch.insertAll(transactions, demoTransactions);
    });
  }
}
