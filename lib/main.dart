import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/bank_accounts/providers/bank_accounts_provider.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
import 'package:expense_wallet/pages/home/provider/home_provider.dart';
import 'package:expense_wallet/pages/login/provider/login_provider.dart';
import 'package:expense_wallet/pages/payments_monthly/providers/payments_monthly_provider.dart';
import 'package:expense_wallet/pages/splash/providers/splash_provider.dart';
import 'package:expense_wallet/services/shared_preferences_static.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await Firebase.initializeApp();
  await SharedPreferencesLocal.configurePrefs();

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(lazy: false,create: ( _ ) => SplashProvider()),
        ChangeNotifierProvider(lazy: false,create: ( _ ) => HomeProvider()),
        ChangeNotifierProvider(lazy: false,create: ( _ ) => LoginProvider()),
        ChangeNotifierProvider(lazy: false,create: ( _ ) => CategoriesProvider()),
        ChangeNotifierProvider(lazy: false,create: ( _ ) => PaymentsMonthlyProvider()),
        ChangeNotifierProvider(lazy: false,create: ( _ ) => BankAccountsProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ExpenseWallet',
      theme: ThemeData.light().copyWith(
          scrollbarTheme: const ScrollbarThemeData().copyWith(
              thumbColor: MaterialStateProperty.all(
                  Colors.grey.withOpacity(0.5)
              )
          )
      ),
      home: const InitialPage(),
    );
  }
}
