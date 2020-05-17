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
    final dateHeaderHeight = 20.0 * MediaQuery.textScaleFactorOf(context);

    final Account account =
        ModalRoute.of(context).settings.arguments as Account;
    final transactions = useFuture(useMemoized(
      () => Provider.of<TransactionsService>(context).getTransactions(account),
    ));
    final currency = useFuture(useMemoized(
      () => Provider.of<CurrenciesService>(context)
          .getCurrency(account.currencyId),
    ));
    final accountBalance = useFuture(useMemoized(
      () => Provider.of<AccountsService>(context).getBalance(account),
    ));

    Widget body;
    if (transactions.connectionState != ConnectionState.done ||
        transactions.hasError ||
        currency.connectionState != ConnectionState.done ||
        currency.hasError ||
        accountBalance.connectionState != ConnectionState.done ||
        accountBalance.hasError) {
      body = Container();
    } else {
      // Wrap each transaction with the running balance
      int runningBalance = accountBalance.data;

      final txnsWithRB = transactions.data.map((TXNBundle tb) {
        final txn = TXNBundleWithRB(tb, runningBalance);
        runningBalance -= tb.transaction.amount;
        return txn;
      });

      final transactionsByDate = groupBy(
        txnsWithRB,
        (TXNBundleWithRB t) => t.txnBundle.transaction.date,
      );

      final dates = transactionsByDate.keys.toList();

      body = Column(children: [
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
                  currency.data,
                  transactionsByDate[date],
                ),
              );
            },
          ),
        ),
        AccountBalance(
          accountBalance: accountBalance.data,
          currency: currency.data,
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
      ),
      body: body,
    );
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
