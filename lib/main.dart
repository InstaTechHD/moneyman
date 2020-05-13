import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database.dart';
import 'repositories/accounts.dart';
import 'repositories/currencies.dart';
import 'repositories/transactions.dart';
import 'routes.dart';
import 'services/accounts.dart';
import 'services/currencies.dart';
import 'services/transactions.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final _db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AccountsService>(
          create: (_) => AccountsService(AccountsLocalRepository(_db)),
        ),
        Provider<CurrenciesService>(
          create: (_) => CurrenciesService(CurrenciesLocalRepository(_db)),
        ),
        Provider<TransactionsService>(
          create: (_) => TransactionsService(TransactionsLocalRepository(_db)),
        ),
      ],
      child: MaterialApp(
        title: 'MoneyMan',
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
