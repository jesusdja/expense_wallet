import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/widgets_utils/button_general.dart';
import 'package:expense_wallet/widgets_utils/textfield_general.dart';
import 'package:flutter/material.dart';

class ShowDialogAddSavings{

  Future showBox({required BuildContext context}) async{

    TextEditingController controller = TextEditingController();

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
                Container(
                  width: sizeW,
                  margin: EdgeInsets.symmetric(horizontal: sizeW * 0.1),
                  child: Text('Agregar metodo de ahorro',textAlign: TextAlign.center,style: WalletStyles().stylePrimary(
                      color: WalletColors.primary,size: sizeH * 0.03,fontWeight: FontWeight.bold
                  )),
                ),
                SizedBox(height: sizeH * 0.03,),
                Container(
                  width: sizeW,
                  margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
                  child: TextFieldGeneral(
                    textEditingController: controller,
                    hintText: 'Nombre',
                    textInputType: TextInputType.name,
                  ),
                ),
                SizedBox(height: sizeH * 0.03,),
                ButtonGeneral(
                  margin: EdgeInsets.only(right: sizeW * 0.02),
                  width: sizeW * 0.3,
                  height: sizeH * 0.045,
                  title: 'Agregar',
                  textStyle: WalletStyles().stylePrimary(size: sizeH * 0.018,color: Colors.white),
                  onPressed: (){
                    if(controller.text.isNotEmpty){
                      Navigator.of(context).pop({'name' : controller.text});
                    }
                  },
                  backgroundColor: WalletColors.primary,
                ),
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