import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/home/provider/home_provider.dart';
import 'package:expense_wallet/pages/payment/provider/add_payment_provider.dart';
import 'package:expense_wallet/pages/payments_monthly/models/payment_monthly_model.dart';
import 'package:expense_wallet/pages/payments_monthly/providers/payments_monthly_provider.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:expense_wallet/widgets_utils/dialog_alert.dart';
import 'package:expense_wallet/widgets_utils/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPaymentFrequent extends StatefulWidget {
  const AddPaymentFrequent({Key? key}) : super(key: key);

  @override
  State<AddPaymentFrequent> createState() => _AddPaymentFrequentState();
}

class _AddPaymentFrequentState extends State<AddPaymentFrequent> {

  late PaymentsMonthlyProvider paymentsMonthlyProvider;
  late AddPaymentProvider addPaymentProvider;
  late HomeProvider homeProvider;

  @override
  Widget build(BuildContext context) {

    paymentsMonthlyProvider = Provider.of<PaymentsMonthlyProvider>(context);
    addPaymentProvider = Provider.of<AddPaymentProvider>(context);
    homeProvider = Provider.of<HomeProvider>(context);

    List<Widget> listW = [];

    for (var element in paymentsMonthlyProvider.listPaymentsMonthly) {
      listW.add(card(paymentMonthModel: element));
    }

    return SingleChildScrollView(
      child: Column(
        children: listW,
      ),
    );
  }

  Widget card({required PaymentMonthModel paymentMonthModel}){

    String dateSt = '${DateTime.parse(paymentMonthModel.date!).day} de cada mes';

    TextStyle style = WalletStyles().stylePrimary(size: sizeH * 0.02,fontWeight: FontWeight.bold);
    TextStyle style2 = WalletStyles().stylePrimary(size: sizeH * 0.02);

    bool isSend = true;
    for (var element in homeProvider.payments) {
      if(element.title! == paymentMonthModel.title! &&
          element.amount! == paymentMonthModel.amount! &&
          element.category! == paymentMonthModel.category!){
        isSend = false;
      }
    }

    return Container(
      width: sizeW,
      margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: sizeW,
                  child: Text(paymentMonthModel.title!,style: style),
                ),
                SizedBox(
                  width: sizeW,
                  child: Row(
                    children: [
                      Text('${paymentMonthModel.amount!}\$',style: style2),SizedBox(width: sizeW * 0.03),
                      Text(paymentMonthModel.category!,style: style2),SizedBox(width: sizeW * 0.03),
                      Text(dateSt,style: style2),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
            child: addPaymentProvider.idPaySend == paymentMonthModel.id! ?
            circularProgressColors(widthContainer1: sizeW * 0.05,widthContainer2: sizeW * 0.05) :
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: isSend ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Colors.green),
              ),
              child: Text(isSend ? 'Enviar' : 'Pagado'),
              onPressed: () async {
                bool? res = await alertTitle(title: 'Enviar pagos frecuentes', subTitle: 'Estas seguro que quieres enviar el pago frecuente');
                if(res != null && res){
                  if(await addPaymentProvider.sendDataPayFrequent(paymentMonthModel: paymentMonthModel)){
                    showAlert(text: 'Enviado con exito!');
                  }else{
                    showAlert(text: 'Problemas para enviar la información', isError: true);
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
