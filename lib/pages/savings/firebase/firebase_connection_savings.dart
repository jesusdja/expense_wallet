import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_wallet/pages/savings/models/savings_model.dart';
import 'package:expense_wallet/services/authenticate_firebase.dart';
import 'package:flutter/material.dart';

class FirebaseConnectionSavings{

  final CollectionReference collection = FirebaseFirestore.instance.collection('savings');

  Future<bool> create(SavingModel data) async {
    bool res = false;
    try{
      DocumentReference reference = await collection.add(data.toMap());
      data.id = reference.id;
      data.user = AuthenticateFirebaseUser().firebaseAuth.currentUser!.uid;
      await edit(data: data);
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

  Future<List<SavingModel>> getAll() async{
    List<SavingModel> listAll = [];
    try{
      if(AuthenticateFirebaseUser().firebaseAuth.currentUser != null){
        var result =  await collection.
        where('user',isEqualTo: AuthenticateFirebaseUser().firebaseAuth.currentUser!.uid).get();
        listAll = result.docs.map((QueryDocumentSnapshot e){
          return SavingModel.fromMap(e.data() as Map<String,dynamic>) ;
        }).toList();
      }
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll;
  }

  Future<bool> edit({required SavingModel data}) async {
    bool res = false;
    try{
      await collection.doc(data.id).update(data.toMap());
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

  Future<bool> editLine({required SavingModel data, required List<SavingLineModel> listData}) async {
    bool res = false;
    try{
      List<String> enco = listData.map((e) => jsonEncode(e.toMap())).toList();

      await collection.doc(data.id).update({'lines' : enco});
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

  Future<bool> delete({required String id}) async {
    bool res = false;
    try{
      await collection.doc(id).delete();
      res = true;
    }catch(ex){
      debugPrint(ex.toString());
    }
    return res;
  }

}

