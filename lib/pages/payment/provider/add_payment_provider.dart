import 'package:expense_wallet/pages/categories/models/categories_model.dart';
import 'package:expense_wallet/pages/payment/models/payment_model.dart';
import 'package:expense_wallet/pages/payment/provider/firebase_connection_add_payments.dart';
import 'package:expense_wallet/pages/payments_monthly/models/payment_monthly_model.dart';
import 'package:expense_wallet/services/authenticate_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPaymentProvider extends ChangeNotifier {

  bool _payFrequents = false;
  bool get payFrequents => _payFrequents;
  set payFrequents( bool value ){ _payFrequents = value; notifyListeners(); }

  bool _loadSaveAdd = false;
  bool get loadSaveAdd => _loadSaveAdd;
  set loadSaveAdd(bool value){ _loadSaveAdd = value; notifyListeners(); }

  String _idPaySend = '';
  String get idPaySend => _idPaySend;
  set idPaySend( String value ){ _idPaySend= value; notifyListeners(); }

  TextEditingController controllerAmount = TextEditingController();
  TextEditingController controllerTitle = TextEditingController();

  CategoriesModel? _categoriesSelected;
  CategoriesModel? get categoriesSelected => _categoriesSelected;
  set categoriesSelected(CategoriesModel? value){ _categoriesSelected = value; notifyListeners(); }

  void initial(){
    payFrequents = false;
    controllerAmount = TextEditingController();
    controllerTitle = TextEditingController();
    categoriesSelected = null;
    notifyListeners();
  }

  Future<bool> sendDataPayFrequent({required PaymentMonthModel paymentMonthModel}) async {
    bool result = false;
    idPaySend = paymentMonthModel.id!;
    try{
      result = await FirebaseConnectionPayment().create(PaymentModel(
        date: DateTime.now().toString(),
        amount: paymentMonthModel.amount!,
        category: paymentMonthModel.category!,
        title: paymentMonthModel.title!,
        month: '${DateTime.now().month.toString().padLeft(2,'0')}/${DateTime.now().year}'
      ));
    }catch(_){}
    idPaySend = '';
    return result;
  }

  Future<bool> sendDataPay() async {
    bool result = false;
    try{
      result = await FirebaseConnectionPayment().create(PaymentModel(
        date: DateTime.now().toString(),
        amount: controllerAmount.text,
        category: categoriesSelected!.name!,
        title: controllerTitle.text,
        month: '${DateTime.now().month.toString().padLeft(2,'0')}/${DateTime.now().year}'
      ));
    }catch(_){}
    return result;
  }


}