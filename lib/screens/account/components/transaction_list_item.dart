import 'package:flutter/material.dart';

import '../../../database.dart';

class TransactionListItem extends StatelessWidget {
  final TXN transaction;
  final Currency currency;

  const TransactionListItem({
    Key key,
    @required this.transaction,
    @required this.currency,
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
              Text(transaction.payeeId.toString()),
              Text(
                transaction.categoryId.toString(),
                style: const TextStyle(fontSize: 12),
              ),
              if (transaction.notes != null)
                Text(
                  transaction.notes,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(currency.formatAmount(transaction.amount)),
              const Text(
                '[run_balance]',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
