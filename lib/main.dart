import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'daos/accounts.dart';
import 'daos/currencies.dart';
import 'daos/transactions.dart';
import 'database.dart';
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
          create: (_) => AccountsService(AccountDao(_db)),
        ),
        Provider<CurrenciesService>(
          create: (_) => CurrenciesService(CurrencyDao(_db)),
        ),
        Provider<TransactionsService>(
          create: (_) => TransactionsService(TransactionDao(_db)),
        ),
      ],
      child: MaterialApp(
        title: 'MoneyMan',
        initialRoute: '/',
        routes: routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
