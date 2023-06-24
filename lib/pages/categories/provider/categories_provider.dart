import 'package:expense_wallet/pages/categories/models/categories_model.dart';
import 'package:expense_wallet/pages/categories/provider/firebase_connection_categories.dart';
import 'package:flutter/material.dart';

class CategoriesProvider extends ChangeNotifier {

  TextEditingController controllerAdd = TextEditingController();
  bool loadDataInitialAdd = true;

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
      result = await FirebaseConnectionCategories().create(CategoriesModel(name: controllerAdd.text, status: 'activo'));
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> existsCategories() async {
    bool result = false;
    try{
      result = await FirebaseConnectionCategories().getUID(name: controllerAdd.text);
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> editCategories({required CategoriesModel categoriesModel}) async {
    bool result = false;
    try{
      result = await FirebaseConnectionCategories().edit(data: categoriesModel);
    }catch(e){
      debugPrint(e.toString());
    }
    return result;
  }




}