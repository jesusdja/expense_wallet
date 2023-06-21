import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticateFirebaseUser{

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignInAccount? objGoogleSignInAccount;

  Future<User?> loginGoogle() async{
    User? user;
    try{
      GoogleSignIn objGoogleSignIn = GoogleSignIn();
      GoogleSignInAccount? objGoogleSignInAccount = await  objGoogleSignIn.signIn();

      if(objGoogleSignInAccount != null){
        GoogleSignInAuthentication objGoogleSignInAuthentication = await objGoogleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: objGoogleSignInAuthentication.accessToken,
            idToken: objGoogleSignInAuthentication.idToken
        );
        UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
        user = userCredential.user;
      }
    }on FirebaseAuthException catch(e){
      await signOutFirebase();
      debugPrint('Error ${e.toString()}');
    }
    return user;
  }

  Future signOutFirebase()async{
    try{
      await firebaseAuth.signOut();
      await GoogleSignIn().signOut();
    } on FirebaseAuthException catch (e){
      debugPrint('Error ${e.toString()}');
    }
  }



}