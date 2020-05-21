import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

import '../../database.dart';
import '../../services/accounts.dart';
import '../../services/currencies.dart';
import '../../services/transactions.dart';
import 'components/account_balance.dart';
import 'components/transaction_list_item.dart';

class AccountScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Account account =
        ModalRoute.of(context).settings.arguments as Account;

    final fetches = useFuture(useMemoized(
      () => Future.wait([
        Provider.of<AccountsService>(context).getBalance(account),
        Provider.of<CurrenciesService>(context).getCurrency(account.currencyId),
        Provider.of<TransactionsService>(context).getTransactions(account),
      ], eagerError: true),
    ));

    Widget body;
    if (fetches.connectionState == ConnectionState.waiting) {
      body = const Text('Loading...');
    } else if (fetches.hasError) {
      body = Text(fetches.error.toString());
    } else {
      final accountBalance = fetches.data[0] as int;
      final currency = fetches.data[1] as Currency;
      final transactions = fetches.data[2] as List<TXNBundle>;

      // Wrap each transaction with the running balance
      int runningBalance = accountBalance;

      final txnsWithRB = transactions.map((TXNBundle tb) {
        final txn = TXNBundleWithRB(tb, runningBalance);
        runningBalance -= tb.transaction.amount;
        return txn;
      });

      final transactionsByDate = groupBy(
        txnsWithRB,
        (TXNBundleWithRB t) => t.txnBundle.transaction.date,
      );

      body = _buildBody(
        context,
        currency,
        accountBalance,
        transactionsByDate,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
      ),
      body: body,
    );
  }

  Widget _buildBody(
    BuildContext ctx,
    Currency currency,
    int accountBalance,
    Map<DateTime, List<TXNBundleWithRB>> transactionsByDate,
  ) {
    final dateHeaderHeight = 20.0 * MediaQuery.textScaleFactorOf(ctx);
    final dates = transactionsByDate.keys.toList();

    return Column(children: [
      // This list will be in reverse mode,
      // i.e. start at the bottom and scroll up
      Flexible(
        child: InfiniteList(
          anchor: 1,
          direction: InfiniteListDirection.multi,
          minChildCount: dates.length * -1,
          maxChildCount: 0,
          builder: (BuildContext context, int index) {
            final date = dates[(index * -1) - 1];

            return InfiniteListItem(
              minOffsetProvider: (StickyState<int> state) => dateHeaderHeight,
              headerBuilder: (context) => _buildDateHeader(
                context,
                dateHeaderHeight,
                date,
              ),
              contentBuilder: (context) => _buildTransactionsList(
                context,
                dateHeaderHeight,
                currency,
                transactionsByDate[date],
              ),
            );
          },
        ),
      ),
      AccountBalance(
        accountBalance: accountBalance,
        currency: currency,
      ),
    ]);
  }

  Widget _buildTransactionsList(
    BuildContext context,
    double headerHeight,
    Currency currency,
    List<TXNBundleWithRB> transactions,
  ) {
    final children = <Widget>[];
    for (var i = transactions.length - 1; i >= 0; i--) {
      children.add(TransactionListItem(
        txnBundle: transactions[i].txnBundle,
        currency: currency,
        runningBalance: transactions[i].runningBalance,
      ));

      // Don't add divider after the last item
      if (i != 0) children.add(const Divider(height: 1));
    }

    return Padding(
      padding: EdgeInsets.only(top: headerHeight),
      child: Column(children: children),
    );
  }

  Widget _buildDateHeader(BuildContext context, double height, DateTime date) {
    return Container(
      // The height needs to be static to make sure the sticky headers
      // work/look like they should
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(top: 4, left: 4, right: 4, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 2, color: Theme.of(context).dividerColor),
        ),
      ),
      child: Text(
        DateFormat('EEEE, MMMM d, y').format(date).toUpperCase(),
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TXNBundleWithRB {
  TXNBundle txnBundle;
  int runningBalance;

  TXNBundleWithRB(this.txnBundle, this.runningBalance);
}
