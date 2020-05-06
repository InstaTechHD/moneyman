import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'database.dart';
import 'repositories/accounts.dart';
import 'routes.dart';
import 'services/accounts.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final _db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AccountsService>(
          create: (_) => AccountsService(AccountsLocalRepository(_db)),
        )
      ],
      child: MaterialApp(
        title: 'MoneyMan',
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
