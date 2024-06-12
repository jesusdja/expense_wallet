import 'package:expense_wallet/pages/payment/models/payment_model.dart';
import 'package:expense_wallet/pages/payment/provider/firebase_connection_add_payments.dart';
import 'package:expense_wallet/pages/savings/firebase/firebase_connection_savings.dart';
import 'package:expense_wallet/pages/savings/models/savings_model.dart';
import 'package:expense_wallet/services/authenticate_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SavingsProvider extends ChangeNotifier {

  SavingsProvider(){
    initialProvider();
    getDataSavings();
  }

  bool _loadDataInitial = true;
  bool get loadDataInitial => _loadDataInitial;
  set loadDataInitial(bool value){ _loadDataInitial = value; notifyListeners(); }

  List<SavingModel> savings = [];

  Future initialProvider() async {
    FirebaseConnectionSavings().collection.snapshots().listen((event) async {
      getDataSavings();
    });
  }

  Future getDataSavings() async{
    savings = await FirebaseConnectionSavings().getAll();
    loadDataInitial = false;
  }

  Future<bool> saveSavingsTitles({required String name}) async {
    bool result = false;
    try{
      result = await FirebaseConnectionSavings().create(SavingModel(
        title: name,
        date: DateTime.now().toString(),
        lines: [],
      ));
    }catch(_){}
    return result;
  }

  Future<bool> deleteSavings({required String id}) async{
    return await FirebaseConnectionSavings().delete(id: id,);
  }

}