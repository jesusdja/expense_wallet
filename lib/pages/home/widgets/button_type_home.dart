import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_image.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/home/provider/home_provider.dart';
import 'package:expense_wallet/pages/home/widgets/drawer.dart';
import 'package:expense_wallet/pages/home/widgets/show_modal_bottom_sheet.dart';
import 'package:expense_wallet/pages/payment/models/payment_model.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonTypeHome extends StatefulWidget {
  const ButtonTypeHome({Key? key}) : super(key: key);

  @override
  State<ButtonTypeHome> createState() => _ButtonTypeHomeState();
}

class _ButtonTypeHomeState extends State<ButtonTypeHome> {

  late HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {

    homeProvider = Provider.of<HomeProvider>(context);

    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(5.0),
        margin: EdgeInsets.only(left: sizeW * 0.02,top: sizeH * 0.01,bottom: sizeH * 0.01),
        decoration: BoxDecoration(
          color: WalletColors.primary,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text( homeProvider.typeHomePrimary ? 'Datos Generales' : 'Gastos',
              style: WalletStyles().stylePrimary(
              color: Colors.white,size: sizeH * 0.02
          )),
        ),
      ),
      onTap: (){
        homeProvider.typeHomePrimary = !homeProvider.typeHomePrimary;
      },
    );
  }

}


