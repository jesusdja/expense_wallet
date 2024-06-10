import 'package:expense_wallet/pages/payment/models/payment_model.dart';
import 'package:expense_wallet/pages/payment/provider/firebase_connection_add_payments.dart';
import 'package:expense_wallet/services/authenticate_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {

  HomeProvider(){
    userActive();
    initialProvider();
  }

  User? userFirebase;
  final scaffoldKeyHome = GlobalKey<ScaffoldState>();
  bool loadDataInitial = true;

  List<PaymentModel> payments = [];
  List<String> listDate = [];

  String _dateSelected = '';
  String get dateSelected => _dateSelected;
  set dateSelected(String value){
    _dateSelected = value;
    notifyListeners();
    if(value.isNotEmpty){
      getDataPayments();
    }
  }

  int _typeHomePrimary = 0;
  int get typeHomePrimary => _typeHomePrimary;
  set typeHomePrimary(int value){ _typeHomePrimary = value; notifyListeners(); }

  bool _viewTotalGeneral = true;
  bool get viewTotalGeneral => _viewTotalGeneral;
  set viewTotalGeneral(bool value){ _viewTotalGeneral = value; notifyListeners(); }

  String _categorySelected = '';
  String get categorySelected => _categorySelected;
  set categorySelected(String value){ _categorySelected = value; notifyListeners(); }

  Map<String,double> dataSaving = {};
  void resetDataSaving(){ dataSaving = {}; notifyListeners(); }

  Future userActive() async {
    AuthenticateFirebaseUser().firebaseAuth.authStateChanges().listen((event) async {
      userFirebase = event;
      notifyListeners();
      if(event != null){
        getDate(dateInitial: event.metadata.creationTime ?? DateTime.now());
      }
    });
  }

  Future initialProvider() async {
    loadDataInitial = true; notifyListeners();
    FirebaseConnectionPayment().collection.snapshots().listen((event) async {
      if(dateSelected.isNotEmpty){
        getDataPayments();
      }
    });
  }

  Future getDataPayments() async{
    payments = await FirebaseConnectionPayment().getAll(date: dateSelected);
    loadDataInitial = false; notifyListeners();
  }

  Future<bool> deletePayments({required String id}) async{
    return await FirebaseConnectionPayment().delete(id: id,);
  }

  void getDate({required DateTime dateInitial}){

    listDate = [];

    while(dateInitial.difference(DateTime.now()).inDays <= 0){
      debugPrint('$dateInitial dif ${dateInitial.difference(DateTime.now()).inDays}');
      dateInitial = dateInitial.add(const Duration(days: 1));
      if(!listDate.contains('${dateInitial.month.toString().padLeft(2,'0')}/${dateInitial.year}')){
        listDate.add('${dateInitial.month.toString().padLeft(2,'0')}/${dateInitial.year}');
      }
    }

    dateSelected = '${DateTime.now().month.toString().padLeft(2,'0')}/${DateTime.now().year}';
    if(dateSelected.isNotEmpty){
      getDataPayments();
    }
    notifyListeners();
  }

  void addSaving({required String key, required double value}){
    dataSaving[key] = value; notifyListeners();
  }

  void deleteSaving({required String key}){
    dataSaving.remove(key); notifyListeners();
  }

}