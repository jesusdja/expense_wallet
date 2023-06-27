import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
import 'package:expense_wallet/pages/payments_monthly/providers/payments_monthly_provider.dart';
import 'package:expense_wallet/pages/payments_monthly/widgets/create_payment_monthly.dart';
import 'package:expense_wallet/pages/payments_monthly/widgets/list_payment_monthly.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentsMonthlyPage extends StatefulWidget {
  const PaymentsMonthlyPage({Key? key}) : super(key: key);

  @override
  State<PaymentsMonthlyPage> createState() => _PaymentsMonthlyPageState();
}

class _PaymentsMonthlyPageState extends State<PaymentsMonthlyPage> {

  late PaymentsMonthlyProvider paymentsMonthlyProvider;
  late CategoriesProvider categoriesP;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200)).then((value){
      paymentsMonthlyProvider.initialDataAdd();
    });
  }

  @override
  Widget build(BuildContext context) {
    paymentsMonthlyProvider = Provider.of<PaymentsMonthlyProvider>(context);
    categoriesP = Provider.of<CategoriesProvider>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: WalletColors.primary,
        ),
        body: categoriesP.loadDataInitial ?
        Center(child: circularProgressColors(),) :
        Column(
          children: [
            SizedBox(height: sizeH * 0.025),
            const Expanded(
              child: ListPaymentMonth(),
            ),

            const CardAdd(),
          ],
        ),
      ),
    );
  }
}