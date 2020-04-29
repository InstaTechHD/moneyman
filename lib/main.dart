import 'package:flutter/material.dart';
import 'package:moneyman/routes.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyMan',
      initialRoute: '/',
      routes: routes,
    );
  }
}
