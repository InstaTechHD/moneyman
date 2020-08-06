import 'package:flutter/material.dart';

import '../../../database.dart';

class TransactionListItem extends StatelessWidget {
  final TXNBundle txnBundle;
  final Currency currency;
  final int runningBalance;

  const TransactionListItem({
    Key key,
    @required this.txnBundle,
    @required this.currency,
    @required this.runningBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(txnBundle.payee.name),
              Text(
                txnBundle.category.name,
                style: const TextStyle(fontSize: 12),
              ),
              if (txnBundle.transaction.notes != null)
                Text(
                  txnBundle.transaction.notes,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(currency.formatAmount(txnBundle.transaction.amount)),
              Text(
                currency.formatAmount(runningBalance),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
