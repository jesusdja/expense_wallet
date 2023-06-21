import 'package:expense_wallet/services/authenticate_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {

  bool loadSave = false;


  Future<bool> login() async {
    bool result = false;

    loadSave = true; notifyListeners();

    User? user = await AuthenticateFirebaseUser().loginGoogle();
    result = user != null;

    loadSave = false; notifyListeners();
    return result;
  }


}
