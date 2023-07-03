import 'package:expense_wallet/pages/payment/provider/add_payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key}) : super(key: key);

  @override
  State<AddPayment> createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {

  late AddPaymentProvider addPaymentProvide;

  @override
  Widget build(BuildContext context) {

    addPaymentProvide = Provider.of<AddPaymentProvider>(context);

    return Container();
  }
}
