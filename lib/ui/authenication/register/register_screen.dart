import 'package:bebeautyapp/repo/function/sign_in.dart';
import 'package:bebeautyapp/repo/function/sign_up.dart';
import 'package:bebeautyapp/main.dart';
import 'package:bebeautyapp/ui/authenication/login/login_screen.dart';
import 'package:bebeautyapp/ui/authenication/login/widgets/rounded_input_field.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class RegisterScreen extends StatefulWidget {
  static String id = 'RegisterScreen';

  @override
  _RegisterScreen createState() => new _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  // manage state of modal progress HUD widget
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  final _formKey = GlobalKey<FormState>();

  String email = "";
  String displayName = "";
  String phone = "";
  String password = "";
  String rePassword = "";

  bool checkTerm = false;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final retypePasswordFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final nameFocusNode = FocusNode();

  final signUpFunctions = new SignUp_Function();

  final registerButtonController = RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: kAppNameTextPink,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kFourthColor.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          'Create Account',
                          style: kBigTitleTextStyle,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // RoundedInputField(
                            //   hintText: "Email",
                            //   icon: Icons.mail_outline_outlined,
                            //   textController: Provider.of<SignUp_Function>(context, listen: false)
                            //       .emailController,
                            //   validator: Provider.of<SignUp_Function>(context, listen: false)
                            //       .emailValidate,
                            //   focusNode: widget.emailFocusNode,
                            //   onChanged: (value) {
                            //     widget.email = value;
                            //   },
                            //   onFieldSubmitted: (text) =>
                            //       widget.nameFocusNode.requestFocus(),
                            // ),
                            // RoundedInputField(
                            //   hintText: "Display Name",
                            //   icon: Icons.person,
                            //   textController: Provider.of<SignUp_Function>(context, listen: false)
                            //       .displayNameController,
                            //   validator: Provider.of<SignUp_Function>(context, listen: false)
                            //       .nameValidate,
                            //   focusNode: widget.nameFocusNode,
                            //   onFieldSubmitted: (text) =>
                            //       widget.phoneNumberFocusNode.requestFocus(),
                            //   onChanged: (value) {
                            //     widget.displayName = value;
                            //   },
                            // ),
                            // RoundedInputField(
                            //   hintText: "Phone Number",
                            //   focusNode: widget.phoneNumberFocusNode,
                            //   textController: Provider.of<SignUp_Function>(context, listen: false)
                            //       .phoneNumberController,
                            //   validator: Provider.of<SignUp_Function>(context, listen: false)
                            //       .phoneNumberValidate,
                            //   icon: Icons.phone_android_rounded,
                            //   onFieldSubmitted: (text) =>
                            //       widget.passwordFocusNode.requestFocus(),
                            //   onChanged: (value) {
                            //     widget.phone = value;
                            //   },
                            // ),

                            TextFormField(
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
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .emailController,
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
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              focusNode: nameFocusNode,
                              onChanged: (value) {
                                displayName = value;
                              },
                              cursorColor: kTextColor,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Name is empty';
                                } else if (!kNameRegex.hasMatch(text))
                                  return 'Invalid Name!';
                                return null;
                              },
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .displayNameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                hintText: "Display name",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              focusNode: phoneNumberFocusNode,
                              onChanged: (value) {
                                phone = value;
                              },
                              cursorColor: kTextColor,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Phone number is empty';
                                } else if (!kPhoneNumber.hasMatch(text))
                                  return 'Invalid Phone Number!';
                                return null;
                              },
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .phoneNumberController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(
                                  Icons.phone_android_rounded,
                                  color: Colors.black,
                                ),
                                hintText: "Phone number",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: _obscureText1,
                              onChanged: (value) {
                                password = value;
                              },
                              focusNode: passwordFocusNode,
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .passwordController,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Password is empty';
                                } else if (!kPasswordRegex.hasMatch(text))
                                  return 'Minimum six characters, at least one uppercase letter,\n '
                                      'one lowercase letter, one number and one special character!';
                                return null;
                              },
                              cursorColor: kTextColor,
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
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              obscureText: _obscureText2,
                              onChanged: (value) {
                                rePassword = value;
                              },
                              focusNode: retypePasswordFocusNode,
                              controller: Provider.of<SignUp_Function>(context,
                                      listen: false)
                                  .retypePasswordController,
                              cursorColor: kTextColor,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Re-Password is empty';
                                } else if (text != password)
                                  return 'Password does not match!';
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Re-Enter Password",
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(
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
                                  borderSide: const BorderSide(
                                      color: kPrimaryColor, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 1),
                                ),
                              ),
                            ),

                            // RoundedPasswordField(
                            //   hintText: "Password",
                            //   focusNode: passwordFocusNode,
                            //   textController: Provider.of<SignIn_Function>(context, listen: false)
                            //       .passwordController,
                            //   onChanged: (value) {
                            //     password = value;
                            //   },
                            // ),
                            // RoundedPasswordField(
                            //   hintText: "Re-Enter Password",
                            //   focusNode: retypePasswordFocusNode,
                            //   textController: Provider.of<SignIn_Function>(context, listen: false)
                            //       .passwordController,
                            //   onChanged: (value) {
                            //     rePassword = value;
                            //   },
                            // ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormField<bool>(
                                  builder: (state) {
                                    return Column(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Checkbox(
                                                checkColor: Colors.white,
                                                activeColor: kPrimaryColor,
                                                value: checkTerm,
                                                onChanged: (value) {
                                                  setState(() {
                                                    checkTerm = value!;
                                                    state.didChange(value);
                                                  });
                                                }),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text.rich(TextSpan(
                                                  text:
                                                      'By clicking Sign Up, you agree to\nour ',
                                                  style: const TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      color: kTextColor),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text:
                                                            'Terms of Service',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: kPrimaryColor,
                                                          fontFamily: 'Poppins',
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                // code to open / launch terms of service link here
                                                              }),
                                                    TextSpan(
                                                        text: ' and ',
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 14,
                                                            color: kTextColor),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  'Privacy\nPolicy',
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      'Poppins',
                                                                  fontSize: 16,
                                                                  color:
                                                                      kPrimaryColor,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline),
                                                              recognizer:
                                                                  TapGestureRecognizer()
                                                                    ..onTap =
                                                                        () {
                                                                      // code to open / launch privacy policy link here
                                                                    })
                                                        ]),
                                                    const TextSpan(
                                                        text: '.',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            fontSize: 14,
                                                            color: kTextColor))
                                                  ])),
                                            ),
                                          ],
                                        ),
                                        //display error in matching theme
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 110, top: 7),
                                          child: Text(
                                            state.errorText ?? '',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor,
                                                fontSize: 11,
                                                fontFamily: 'Poppins'),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                  //output from validation will be displayed in state.errorText (above)
                                  validator: (value) {
                                    if (!checkTerm) {
                                      return 'You need to accept Terms & Privacy';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),

                            CustomRoundedLoadingButton(
                              text: 'Sign Up',
                              onPress: () async {
                                //Validate
                                if (_formKey.currentState!.validate()) {
                                  bool result =
                                      await signUpFunctions.createUser(
                                          email, displayName, phone, password);
                                  if (result == true) {
                                    // Clear text ở các textfield
                                    Provider.of<SignUp_Function>(context,
                                            listen: false)
                                        .emailController
                                        .clear();
                                    Provider.of<SignUp_Function>(context,
                                            listen: false)
                                        .displayNameController
                                        .clear();
                                    Provider.of<SignUp_Function>(context,
                                            listen: false)
                                        .phoneNumberController
                                        .clear();
                                    Provider.of<SignUp_Function>(context,
                                            listen: false)
                                        .passwordController
                                        .clear();
                                    Provider.of<SignUp_Function>(context,
                                            listen: false)
                                        .retypePasswordController
                                        .clear();
                                    print("Created Account Successfully");
                                    registerButtonController.stop();
                                  }
                                } else
                                  registerButtonController.stop();
                              },
                              controller: registerButtonController,
                              horizontalPadding: 45,
                            ),

                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Already have an account? ',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: kTextColor,
                                        fontFamily: 'Poppins',
                                      ),
                                      children: [
                                        TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginScreen()),
                                              );
                                            },
                                          text: 'Sign In',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: kPrimaryColor,
                                            fontFamily: 'Poppins',
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
