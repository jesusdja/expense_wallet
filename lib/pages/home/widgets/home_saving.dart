import 'package:expense_wallet/config/wallet_colors.dart';
import 'package:expense_wallet/config/wallet_image.dart';
import 'package:expense_wallet/config/wallet_style.dart';
import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
import 'package:expense_wallet/pages/home/provider/home_provider.dart';
import 'package:expense_wallet/pages/payment/models/payment_model.dart';
import 'package:expense_wallet/widgets_utils/circular_progress_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeSaving extends StatefulWidget {
  const HomeSaving({Key? key}) : super(key: key);

  @override
  State<HomeSaving> createState() => _HomeGeneralState();
}

class _HomeGeneralState extends State<HomeSaving> {

  late HomeProvider homeProvider;
  late CategoriesProvider categoriesProvider;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200)).then((value){
      homeProvider.categorySelected = '';
      homeProvider.resetDataSaving();
    });
  }

  Future<bool> _willPopCallback() async {
    homeProvider.categorySelected = '';
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {

    homeProvider = Provider.of<HomeProvider>(context);
    categoriesProvider = Provider.of<CategoriesProvider>(context);

    Map<String,List<PaymentModel>> dataPay = {};
    double montoTotal = 0;
    double montoAhorrar = 0;
    double totalRestado = 0;

    for (var element in categoriesProvider.listCategories) {
      dataPay[element.name!] = [];
    }

    for (var payment in homeProvider.payments) {
      dataPay[payment.category]!.add(payment);
      montoTotal+= double.parse(payment.amount!.replaceAll(',', '.'));
    }

    homeProvider.dataSaving.forEach((key, value) {
      montoAhorrar += value;
    });

    totalRestado = montoTotal - montoAhorrar;

    return SafeArea(
      child: WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar(),
          body: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: 0.2,
                  child: SizedBox(
                    width: sizeW,
                    child: Container(
                      margin: EdgeInsets.only(bottom: sizeH * 0.04),
                      height: sizeH * 0.3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: Image.asset(WalletImage.logoRemoveBg).image,
                              fit: BoxFit.fitHeight
                          )
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: sizeW,
                height: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      child: (homeProvider.loadDataInitial && categoriesProvider.loadDataInitial) ?
                      Center(
                        child: circularProgressColors(),
                      ) : SizedBox(
                        width: sizeW,
                        child: listData(dataPay: dataPay),
                      ),
                    ),
                    SizedBox(width: sizeW,height: sizeH * 0.03),
                    SizedBox(
                      width: sizeW,
                      child: Text('${montoTotal.toStringAsFixed(2)} \$ - ${montoAhorrar.toStringAsFixed(2)} \$ = ${totalRestado.toStringAsFixed(2)} \$',
                          style: WalletStyles().stylePrimary(
                              color: WalletColors.primary,size: sizeH * 0.028
                          ),textAlign: TextAlign.center),
                    ),
                    SizedBox(width: sizeW,height: sizeH * 0.07),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar(){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: Container(),
      actions: [
        SizedBox(
          width: sizeW,
          child: Row(
            children: [
              Expanded(child: Text('Que se pudo ahorra??',textAlign: TextAlign.center,style: WalletStyles().stylePrimary(
                  size: sizeH * 0.022,color: WalletColors.primary
              ))),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: sizeW * 0.05),
                  child: Icon(Icons.cancel_outlined,color: WalletColors.primary,size: sizeH * 0.03,),
                ),
                onTap: (){
                  homeProvider.categorySelected = '';
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget listData({required Map<String,List<PaymentModel>> dataPay}){

    List<Widget> listW = [];

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
    bool exists = false;
    for (var pay in payments) {
      total = total + double.parse(pay.amount!.replaceAll(',', '.'));
      listW.add(cardPay(paymentModel: pay));
      homeProvider.dataSaving.forEach((key, value) {
        if(pay.category == category && key == pay.id){ exists = true; }
      });
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
              child: SizedBox(
                width: sizeW,
                child: Row(
                  children: [
                    Expanded(flex: 2, child:Text(category,style: WalletStyles().stylePrimary(
                        color: Colors.black,
                        size: sizeH * 0.025
                    ))),
                    Text('${total.toStringAsFixed(2)} \$',textAlign: TextAlign.right,
                      style: WalletStyles().stylePrimary(
                        color: exists ? Colors.green : Colors.black,
                        size: sizeH * 0.025
                    ),),
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
    bool exists = homeProvider.dataSaving.containsKey(paymentModel.id);

    return Container(
      width: sizeW,
      margin: EdgeInsets.only(left: sizeW * 0.02),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          color: Colors.black12
      ),
      child: SizedBox(
        width: sizeW,
        child: Row(
          children: [
            Expanded(flex: 2, child:Text(paymentModel.title!)),
            Text('${paymentModel.amount!}\$',textAlign: TextAlign.right,style: WalletStyles().stylePrimary(
              size: sizeH * 0.02,
              fontWeight: FontWeight.bold,
            ),),
            InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: sizeW * 0.02),
                child: Icon(Icons.check_circle,size: sizeH * 0.025,color: exists ? Colors.green : Colors.grey),
              ),
              onTap: (){
                if(exists){
                  homeProvider.deleteSaving(key: paymentModel.id!);
                }else{
                  homeProvider.addSaving(key: paymentModel.id!, value: double.parse(paymentModel.amount!));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
