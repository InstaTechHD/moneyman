import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../database.dart';
import '../../services/accounts.dart';
import 'components/account_list_item.dart';

class AccountsScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final accounts = useFuture(useMemoized(
      () => Provider.of<AccountsService>(context).getAccounts(),
    ));

    Widget body;
    if (accounts.connectionState != ConnectionState.done || accounts.hasError) {
      body = Container();
    } else {
      body = ListView.builder(
        itemCount: accounts.data.length,
        itemBuilder: (ctx, i) {
          return _buildAccountRow(context, accounts.data[i]);
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: body,
    );
  }

  Widget _buildAccountRow(BuildContext context, AccountBundle ab) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/account',
        arguments: ab.account,
      ),
      child: AccountListItem(
        account: ab.account,
        balance: ab.currency.formatAmount(ab.balance),
      ),
    );
  }
}
