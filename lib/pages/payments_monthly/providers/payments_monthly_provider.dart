import 'package:expense_wallet/initial_page.dart';
import 'package:expense_wallet/pages/categories/models/categories_model.dart';
import 'package:expense_wallet/pages/categories/provider/categories_provider.dart';
import 'package:expense_wallet/pages/payments_monthly/models/payment_monthly_model.dart';
import 'package:expense_wallet/pages/payments_monthly/providers/firebase_connection_payments_monthly.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  bool _isEdit = false;
  bool get isEdit => _isEdit;
  set isEdit(bool value){ _isEdit = value; notifyListeners(); }

  DateTime? _datePayment;
  DateTime? get datePayment => _datePayment;
  set datePayment(DateTime? value){ _datePayment = value; notifyListeners(); }

  CategoriesModel? _categoriesSelected;
  CategoriesModel? get categoriesSelected => _categoriesSelected;
  set categoriesSelected(CategoriesModel? value){ _categoriesSelected = value; notifyListeners(); }

  PaymentMonthModel? _paymentMonthModelEdit;
  PaymentMonthModel? get paymentMonthModelEdit => _paymentMonthModelEdit;
  set paymentMonthModelEdit(PaymentMonthModel? value){
    _paymentMonthModelEdit = value;
    if(value != null){
      controller = TextEditingController(text: value.amount!);
      controllerTitle = TextEditingController(text: value.title!);
      Provider.of<CategoriesProvider>(contextHome,listen: false).listCategories.forEach((element) {
        if(element.name == value.category!){ categoriesSelected = element; }
      });
      datePayment = DateTime.parse(value.date!);
      isEdit = true;
    }
    notifyListeners();
  }

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
    paymentMonthModelEdit = null;
    isEdit = false;
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

  Future<bool> editPayment() async {
    bool result = false;
    try{
      result = await FirebaseConnectionPaymentMonthly().edit(
        data: PaymentMonthModel(
            id: paymentMonthModelEdit!.id!,
            user: paymentMonthModelEdit!.user!,
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

  Future<bool> editStatusPayment({required PaymentMonthModel paymentMonthModel}) async {
    bool result = false;
    try{
      result = await FirebaseConnectionPaymentMonthly().edit(data: paymentMonthModel);
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }

}