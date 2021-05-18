part of '../database.dart';

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 30)();
  IntColumn get type => intEnum<AccountType>()();
  IntColumn get currencyId =>
      integer().customConstraint('NOT NULL REFERENCES currencies(id)')();
  IntColumn get startingBalance => integer().withDefault(const Constant(0))();
}

class AccountBundle {
  final Account account;
  final Currency currency;
  final int balance;

  AccountBundle({
    required this.account,
    this.currency,
    this.balance,
  });
}

enum AccountType {
  bank,
  cash,
  creditCard,
  investment,
}

extension AccountTypeValues on AccountType {
  static String _value(AccountType at) {
    switch (at) {
      case AccountType.bank:
        return 'Bank';
      case AccountType.cash:
        return 'Cash';
      case AccountType.creditCard:
        return 'Credit Card';
      case AccountType.investment:
        return 'Investments';
    }

    return '';
  }

  String get value => _value(this);
}
