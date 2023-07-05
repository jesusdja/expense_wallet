import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_wallet/pages/payment/models/payment_model.dart';
import 'package:expense_wallet/services/authenticate_firebase.dart';
import 'package:flutter/material.dart';

class FirebaseConnectionPayment{

  final CollectionReference collection = FirebaseFirestore.instance.collection('payments');

  Future<bool> create(PaymentModel data) async {
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

  Future<List<PaymentModel>> getAll({required String date}) async{
    List<PaymentModel> listAll = [];
    try{
      if(AuthenticateFirebaseUser().firebaseAuth.currentUser != null){
        var result =  await collection.
        where('user',isEqualTo: AuthenticateFirebaseUser().firebaseAuth.currentUser!.uid).
        where('month',isEqualTo: date).get();
        listAll = result.docs.map((QueryDocumentSnapshot e){
          return PaymentModel.fromMap(e.data() as Map<String,dynamic>) ;
        }).toList();
      }
    }catch(ex){
      debugPrint(ex.toString());
    }
    return listAll;
  }

  Future<bool> edit({required PaymentModel data}) async {
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

