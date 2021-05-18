import 'package:flutter/material.dart';

import '../../../database.dart';

class AccountBalance extends StatelessWidget {
  final int accountBalance;
  final Currency currency;

  const AccountBalance({
    Key key,
    required this.accountBalance,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(ctx).primaryColor,
        border: Border(
          top: BorderSide(width: 2, color: Theme.of(ctx).dividerColor),
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total:'),
            Text(currency.formatAmount(accountBalance)),
          ],
        ),
      ),
    );
  }
}
