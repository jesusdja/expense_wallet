import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/bank_accounts/providers/bank_accounts_provider.dart';
import 'package:expense_wallet/widgets_utils/button_general.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/dialog_alert.dart';
import 'package:expense_wallet/widgets_utils/textfield_general.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankAccounts extends StatefulWidget {
  const BankAccounts({Key? key}) : super(key: key);

  @override
  State<BankAccounts> createState() => _BankAccountsState();
}

class _BankAccountsState extends State<BankAccounts> {

  late BankAccountsProvider bankAccountsProvider;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200)).then((value){
      bankAccountsProvider.initialDataAdd();
    });
  }

  @override
  Widget build(BuildContext context) {

    bankAccountsProvider = Provider.of<BankAccountsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: WalletColors.primary,
      ),
      body: bankAccountsProvider.loadDataInitialAdd ?
      Center(child: circularProgressColors(),) :
      Column(
        children: [
          SizedBox(height: sizeH * 0.025),
          Expanded(
            child: Container(),
          ),
          cardAdd(),
        ],
      ),
    );
  }

  Widget cardAdd(){
    return SizedBox(
      width: sizeW,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: sizeH * 0.01,horizontal: sizeW * 0.02),
              child: TextFieldGeneral(
                textEditingController: bankAccountsProvider.controllerAdd,
                hintText: 'Nombre cuenta',
              ),
            ),
          ),
          bankAccountsProvider.loadSaveAdd ?
          circularProgressColors(widthContainer1: sizeW * 0.3, widthContainer2: sizeW * 0.08) :
          ButtonGeneral(
            margin: EdgeInsets.only(right: sizeW * 0.02),
            width: sizeW * 0.3,
            height: sizeH * 0.06,
            title: 'Agregar',
            textStyle: WalletStyles().stylePrimary(size: sizeH * 0.02,color: Colors.white),
            onPressed: () => functionAdd(),
            backgroundColor: WalletColors.primary,
          )
        ],
      ),
    );
  }

  Future functionAdd() async {

    bankAccountsProvider.loadSaveAdd = true;

    String error = '';

    if(bankAccountsProvider.controllerAdd.text.isEmpty){
      error = 'Nombre no puede estar vacio';
    }

    if(error.isEmpty){
      bool? res = await alertTitle(title: 'Agregar cuenta',subTitle: 'Se va agregar la cuenta a su listado');
      if(res != null && res){
        if(await bankAccountsProvider.existsCategories()){
          if(await bankAccountsProvider.createCategories()){
            await bankAccountsProvider.initialDataAdd();
            showAlert(text: 'Creado con exito!');
          }else{
            showAlert(text: 'Problemas para enviar la información', isError: true);
          }
        }else{
          showAlert(text: 'Esta cuenta ya existe', isError: true);
        }
      }
    }else{
      showAlert(text: error, isError: true);
    }
    bankAccountsProvider.loadSaveAdd = false;
  }
}
