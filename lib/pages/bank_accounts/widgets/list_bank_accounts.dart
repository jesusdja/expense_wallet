import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/bank_accounts/models/bank_accounts_model.dart';
import 'package:expense_wallet/pages/bank_accounts/providers/bank_accounts_provider.dart';
import 'package:expense_wallet/widgets_utils/button_general.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/dialog_alert.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListBankAccountsPage extends StatefulWidget {
  const ListBankAccountsPage({Key? key}) : super(key: key);

  @override
  State<ListBankAccountsPage> createState() => _ListBankAccountsPageState();
}

class _ListBankAccountsPageState extends State<ListBankAccountsPage> {

  late BankAccountsProvider bankAccountsProvider;

  @override
  Widget build(BuildContext context) {

    bankAccountsProvider = Provider.of<BankAccountsProvider>(context);

    return bankAccountsProvider.loadDataInitial ?
    Center(child: circularProgressColors(),) :
    bankAccountsProvider.listBankAccounts.isEmpty ?
    const Center(child: Text('No existen pagos mensuales'),) :
    SizedBox(
      width: sizeW,
      child: ListView.builder(
        itemCount: bankAccountsProvider.listBankAccounts.length,
        itemBuilder: (context,i){
          return cardBankAccount(bankAccountModel: bankAccountsProvider.listBankAccounts[i]);
        },
      ),
    );
  }

  Widget cardBankAccount({required BankAccountModel bankAccountModel}){

    bool isInactivo = bankAccountModel.status!.contains('inactivo');
    if(bankAccountModel.status!.contains('delete')) return Container();

    return Container(
      width: sizeW,
      margin: EdgeInsets.only(left: sizeW * .02,right: sizeW * .02,bottom: sizeH * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(bankAccountModel.name!,style: WalletStyles().stylePrimary(
                size: sizeH * 0.02,fontWeight: FontWeight.bold
            )),
          ),
          ButtonGeneral(
            title: isInactivo ? 'Activar' : 'Desactivar',
            textStyle: WalletStyles().stylePrimary(size: sizeH * 0.015,color: Colors.white),
            backgroundColor: isInactivo ? Colors.green : Colors.orangeAccent,
            width: sizeW * 0.2,height: sizeH * 0.05,
            onPressed: (){
              if(isInactivo){
                editBankAccounts(bankAccountModel: bankAccountModel,status: 'activo');
              }else{
                editBankAccounts(bankAccountModel: bankAccountModel,status: 'inactivo');
              }
            },
          ),
          ButtonGeneral(
            margin: EdgeInsets.only(left: sizeW * 0.02,),
            title: 'Eliminar',
            textStyle: WalletStyles().stylePrimary(size: sizeH * 0.015,color: Colors.white),
            backgroundColor: isInactivo ? Colors.grey : Colors.red,
            width: sizeW * 0.2, height: sizeH * 0.05,
            onPressed: ()=> isInactivo ? null : editBankAccounts(bankAccountModel: bankAccountModel,status: 'delete'),
          ),
        ],
      ),
    );
  }

  Future editBankAccounts({required BankAccountModel bankAccountModel, required String status}) async {

    String subTitle = '';
    if(status.contains('delete')){ subTitle = 'Quieres eliminar esta cuenta'; }
    if(status.contains('activo')){ subTitle = 'Quieres activar esta cuenta'; }
    if(status.contains('inactivo')){ subTitle = 'Quieres descativar esta cuenta'; }

    bool? res = await alertTitle(title: 'Mis Cuentas',subTitle: subTitle);
    if(res != null && res){
      bankAccountModel.status = status;
      if(await bankAccountsProvider.editBankAccount(bankAccountModel: bankAccountModel)){
        bankAccountsProvider.initialDataAdd();
        showAlert(text: 'exito!');
      }else{
        showAlert(text: 'Problemas para enviar la información', isError: true);
      }
    }
  }

}


