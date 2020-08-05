import 'package:flutter/widgets.dart';

import 'screens/account/screen.dart';
import 'screens/accounts/screen.dart';
import 'screens/add_account/screen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => AccountsScreen(),
  '/account': (BuildContext context) => AccountScreen(),
  '/accounts/add': (BuildContext context) => AddAccountScreen(),
};
