import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/bank_accounts/providers/bank_accounts_provider.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
import 'package:expense_wallet/pages/login/provider/login_provider.dart';
import 'package:expense_wallet/pages/payments_monthly/providers/payments_monthly_provider.dart';
import 'package:expense_wallet/pages/splash/providers/splash_provider.dart';
import 'package:expense_wallet/services/shared_preferences_static.dart';
import 'package:expense_wallet/widgets_utils/button_general.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/icon_app.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late LoginProvider loginProvider;

  @override
  Widget build(BuildContext context) {

    loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconApp(),
          SizedBox(height: sizeH * 0.02),
          loginProvider.loadSave ?
          circularProgressColors(
            colorCircular: WalletColors.primary,widthContainer2: sizeW * 0.1
          ) : buttonLogin(),
        ],
      ),
    );
  }

  Widget buttonLogin(){
    return ButtonGeneral(
      title: 'Iniciar sesión con Google',
      height: sizeH * 0.05,
      width: sizeW * 0.6,
      textStyle: WalletStyles().stylePrimary(
        size: sizeH * 0.02,color: Colors.white,fontWeight: FontWeight.bold
      ),
      backgroundColor: WalletColors.primary,
      onPressed: () async {
        if(await loginProvider.login()){
          Provider.of<CategoriesProvider>(context,listen: false).initialProvider();
          Provider.of<PaymentsMonthlyProvider>(context,listen: false).initialProvider();
          Provider.of<BankAccountsProvider>(context,listen: false).initialProvider();
          SharedPreferencesLocal.walletLogin = 1;
          Provider.of<SplashProvider>(context,listen: false).initSplash();
        }else{
          showAlert(text: 'Problema para iniciar sesión, intentelo mas tarde.',isError: true);
        }
      },
    );
  }
}
