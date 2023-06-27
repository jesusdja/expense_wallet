import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_wallet/pages/bank_accounts/models/bank_accounts_model.dart';
import 'package:expense_wallet/services/authenticate_firebase.dart';
import 'package:flutter/material.dart';

class FirebaseConnectionBankAccounts{

  final CollectionReference collection = FirebaseFirestore.instance.collection('bankAccounts');

  Future<bool> create(BankAccountModel data) async {
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

  Future<List<BankAccountModel>> getAll() async{
    List<BankAccountModel> listAll = [];
    try{
      if(AuthenticateFirebaseUser().firebaseAuth.currentUser != null){
        var result =  await collection.where('user',isEqualTo: AuthenticateFirebaseUser().firebaseAuth.currentUser!.uid).get();
        listAll = result.docs.map((QueryDocumentSnapshot e){
          return BankAccountModel.fromMap(e.data() as Map<String,dynamic>) ;
        }).toList();
      }
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

  Future<bool> edit({required BankAccountModel data}) async {
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

