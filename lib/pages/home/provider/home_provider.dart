import 'package:expense_wallet/services/authenticate_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {

  HomeProvider(){
    userActive();
  }

  User? userFirebase;
  final scaffoldKeyHome = GlobalKey<ScaffoldState>();


  Future userActive() async {
    AuthenticateFirebaseUser().firebaseAuth.authStateChanges().listen((event) async {
      userFirebase = event;
      notifyListeners();
    });
  }


}