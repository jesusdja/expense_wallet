import 'package:expense_wallet/services/authenticate_firebase.dart';
import 'package:expense_wallet/services/shared_preferences_static.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum SplashStatus {
  home,
  splash,
  login,
}

class SplashProvider extends ChangeNotifier {

  SplashStatus splashStatus = SplashStatus.splash;

  SplashProvider() {
    initSplash();
  }

  Future initSplash() async {
    int login = SharedPreferencesLocal.walletLogin;

    User? userFirebase = AuthenticateFirebaseUser().firebaseAuth.currentUser;

    if(login == 0){
      splashStatus = SplashStatus.login;
    }
    if(login == 1 && userFirebase != null){
      splashStatus = SplashStatus.home;
    }
    notifyListeners();
  }
}
