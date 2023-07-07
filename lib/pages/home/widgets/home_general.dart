import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_image.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
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

class HomeGeneral extends StatefulWidget {
  const HomeGeneral({Key? key}) : super(key: key);

  @override
  State<HomeGeneral> createState() => _HomeGeneralState();
}

class _HomeGeneralState extends State<HomeGeneral> {

  late HomeProvider homeProvider;
  late CategoriesProvider categoriesProvider;

  @override
  Widget build(BuildContext context) {

    homeProvider = Provider.of<HomeProvider>(context);
    categoriesProvider = Provider.of<CategoriesProvider>(context);

    return SizedBox(
      width: sizeW,
      height: double.infinity,
      child: Column(
        children: [
          SizedBox(width: sizeW,height: sizeH * 0.03),
          Expanded(
            child: (homeProvider.loadDataInitial && categoriesProvider.loadDataInitial) ?
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
    Map<String,List<PaymentModel>> dataPay = {};

    for (var element in categoriesProvider.listCategories) {
      dataPay[element.name!] = [];
    }

    for (var payment in homeProvider.payments) {
      dataPay[payment.category]!.add(payment);
    }

    dataPay.forEach((key, value) {
      listW.add(card(category: key,payments: value));
    });

    return SingleChildScrollView(
      child: Column(
        children: listW,
      ),
    );
  }

  Widget card({required List<PaymentModel> payments, required String category}){

    double total = 0;
    for (var pay in payments) {
      total = total + double.parse(pay.amount!.replaceAll(',', '.'));
    }

    return Container(
      width: sizeW,
      margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.black12
      ),
      child: SizedBox(
        width: sizeW,
        child: Row(
          children: [
            Expanded(flex: 2, child:Text(category)),
            Text('$total \$',textAlign: TextAlign.right,),
          ],
        ),
      ),
    );
  }
}
