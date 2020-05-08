import 'package:flutter/material.dart';

import '../../../database.dart';

class AccountListItem extends StatelessWidget {
  final Account account;
  final String balance;

  const AccountListItem({
    Key key,
    @required this.account,
    @required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: Text(
              account.name,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(balance),
        ],
      ),
    );
  }
}
