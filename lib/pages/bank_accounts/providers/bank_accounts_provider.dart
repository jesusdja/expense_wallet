import 'package:expense_wallet/pages/bank_accounts/models/bank_accounts_model.dart';
import 'package:expense_wallet/pages/bank_accounts/providers/firebase_connection_bank_accounts.dart';
import 'package:flutter/material.dart';

class BankAccountsProvider extends ChangeNotifier {

  bool loadDataInitialAdd = true;
  TextEditingController controllerAdd = TextEditingController();

  bool _loadSaveAdd = false;
  bool get loadSaveAdd => _loadSaveAdd;
  set loadSaveAdd(bool value){ _loadSaveAdd = value; notifyListeners(); }

  Future initialDataAdd() async {
    loadDataInitialAdd = true; notifyListeners();

    controllerAdd = TextEditingController();

    loadDataInitialAdd = false; notifyListeners();
  }

  Future<bool> createCategories() async {
    bool result = false;
    try{
      result = await FirebaseConnectionBankAccounts().create(BankAccountModel(name: controllerAdd.text, status: 'activo'));
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> existsCategories() async {
    bool result = false;
    try{
      result = await FirebaseConnectionBankAccounts().getUID(name: controllerAdd.text);
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }

}