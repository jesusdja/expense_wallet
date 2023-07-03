import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/payment/provider/add_payment_provider.dart';
import 'package:expense_wallet/pages/payments_monthly/models/payment_monthly_model.dart';
import 'package:expense_wallet/pages/payments_monthly/providers/payments_monthly_provider.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
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

  @override
  Widget build(BuildContext context) {

    paymentsMonthlyProvider = Provider.of<PaymentsMonthlyProvider>(context);
    addPaymentProvider = Provider.of<AddPaymentProvider>(context);

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
                  child: Text(paymentMonthModel.title!),
                ),
                SizedBox(
                  width: sizeW,
                  child: Row(
                    children: [
                      Text('${paymentMonthModel.amount!}\$'),SizedBox(width: sizeW * 0.03),
                      Text(paymentMonthModel.category!),SizedBox(width: sizeW * 0.03),
                      Text(dateSt),
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
              child: const Text('Enviar'),
              onPressed: () async {
                if(await addPaymentProvider.sendDataPayFrequent(paymentMonthModel: paymentMonthModel)){
                  showAlert(text: 'Enviado con exito!');
                }else{
                  showAlert(text: 'Problemas para enviar la información', isError: true);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
