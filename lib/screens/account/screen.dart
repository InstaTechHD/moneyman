import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

import '../../database.dart';
import '../../services/currencies.dart';
import '../../services/transactions.dart';
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

    Widget body;
    if (transactions.connectionState != ConnectionState.done ||
        transactions.hasError ||
        currency.connectionState != ConnectionState.done ||
        currency.hasError) {
      body = Container();
    } else {
      final transactionsByDate = groupBy(transactions.data, (TXN t) => t.date);
      final dates = transactionsByDate.keys.toList()..sort();

      body = InfiniteList(
        maxChildCount: dates.length,
        builder: (BuildContext context, int index) {
          return InfiniteListItem(
            minOffsetProvider: (StickyState<int> state) => dateHeaderHeight,
            headerBuilder: (context) => _buildDateHeader(
              context,
              dateHeaderHeight,
              dates[index],
            ),
            contentBuilder: (context) => _buildTransactionsList(
              context,
              dateHeaderHeight,
              currency.data,
              transactionsByDate[dates[index]],
            ),
          );
        },
      );
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
    List<TXN> transactions,
  ) {
    final children = <Widget>[];
    for (var i = 0; i < transactions.length; i++) {
      children.add(TransactionListItem(
        transaction: transactions[i],
        currency: currency,
      ));

      // Don't add divider after the last item
      if (i != transactions.length - 1) children.add(const Divider(height: 1));
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
