import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/icon_app.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WalletColors.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconApp(),
          SizedBox(height: sizeH * 0.02),
          circularProgressColors(
            colorCircular: Colors.white,
          ),
        ],
      ),
    );
  }
}
