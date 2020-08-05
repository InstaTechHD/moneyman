import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../hooks/memoized_future.dart';
import '../../services/currencies.dart';
import 'components/form.dart';

class AddAccountScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final currenciesFetch = useMemoizedFuture(
      () => Provider.of<CurrenciesService>(context).getCurrencies(),
    );

    Widget body;
    if (currenciesFetch.snapshot.connectionState == ConnectionState.waiting) {
      body = const Text('Loading...');
    } else if (currenciesFetch.snapshot.hasError) {
      body = Text(currenciesFetch.snapshot.error.toString());
    } else {
      body = AddAccountForm(currencies: currenciesFetch.snapshot.data);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: body,
    );
  }
}
