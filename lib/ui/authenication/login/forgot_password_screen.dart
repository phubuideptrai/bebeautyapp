import 'package:bebeautyapp/repo/function/forgotPassword.dart';
import 'package:bebeautyapp/ui/authenication/login/widgets/rounded_input_field.dart';

import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = "ForgotPasswordScreen";

  @override
  _ForgotPasswordScreen createState() => new _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final sendEmailButtonController = RoundedLoadingButtonController();
  final emailFocusNode = FocusNode();
  final emailController = TextEditingController();

  String email = "";
  final forgotPasswordFunctions = new ForgotPasswordFunction();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFourthColor.withOpacity(0.15),
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
                height: 352,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Forgot password?",
                style: kBigTitleTextStyle.copyWith(
                  fontSize: 25,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Text(
                  "Don’t worry! It happens. Please enter the email address associated with your account.",
                  style: kPop400TextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 26,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: TextFormField(
                  focusNode: emailFocusNode,
                  onChanged: (value) {
                    email = value;
                  },
                  cursorColor: kTextColor,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Email is empty';
                    } else if (!emailValidatorRegExp.hasMatch(text))
                      return 'Invalid email!';
                    return null;
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      Icons.mail_outline_outlined,
                      color: Colors.black,
                    ),
                    hintText: "Email",
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
              ),
              CustomRoundedLoadingButton(
                text: 'Send',
                onPress: () async {
                  if (_formKey.currentState!.validate()) {
                    await forgotPasswordFunctions.sendEmailResetPassword(email);
                    sendEmailButtonController.stop();
                  } else
                    sendEmailButtonController.stop();
                  //login click
                  // Provider.of<LoginViewModel>(context, listen: false)
                  //     .loginWithEmailAndPassword((message) {
                  //   if (message != null) {
                  //     CoolAlert.show(
                  //         context: context,
                  //         type: CoolAlertType.error,
                  //         text: 'Sign in failed!\nError: $message',
                  //         onConfirmBtnTap: () {
                  //           loginButtonController.reset();
                  //           Navigator.of(context).pop();
                  //         });
                  //   } else {
                  //     loginButtonController.success();
                  //   }
                  // });
                },
                controller: sendEmailButtonController,
                horizontalPadding: 45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
