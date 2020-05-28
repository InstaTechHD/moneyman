import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../database.dart';
import '../../hooks/memoized_future.dart';
import '../../services/accounts.dart';
import 'components/account_list_item.dart';

class AccountsScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final fetch = useMemoizedFuture(
      () => Provider.of<AccountsService>(context).getAccounts(),
    );

    Widget body;
    if (fetch.snapshot.connectionState == ConnectionState.waiting) {
      body = const Text('Loading...');
    } else if (fetch.snapshot.hasError) {
      body = Text(fetch.snapshot.error.toString());
    } else {
      body = ListView.builder(
        itemCount: fetch.snapshot.data.length,
        itemBuilder: (ctx, i) {
          return _buildAccountRow(context, fetch.snapshot.data[i], () async {
            await Navigator.pushNamed(
              context,
              '/account',
              arguments: fetch.snapshot.data[i].account,
            );
            fetch.refresh();
          });
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

  Widget _buildAccountRow(
      BuildContext context, AccountBundle ab, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: AccountListItem(
        account: ab.account,
        balance: ab.currency.formatAmount(ab.balance),
      ),
    );
  }
}
