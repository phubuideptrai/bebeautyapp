import 'package:bebeautyapp/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../services/authentication_services.dart';

class SignUp_Function extends ChangeNotifier {
  final AuthenticationServices _auth = AuthenticationServices();

  var displayNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var retypePasswordController = TextEditingController();
  var registerButtonController = RoundedLoadingButtonController();

  void reset() {
    displayNameController = TextEditingController();
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
    passwordController = TextEditingController();
    retypePasswordController = TextEditingController();
    registerButtonController = RoundedLoadingButtonController();

  }

  String? emailValidate(text) {
    if (!emailValidatorRegExp.hasMatch(text)) return 'Invalid email!';
    return null;
  }

  String? passwordValidate(text) {
    if (!kPasswordRegex.hasMatch(text)) return 'Invalid password!';
    return null;
  }

  String? phoneNumberValidate(text){
    if (!kPhoneNumber.hasMatch(text)) return 'Invalid Phone Number!';
    return null;
  }

  String? passwordRetypeValidate(text) {
    if (passwordController.text != text)
      return 'Password does not match!';
    return null;
  }

  Future<bool> createUser(String email, String displayName, String phone, String password) async {
    dynamic result = await _auth.registerWithEmailAndPassword(
        email, phone, displayName, password);
    if (result != null) {
      print(result.toString());
      return true;
    }
    return false;
  }
}