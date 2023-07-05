import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_image.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/home/provider/home_provider.dart';
import 'package:expense_wallet/pages/home/widgets/drawer.dart';
import 'package:expense_wallet/pages/home/widgets/show_modal_bottom_sheet.dart';
import 'package:expense_wallet/pages/payment/models/payment_model.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:flutter/material.dart';
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
    for (var element in homeProvider.payments) {
      listW.add(card(paymentModel: element));
      listW.add(SizedBox(height: sizeH * 0.005,));
    }

    return SingleChildScrollView(
      child: Column(
        children: listW,
      ),
    );
  }

  Widget card({required PaymentModel paymentModel}){

    DateTime date = DateTime.parse(paymentModel.date!);
    String dateSt = '${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}';

    return Container(
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
    );
  }
}
