import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/payment/add_payment.dart';
import 'package:expense_wallet/pages/payment/add_payment_frequent.dart';
import 'package:expense_wallet/pages/payment/provider/add_payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({Key? key}) : super(key: key);

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {


  late AddPaymentProvider addPaymentProvide;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200)).then((value){
      addPaymentProvide.initial();
    });
  }

  @override
  Widget build(BuildContext context) {

    addPaymentProvide = Provider.of<AddPaymentProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: sizeW,
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: sizeW * 0.02),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(WalletColors.primary),
            ),
            child: Text(addPaymentProvide.payFrequents ? 'Ir a pagos' : 'Ir a frecuentes',textAlign: TextAlign.center,
                style: WalletStyles().stylePrimary(
                color: Colors.white,size: sizeH * 0.02
            )),
            onPressed: (){
              addPaymentProvide.payFrequents = !addPaymentProvide.payFrequents;
            },
          ),
        ),
        Expanded(
          child: addPaymentProvide.payFrequents ? const AddPaymentFrequent() : const AddPayment(),
        ),
      ],
    );
  }
}
