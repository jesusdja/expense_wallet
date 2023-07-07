import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_image.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/home/provider/home_provider.dart';
import 'package:expense_wallet/pages/home/widgets/drawer.dart';
import 'package:expense_wallet/pages/home/widgets/show_modal_bottom_sheet.dart';
import 'package:expense_wallet/pages/payment/models/payment_model.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/dialog_alert.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {

    homeProvider = Provider.of<HomeProvider>(context);

    return SizedBox(
      width: sizeW,
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: sizeW,
            height: sizeH * 0.03,
          ),
          Expanded(
            child: homeProvider.loadDataInitial ?
            Center(
              child: circularProgressColors(),
            ) : SizedBox(
              width: sizeW,
              child: listData(),
            ),
          ),
        ],
      ),
    );
  }


  Widget listData(){

    List<Widget> listW = [];
    for(int x = 0; x < homeProvider.payments.length; x++){
      listW.add(card(paymentModel: homeProvider.payments[x],index: x));
      listW.add(SizedBox(height: sizeH * 0.005,));
    }

    return SingleChildScrollView(
      child: Column(
        children: listW,
      ),
    );
  }

  Widget card({required PaymentModel paymentModel, required int index}){

    DateTime date = DateTime.parse(paymentModel.date!);
    String dateSt = '${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}';

    return Slidable(
      key: ValueKey(index),
      closeOnScroll: true,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed:(context)=> actionDelete(context,paymentModel: paymentModel),
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
        child: Column(
          children: [
            SizedBox(
              width: sizeW,
              child: Row(
                children: [
                  Expanded(flex: 2, child:Text(paymentModel.title!)),
                  Text(dateSt,textAlign: TextAlign.right,),
                ],
              ),
            ),
            SizedBox(
              width: sizeW,
              child: Row(
                children: [
                  Expanded(flex: 2, child:Text(paymentModel.category!,textAlign: TextAlign.right,)),
                  SizedBox(
                    width: sizeW * 0.15,
                    child: Text('${paymentModel.amount!}\$',textAlign: TextAlign.right,style: WalletStyles().stylePrimary(
                      size: sizeH * 0.02,
                      fontWeight: FontWeight.bold,
                    ),)
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future actionDelete(BuildContext context,{required PaymentModel paymentModel}) async{
    bool? res = await alertTitle(title: 'Eliminar pago', subTitle: 'Estas seguro que quieres eliminar el pago');
    if(res != null && res){
      if(await homeProvider.deletePayments(id: paymentModel.id!)){
        showAlert(text: 'Eliminado con exito!');
      }else{
        showAlert(text: 'Problemas para enviar la información', isError: true);
      }
    }
  }
}
