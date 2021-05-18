import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moneyman/components/raised_button_loading.dart';
import 'package:moneyman/services/accounts.dart';
import 'package:provider/provider.dart';

import '../../../database.dart';

class AddAccountForm extends HookWidget {
  final Iterable<Currency> currencies;

  const AddAccountForm({required this.currencies}) : assert(currencies != null);

  @override
  Widget build(BuildContext context) {
    final formKey = useState(GlobalKey<FormState>());
    final account = useState(AccountFormValues());

    return Form(
      key: formKey.value,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.label),
              hintText: 'What do you usually call this account?',
              labelText: 'Name *',
            ),
            maxLength: 30,
            maxLengthEnforced: false,
            validator: (val) {
              return null;
            },
            onSaved: (value) => account.value.name = value,
          ),
          DropdownButtonFormField<AccountType>(
            decoration: const InputDecoration(
              icon: Icon(Icons.list),
              labelText: 'Type *',
              enabledBorder: InputBorder.none,
            ),
            items: AccountType.values
                .map<DropdownMenuItem<AccountType>>(
                  (at) => DropdownMenuItem<AccountType>(
                    value: at,
                    child: Text(at.value),
                  ),
                )
                .toList(),
            onChanged: (value) {},
            onSaved: (value) => account.value.type = value,
          ),
          DropdownButtonFormField<Currency>(
            decoration: const InputDecoration(
              icon: Icon(Icons.attach_money),
              labelText: 'Currency *',
              enabledBorder: InputBorder.none,
            ),
            items: currencies
                .map<DropdownMenuItem<Currency>>(
                  (c) => DropdownMenuItem(
                    value: c,
                    child: Text('${c.code} (${c.symbol})'),
                  ),
                )
                .toList(),
            onChanged: (value) {},
            onSaved: (value) => account.value.currency = value,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Starting Balance',
              hintText: 'What is the current balance of the account?',
              icon: Icon(Icons.timeline),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[\d\.\-]'),
              )
            ],
            validator: (value) {
              if (!RegExp(r'^\d+\.\d+$').hasMatch(value)) {
                return 'Invalid amount';
              }
              return null;
            },
            autovalidate: true,
            initialValue: '0.00',
            onSaved: (value) => account.value.startingBalance =
                int.parse(value.replaceAll('.', '')),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: RaisedButtonLoading(
              color: Theme.of(context).primaryColor,
              onPressed: () async {
                if (!formKey.value.currentState.validate()) return;
                await createAccount(context, account.value);
              },
              child: const Text(
                'Create Account',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> createAccount(
      BuildContext context, AccountFormValues values) async {
    await Provider.of<AccountsService>(context, listen: false).createAccount(
        name: values.name,
        type: values.type,
        startingBalance: values.startingBalance,
        currencyId: values.currency.id);
  }
}

class AccountFormValues {
  String name;
  AccountType type;
  Currency currency;
  int startingBalance;
}
