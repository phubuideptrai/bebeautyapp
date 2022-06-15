import 'package:bebeautyapp/repo/function/forgotPassword.dart';
import 'package:bebeautyapp/repo/services/user_services.dart';
import 'package:bebeautyapp/ui/authenication/login/widgets/rounded_input_field.dart';

import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String id = "ChangePasswordScreen";

  @override
  _ChangePasswordScreenState createState() => new _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final newPassRetypeController = TextEditingController();

  final sendChangePasswordButtonController = RoundedLoadingButtonController();

  final userServices = UserServices();

  final passwordFocusNode = FocusNode();
  final newPassFocusNode = FocusNode();
  final reNewPassFocusNode = FocusNode();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  String password = "";
  String newPass = "";
  String reNewPass = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Change Password"),
        titleTextStyle: const TextStyle(
            color: kPrimaryColor,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const BackButton(color: kPrimaryColor),
      ),
      backgroundColor: const Color(0xffc1c2c6).withOpacity(0.1),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            SvgPicture.asset(
              "assets/images/forgot_password.svg",
              height: 250,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50, top: 50),
              child: Column(
                children: [
                  TextFormField(
                    obscureText: _obscureText1,
                    onChanged: (value) {
                      password = value;
                    },
                    focusNode: passwordFocusNode,
                    controller: oldPassController,
                    cursorColor: kTextColor,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Password is empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText1
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: _obscureText2,
                    onChanged: (value) {
                      newPass = value;
                    },
                    focusNode: newPassFocusNode,
                    controller: newPassController,
                    cursorColor: kTextColor,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'New password is empty';
                      } else if (!kPasswordRegex.hasMatch(text))
                        return 'Minimum six characters, at least one uppercase letter,\n '
                            'one lowercase letter, one number and one special character!';
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "New Password",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    obscureText: _obscureText3,
                    onChanged: (value) {
                      reNewPass = value;
                    },
                    focusNode: reNewPassFocusNode,
                    controller: newPassRetypeController,
                    cursorColor: kTextColor,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'New Retype Password is empty';
                      } else if (text != newPassController.text)
                        return 'Password does not match!';
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Re-type New Password",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText3
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _obscureText3 = !_obscureText3;
                          });
                        },
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: kPrimaryColor, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomRoundedLoadingButton(
              text: 'Confirm',
              onPress: () async {
                sendChangePasswordButtonController.start();
                if (_formKey.currentState!.validate()) {
                  bool result = await userServices.changePassword(password, newPass);
                  if(result == true) {
                    oldPassController.clear();
                    newPassRetypeController.clear();
                    newPassController.clear();
                    setState(() {
                      newPass = "";
                      password = "";
                      reNewPass = "";
                    });
                    sendChangePasswordButtonController.stop();

                  }
                  else sendChangePasswordButtonController.stop();
                }
                else sendChangePasswordButtonController.stop();
                userServices.changePassword(password, newPass);
                oldPassController.clear();
                newPassRetypeController.clear();
                newPassController.clear();
              },
              controller: sendChangePasswordButtonController,
              horizontalPadding: 45,
            ),
          ],
        ),
      ),
    ));
  }
}
