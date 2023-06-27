import 'package:expense_wallet/pages/bank_accounts/models/bank_accounts_model.dart';
import 'package:expense_wallet/pages/bank_accounts/providers/firebase_connection_bank_accounts.dart';
import 'package:flutter/material.dart';

class BankAccountsProvider extends ChangeNotifier {

  BankAccountsProvider(){
    initialProvider();
  }

  bool loadDataInitialAdd = true;
  bool loadDataInitial = true;
  TextEditingController controllerAdd = TextEditingController();

  bool _loadSaveAdd = false;
  bool get loadSaveAdd => _loadSaveAdd;
  set loadSaveAdd(bool value){ _loadSaveAdd = value; notifyListeners(); }

  List<BankAccountModel> listBankAccounts = [];

  Future initialProvider() async {
    loadDataInitial = true; notifyListeners();
    FirebaseConnectionBankAccounts().collection.snapshots().listen((event) async {
      listBankAccounts = await FirebaseConnectionBankAccounts().getAll();
      listBankAccounts.sort((a,b) => a.name!.compareTo(b.name!));
      loadDataInitial = false; notifyListeners();
    });
  }

  Future initialDataAdd() async {
    loadDataInitialAdd = true; notifyListeners();

    controllerAdd = TextEditingController();

    loadDataInitialAdd = false; notifyListeners();
  }

  Future<bool> createBankAccount() async {
    bool result = false;
    try{
      result = await FirebaseConnectionBankAccounts().create(BankAccountModel(name: controllerAdd.text, status: 'activo'));
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> existsBankAccount() async {
    bool result = false;
    try{
      result = await FirebaseConnectionBankAccounts().getUID(name: controllerAdd.text);
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> editBankAccount({required BankAccountModel bankAccountModel}) async {
    bool result = false;
    try{
      result = await FirebaseConnectionBankAccounts().edit(data: bankAccountModel);
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }

}