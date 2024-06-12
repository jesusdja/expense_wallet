import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/savings/models/savings_model.dart';
import 'package:expense_wallet/pages/savings/providers/savings_provider.dart';
import 'package:expense_wallet/pages/savings/widgets/show_dialog_add.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/dialog_alert.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {

  late SavingsProvider savingsProvider;

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => SavingsProvider(),
      child: Consumer<SavingsProvider>(
        builder: (context2, provider, child){
          savingsProvider = provider;
          return Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(bottom: sizeH * 0.05),
              child: FloatingActionButton.extended(
                label: Text('Agregar',style: WalletStyles().stylePrimary(size: sizeH * 0.02,color: Colors.white)),
                backgroundColor: WalletColors.primary,
                onPressed: () async {
                  Map? data = await ShowDialogAddSavings().showBox(context: context);
                  if(data != null){
                    String name = data['name'];
                    savingsProvider.saveSavingsTitles(name: name);
                  }
                },
              ),
            ),
            body: Container(
              width: sizeW,
              height: double.infinity,
              margin: EdgeInsets.only(bottom: sizeH * 0.05),
              child: Column(
                children: [
                  SizedBox(
                    width: sizeW,
                    height: sizeH * 0.03,
                  ),
                  Expanded(
                    child: savingsProvider.loadDataInitial ?
                    Center(
                      child: circularProgressColors(),
                    ) : SizedBox(
                      width: sizeW,
                      child: listData(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      )
    );
  }

  Widget listData(){

    List<Widget> listW = [];

    for(int x = 0; x < savingsProvider.savings.length; x++){
      listW.add(card(savingModel: savingsProvider.savings[x],index: x));
      listW.add(SizedBox(height: sizeH * 0.005,));
    }

    listW.add(SizedBox(height: sizeH * 0.06,));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: listW,
      ),
    );
  }

  Widget card({required SavingModel savingModel, required int index}){
    return Slidable(
      key: ValueKey(index),
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed:(context)=> actionDelete(context,savingModel: savingModel),
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        width: sizeW,
        margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.black12
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child:Text(savingModel.title ?? '',textAlign: TextAlign.left,)),
            SizedBox(
                width: sizeW * 0.15,
                child: Text('0.00\$',textAlign: TextAlign.right,style: WalletStyles().stylePrimary(
                  size: sizeH * 0.02,
                  fontWeight: FontWeight.bold,
                ),)
            ),
          ],
        ),
      ),
    );
  }

  Future actionDelete(BuildContext context,{required SavingModel savingModel}) async{
    bool? res = await alertTitle(title: 'Eliminar', subTitle: 'Estas seguro que quieres eliminar esta cuenta, perderas todos tus registros para siempre.');
    if(res != null && res){
      if(await savingsProvider.deleteSavings(id: savingModel.id!)){
        showAlert(text: 'Eliminado con exito!');
      }else{
        showAlert(text: 'Problemas para enviar la información', isError: true);
      }
    }
  }
}
