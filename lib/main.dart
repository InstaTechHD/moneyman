import 'package:flutter/material.dart';
import 'package:moneyman/routes.dart';
import 'package:provider/provider.dart';

import 'database.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => AppDatabase(),
        child: MaterialApp(
          title: 'MoneyMan',
          initialRoute: '/',
          routes: routes,
        ));
  }
}
