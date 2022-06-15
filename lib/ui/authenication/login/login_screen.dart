import 'package:bebeautyapp/repo/function/sign_in.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/ui/admin/home_admin.dart';
import 'package:bebeautyapp/ui/authenication/register/register_screen.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../../home_page.dart';
import 'forgot_password_screen.dart';
import 'package:provider/provider.dart';
import 'widgets/login_with_button.dart';
import 'package:bebeautyapp/ui/authenication/login/widgets/rounded_input_field.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';

  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  _LoginScreen createState() => new _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  // manage state of modal progress HUD widget
  bool _isInAsyncCall = false;
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final signInFunctions = SignIn_Function();
  final loginButtonController = RoundedLoadingButtonController();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                kAppNameTextPink,
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 120, right: 120),
                  child: kAppNameTextSlogan,
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // RoundedInputField(
                      //   hintText: "Your Email",
                      //   inputType: TextInputType.emailAddress,
                      //   textController: Provider.of<SignIn_Function>(context, listen: false)
                      //       .emailController,
                      //   icon: Icons.mail_outline_outlined,
                      //   focusNode: widget.emailFocusNode,
                      //   validator: (value) => value.isValidEmail() ? null : "Check your email",
                      //   onFieldSubmitted: (value) => widget.passwordFocusNode.requestFocus(),
                      //   onChanged: (value) {
                      //     widget.email = value;
                      //   },
                      // ),
                      TextFormField(
                        focusNode: widget.emailFocusNode,
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
                        controller:
                            Provider.of<SignIn_Function>(context, listen: false)
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
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),
                      //
                      // RoundedPasswordField(
                      //   hintText: "Password",
                      //   focusNode: widget.passwordFocusNode,
                      //   textController: Provider.of<SignIn_Function>(context, listen: false)
                      //       .passwordController,
                      //   onChanged: (value) {
                      //     widget.password = value;
                      //   },
                      // ),
                      // ],),

                      TextFormField(
                        obscureText: _obscureText,
                        onChanged: (value) {
                          password = value;
                        },
                        focusNode: widget.passwordFocusNode,
                        controller:
                            Provider.of<SignIn_Function>(context, listen: false)
                                .passwordController,
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
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: kPrimaryColor, width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1),
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
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: const Text(
                      "Forgot password?",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15,
                        color: kPrimaryColor,
                        fontFamily: 'Poppins',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                CustomRoundedLoadingButton(
                  text: 'Sign In',
                  onPress: () async {
                    if (_formKey.currentState!.validate()) {
                      print(email + " " + password);
                      int result = await signInFunctions
                          .logInWithEmailAndPassword(email, password);
                      if (result == 0) {
                        // sign in as admin
                        // Open Home Page for admin
                        print("Sign in as admin");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logged in successfully.'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomeAdmin()),
                                    (route) => false);
                          });
                        });
                        // Fluttertoast.showToast(msg: 'Logged in successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                        loginButtonController.success();
                      } else if (result == 1) {
                        //sign in as user
                        // Open Home Page for user
                        print("Sign in as user");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Logged in successfully.'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // Fluttertoast.showToast(msg: 'Logged in successfully.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                        loginButtonController.success();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          setState(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                          });
                        });
                      } else {
                        print("Failed sign in");
                        loginButtonController.stop();
                      }
                      loginButtonController.stop();
                    } else
                      loginButtonController.stop();
                  },
                  controller: loginButtonController,
                  horizontalPadding: 45,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Don’t have an account? ',
                      style: TextStyle(
                        fontSize: 15,
                        color: kTextColor,
                        fontFamily: 'Poppins',
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              //register click
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                            },
                          text: 'Register now',
                          style: TextStyle(
                            fontSize: 15,
                            color: kPrimaryColor,
                            fontFamily: 'Poppins',
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Divider(
                          color: Colors.black54,
                          thickness: 1,
                        ),
                      ),
                      Text(
                        '    Or    ',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Divider(
                          color: Colors.black54,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                LoginWithButton(
                  icon: FontAwesomeIcons.google,
                  iconColor: Colors.red,
                  text: 'Sign in with Google',
                  isOutLine: true,
                  textColor: Colors.black54,
                  color: Colors.white,
                  onPress: () async {
                    bool result = await signInFunctions.logInWithGoogle();
                    if (result == true) {
                      print("Sign in as user by google");
                      Fluttertoast.showToast(
                          msg: 'Logged in successfully.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else
                      Fluttertoast.showToast(
                          msg: 'Logged failed',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                LoginWithButton(
                  icon: FontAwesomeIcons.facebook,
                  iconColor: Colors.white,
                  text: 'Login with Facebook',
                  isOutLine: false,
                  textColor: Colors.white,
                  color: kFacebookColor,
                  onPress: () async {
                    bool result = await signInFunctions.logInWithFacebook();
                    if (result == true) {
                      print("Sign in as user by facebook");
                      Fluttertoast.showToast(
                          msg: 'Logged in successfully.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    } else
                      Fluttertoast.showToast(
                          msg: 'Logged failed',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM);
                  },
                ),
                const SizedBox(
                  height: 24,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
