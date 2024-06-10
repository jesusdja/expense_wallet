import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:flutter/material.dart';

class ShowDialogMessage{

  Future showBox({required BuildContext context}) async{
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: sizeW,
            padding: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                style: BorderStyle.solid,
                width: 3,
                color: WalletColors.primary
              )
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: sizeH * 0.02,),
                buttonText(context: context,result: 0,title: 'Datos Generales',),
                SizedBox(height: sizeH * 0.02,),
                buttonText(context: context,result: 1,title: 'Gastos',),
                SizedBox(height: sizeH * 0.02,),
                buttonText(context: context,result: 2,title: 'Ahorros',),
                SizedBox(height: sizeH * 0.02,),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buttonText({required BuildContext context, required int result, required String title}){
    TextStyle styleTitle = WalletStyles().stylePrimary(color: Colors.white,size: 18,fontWeight: FontWeight.bold);
    return InkWell(
      onTap: (){
        Navigator.of(context).pop(result);
      },
      child: Container(
        width: sizeW,
        margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
        padding: EdgeInsets.symmetric(vertical: sizeH * 0.02),
        decoration: BoxDecoration(
            color: WalletColors.primary,
            borderRadius: BorderRadius.circular(8.0)
        ),
        child: Center(
          child: Text(title,style: styleTitle,textAlign: TextAlign.center),
        ),
      ),
    );
  }


}