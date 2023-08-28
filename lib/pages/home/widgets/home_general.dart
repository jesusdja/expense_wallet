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

    double total = 0.0;
    for (var payment in homeProvider.payments) {
      total += double.parse(payment.amount!.replaceAll(',', '.'));
    }

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
          SizedBox(width: sizeW,height: sizeH * 0.03),
          SizedBox(
            width: sizeW,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(homeProvider.viewTotalGeneral ? '*****.**' : '${total.toStringAsFixed(2)} \$',
                style: WalletStyles().stylePrimary(
                    color: WalletColors.primary,size: sizeH * 0.05
                ),textAlign: TextAlign.center),
                IconButton(
                  onPressed: (){
                    homeProvider.viewTotalGeneral = !homeProvider.viewTotalGeneral;
                  },
                  icon: Icon(homeProvider.viewTotalGeneral ? Icons.remove_red_eye : Icons.remove_red_eye_outlined,
                  color: WalletColors.primary,size: sizeH * 0.04),
                )
              ],
            ),
          ),
          SizedBox(width: sizeW,height: sizeH * 0.07),
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
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: listW,
      ),
    );
  }

  Widget card({required List<PaymentModel> payments, required String category}){

    double total = 0;
    List<Widget> listW = [];
    for (var pay in payments) {
      total = total + double.parse(pay.amount!.replaceAll(',', '.'));
      listW.add(cardPay(paymentModel: pay));
    }

    return InkWell(
      onTap: (){
        homeProvider.categorySelected = homeProvider.categorySelected.contains(category) ? '' : category;
      },
      child: Container(
        width: sizeW,
        margin: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
        padding: const EdgeInsets.all(5.0),
        color: Colors.black12,
        child: Column(
          children: [
            Container(
              width: sizeW,
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
                    Text('${total.toStringAsFixed(2)} \$',textAlign: TextAlign.right,),
                  ],
                ),
              ),
            ),
            if(homeProvider.categorySelected.contains(category))...listW
          ],
        ),
      ),
    );
  }

  Widget cardPay({required PaymentModel paymentModel}){

    DateTime date = DateTime.parse(paymentModel.date!);
    String dateSt = '${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}';

    return Container(
      width: sizeW,
      margin: EdgeInsets.only(left: sizeW * 0.02),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
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
                Expanded(flex: 2, child: Container()),
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
    );
  }
}
