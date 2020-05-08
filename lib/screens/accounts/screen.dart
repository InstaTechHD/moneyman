import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../database.dart';
import 'components/account_list_item.dart';

class AccountsScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final accounts = useState<List<Account>>([
      Account(id: 1, name: 'Account 1', typeID: 1),
      Account(id: 2, name: 'Account 2', typeID: 1),
      Account(id: 3, name: 'Account 3', typeID: 1),
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: ListView.builder(
        itemCount: accounts.value.length,
        itemBuilder: (ctx, i) {
          return _buildAccountRow(context, accounts.value[i]);
        },
      ),
    );
  }

  Widget _buildAccountRow(BuildContext context, Account account) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/account', arguments: account),
      child: AccountListItem(account: account, balance: '\$ 1270.39'),
    );
  }
}
