import 'package:expense_wallet/pages/categories/models/categories_model.dart';
import 'package:expense_wallet/pages/categories/provider/firebase_connection_categories.dart';
import 'package:expense_wallet/pages/payments_monthly/models/payment_monthly_model.dart';
import 'package:expense_wallet/pages/payments_monthly/providers/firebase_connection_payments_monthly.dart';
import 'package:flutter/material.dart';

class PaymentsMonthlyProvider extends ChangeNotifier {

  PaymentsMonthlyProvider(){
    initialProvider();
  }

  bool loadDataInitial = true;

  TextEditingController controller = TextEditingController();
  TextEditingController controllerTitle = TextEditingController();

  bool _loadSaveAdd = false;
  bool get loadSaveAdd => _loadSaveAdd;
  set loadSaveAdd(bool value){ _loadSaveAdd = value; notifyListeners(); }

  DateTime? _datePayment;
  DateTime? get datePayment => _datePayment;
  set datePayment(DateTime? value){ _datePayment = value; notifyListeners(); }

  CategoriesModel? _categoriesSelected;
  CategoriesModel? get categoriesSelected => _categoriesSelected;
  set categoriesSelected(CategoriesModel? value){ _categoriesSelected = value; notifyListeners(); }

  List<PaymentMonthModel> listPaymentsMonthly = [];

  Future initialProvider() async {
    loadDataInitial = true; notifyListeners();
    FirebaseConnectionPaymentMonthly().collection.snapshots().listen((event) async {
      listPaymentsMonthly = await FirebaseConnectionPaymentMonthly().getAll();
      loadDataInitial = false; notifyListeners();
    });
  }

  initialDataAdd(){
    controller = TextEditingController();
    controllerTitle = TextEditingController();
    categoriesSelected = null;
    datePayment = null;
    notifyListeners();
  }

  Future<bool> createPayment() async {
    bool result = false;
    try{
      result = await FirebaseConnectionPaymentMonthly().create(
        PaymentMonthModel(
          title: controllerTitle.text,
          category: categoriesSelected!.name,
          amount: controller.text,
          date: datePayment!.toString(),
          status: 'activo'
        )
      );
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }

}