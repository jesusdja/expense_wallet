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

  void getDate({required DateTime dateInitial}){

    int monthOld = dateInitial.month;
    int yearOld = dateInitial.year;
    listDate = [];

    while(monthOld <= DateTime.now().month && yearOld <= DateTime.now().year){
      debugPrint('$monthOld <= ${DateTime.now().month} && $yearOld <= ${DateTime.now().year}');
      listDate.add('${monthOld.toString().padLeft(2,'0')}/$yearOld');
      if(monthOld == 12){
        yearOld++;
        monthOld = 1;
      }else{
        monthOld++;
      }
    }

    dateSelected = '${DateTime.now().month.toString().padLeft(2,'0')}/${DateTime.now().year}';
    if(dateSelected.isNotEmpty){
      getDataPayments();
    }
    notifyListeners();
  }

}