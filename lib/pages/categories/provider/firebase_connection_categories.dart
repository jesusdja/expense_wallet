import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_wallet/pages/categories/models/categories_model.dart';
import 'package:flutter/material.dart';

class FirebaseConnectionCategories{

  final CollectionReference collection = FirebaseFirestore.instance.collection('category');

  Future<bool> create(CategoriesModel data) async {
    bool res = false;
    try{
      DocumentReference reference = await collection.add(data.toMap());
      data.id = reference.id;
      await edit(data: data);
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

  Future<List<QueryDocumentSnapshot>> getAll() async{
    List<QueryDocumentSnapshot> listAll = [];
    try{
      var result =  await collection.get();
      listAll = result.docs.map((QueryDocumentSnapshot e) => e).toList();
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll;
  }

  Future<bool> getUID({required String name}) async{
    List<QueryDocumentSnapshot> listAll = [];
    try{
      var result =  await collection.where('name',isEqualTo: name).get();
      listAll = result.docs.map((QueryDocumentSnapshot e) => e).toList();
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll.isEmpty;
  }

  Future<bool> edit({required CategoriesModel data}) async {
    bool res = false;
    try{
      await collection.doc(data.id).update(data.toMap());
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

}

