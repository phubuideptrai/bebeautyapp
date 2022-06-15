import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:async/async.dart' as FlutterAsync;

class BeBeautyRepo {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FacebookAuth _fbAuth = FacebookAuth.instance;
  static FacebookAuth get fbAuth => _fbAuth;
  static AccessToken? fbAccessToken=null;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static Uuid uuid = Uuid();
  static final normalDateFormat = DateFormat("dd-MM-yyyy");

  static void resetData() {
    _firestore = FirebaseFirestore.instance;
    _fbAuth = FacebookAuth.instance;
  }

  static Future<String?> sendResetPasswordEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == "user-not-found") {
        return "No users found with this email!";
      } else if (e.code == "invalid-email") return "Invalid email";

      return null;
    }
  }

  static bool isEmail() {
    return auth.currentUser!.providerData[0].providerId=="password";
  }

  // static Future<String?> changePassword(String newPass, String oldPass) async {
  //    AuthCredential credential = EmailAuthProvider.credential(
  //        email: auth.currentUser.email, password: oldPass);
  //   try {
  //     await auth.currentUser?.reauthenticateWithCredential(credential);
  //     await auth.currentUser?.updatePassword(newPass);
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case "wrong-password":
  //         return "Wrong-password";
  //       default:
  //         return e.code;
  //     }
  //   }
  // }

  //region facebook sign in
  static void handleFacebookSignIn() async {
    final LoginResult result = await _fbAuth
        .login(); // by default we request the email and the public profile

    if (result.status == LoginStatus.success) {
      // you are logged
      fbAccessToken = result.accessToken;
      var credential = FacebookAuthProvider.credential(fbAccessToken!.token);
      await signInFirebase(credential);
    } else {
      //error
      print(result.message);
    }
  }

  //endregion
  //region google sign in

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  static GoogleSignIn get googleSignIn => _googleSignIn;

  static void handleGoogleSignIn() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        final GoogleSignInAuthentication authentication =
        await account.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: authentication.accessToken,
          idToken: authentication.idToken,
        );
        await signInFirebase(credential);
      }
    } catch (error) {
      print(error);
    }
  }

  static User? getFirebaseUser() => FirebaseAuth.instance.currentUser;

  //endregion
  static Future signInFirebase(AuthCredential credential) async {
    try {
      final UserCredential userCredential =
      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
        print(e.code);
      } else if (e.code == 'invalid-credential') {
        // handle the error here
        print(e.code);
      }
    } catch (e) {
      // handle the error here
      print(e);
    }
  }

  static Future<String> signInWithEmailAndPassword(String email,
      String password) async {
    UserCredential credential;
    String result = '';
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          result = 'Invalid email!';
          break;
        case 'user-not-found':
          result = 'There are no users with this email!';
          break;
        case 'wrong-password':
          result = 'Wrong password!';
          break;
        default:
          return Future.value(e.code.toString());
          break;
      }
    }
    return Future.value(result);
  }
}