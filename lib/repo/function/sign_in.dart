import 'package:bebeautyapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/authentication_services.dart';

class SignIn_Function extends ChangeNotifier {
  final AuthenticationServices _auth = AuthenticationServices();
  final auth = FirebaseAuth.instance;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  late User user;

  void reset() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  String? passwordValidator(text) {
    if (!kPasswordRegex.hasMatch(text)) return 'Invalid password!';
    return null;
  }

  String? emailValidator(text) {
    if (!emailValidatorRegExp.hasMatch(text)) return 'Invalid email!';
    return null;
  }


  Future<int> logInWithEmailAndPassword(String email, String password) async {
    dynamic result = await _auth.signInWithEmailAndPassword(email, password);
    if(result != null) {
      user = auth.currentUser!;
      String user_id = await user.uid.toString();
      if(user_id == "DESCqkYmeTa4krec99myZe7p0rE2") { // tried to find admin with its uid
        return 0; //sign in with admin account
      }
      else {
        return 1; //sign in with user account
      }
    }
    return -1; //failed sign in
  }

  Future<bool> logInWithGoogle() async {
    dynamic result = await _auth.signInWithGoogle();
    if(result != null) {
      return true;
    }
    return false;
  }

  Future<bool> logInWithFacebook() async {
    dynamic result = await _auth.signInWithFacebook();
    if(result != null) {
      return true;
    }
    return false;
  }
}