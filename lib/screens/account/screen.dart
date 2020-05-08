import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../database.dart';

class AccountScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Account account =
        ModalRoute.of(context).settings.arguments as Account;

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
      ),
      body: ListView(children: const [
        Text('Transaction 1'),
        Text('Transaction 2'),
        Text('Transaction 3'),
      ]),
    );
  }
}
