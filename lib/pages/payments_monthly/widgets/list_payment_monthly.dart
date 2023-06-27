import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
import 'package:expense_wallet/pages/payments_monthly/models/payment_monthly_model.dart';
import 'package:expense_wallet/pages/payments_monthly/providers/payments_monthly_provider.dart';
import 'package:expense_wallet/widgets_utils/button_general.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/dialog_alert.dart';
import 'package:expense_wallet/widgets_utils/textfield_general.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListPaymentMonth extends StatefulWidget {
  const ListPaymentMonth({Key? key}) : super(key: key);

  @override
  State<ListPaymentMonth> createState() => _ListPaymentMonthState();
}

class _ListPaymentMonthState extends State<ListPaymentMonth> {

  late PaymentsMonthlyProvider paymentsMonthlyProvider;
  late CategoriesProvider categoriesP;

  @override
  Widget build(BuildContext context) {

    paymentsMonthlyProvider = Provider.of<PaymentsMonthlyProvider>(context);
    categoriesP = Provider.of<CategoriesProvider>(context);

    return paymentsMonthlyProvider.loadDataInitial ?
    Center(child: circularProgressColors(),) :
    paymentsMonthlyProvider.listPaymentsMonthly.isEmpty ?
    const Center(child: Text('No existen pagos mensuales'),) :
    SizedBox(
      width: sizeW,
      child: ListView.builder(
        itemCount: paymentsMonthlyProvider.listPaymentsMonthly.length,
        itemBuilder: (context,i){
          return cardPaymentsMonth(paymentMonthModel: paymentsMonthlyProvider.listPaymentsMonthly[i]);
        },
      ),
    );
  }

  Widget cardPaymentsMonth({required PaymentMonthModel paymentMonthModel}){

    bool isInactivo = paymentMonthModel.status!.contains('inactivo');
    if(paymentMonthModel.status!.contains('delete')) return Container();

    return Container(
      width: sizeW,
      margin: EdgeInsets.only(left: sizeW * .02,right: sizeW * .02,bottom: sizeH * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: InkWell(
              child: Container(
                padding: EdgeInsets.only(top: sizeH * 0.03),
                child: Row(
                  children: [
                    SizedBox(
                      width: sizeW * 0.15,
                      child: Text('${paymentMonthModel.amount!}\$',style: WalletStyles().stylePrimary(
                          size: sizeH * 0.02,fontWeight: FontWeight.bold
                      )),
                    ),
                    Expanded(
                      child: Text(paymentMonthModel.title!,style: WalletStyles().stylePrimary(
                          size: sizeH * 0.02,fontWeight: FontWeight.bold
                      )),
                    )
                  ],
                ),
              ),
              onTap: (){
                paymentsMonthlyProvider.paymentMonthModelEdit = paymentMonthModel;
              },
            ),
          ),
          ButtonGeneral(
            title: isInactivo ? 'Activar' : 'Desactivar',
            textStyle: WalletStyles().stylePrimary(size: sizeH * 0.015,color: Colors.white),
            backgroundColor: isInactivo ? Colors.green : Colors.orangeAccent,
            width: sizeW * 0.2,height: sizeH * 0.05,
            onPressed: (){
              if(isInactivo){
                editPaymentsMonth(paymentMonthModel: paymentMonthModel,status: 'activo');
              }else{
                editPaymentsMonth(paymentMonthModel: paymentMonthModel,status: 'inactivo');
              }
            },
          ),
          ButtonGeneral(
            margin: EdgeInsets.only(left: sizeW * 0.02,),
            title: 'Eliminar',
            textStyle: WalletStyles().stylePrimary(size: sizeH * 0.015,color: Colors.white),
            backgroundColor: isInactivo ? Colors.grey : Colors.red,
            width: sizeW * 0.2, height: sizeH * 0.05,
            onPressed: ()=> isInactivo ? null : editPaymentsMonth(paymentMonthModel: paymentMonthModel,status: 'delete'),
          ),
        ],
      ),
    );
  }

  Future editPaymentsMonth({required PaymentMonthModel paymentMonthModel, required String status}) async {

    String subTitle = '';
    if(status.contains('delete')){ subTitle = 'Quieres eliminar este Pago mensual'; }
    if(status.contains('activo')){ subTitle = 'Quieres activar este Pago mensual'; }
    if(status.contains('inactivo')){ subTitle = 'Quieres descativar este Pago mensual'; }

    bool? res = await alertTitle(title: 'Pago mensual',subTitle: subTitle);
    if(res != null && res){
      paymentMonthModel.status = status;
      if(await paymentsMonthlyProvider.editStatusPayment(paymentMonthModel: paymentMonthModel)){
        paymentsMonthlyProvider.initialDataAdd();
        showAlert(text: 'exito!');
      }else{
        showAlert(text: 'Problemas para enviar la información', isError: true);
      }
    }
  }

}


