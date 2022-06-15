import 'dart:async';
import 'dart:io';
import 'package:bebeautyapp/model/MAddress.dart';
import 'package:bebeautyapp/model/MPreference.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/services/chat_services.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/repo/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:latlng/latlng.dart';

import 'address_services.dart';
import 'cart_services.dart';


class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference users = FirebaseFirestore.instance.collection('Users');
  late Timer timer;
  DateTime defaultDOB = DateTime(2001, 1, 1);
  String defaultAvatarUri = "https://firebasestorage.googleapis.com/v0/b/be-beauty-app.appspot.com/o/avatar.jpg?alt=media&token=4cb911b2-3282-4aea-b03a-0ab9b681602a";
  final googleSignIn = GoogleSignIn(scopes: ['email']);
  final fb = FacebookLogin();

  final UserServices userServices = new UserServices();
  final CartServices cartServices = new CartServices();
  final ChatServices chatServices = new ChatServices();
  final AddressServices addressServices = new AddressServices();
  final PreferenceServices preferenceServices = new PreferenceServices();

  // create user obj based on firebase user
  MUser_IsNotLogout? _userfromFirebase(User user) {
    return user != null ? MUser_IsNotLogout(uid: user.uid) : null;
  }
  // auth change user stream
  Stream<MUser_IsNotLogout?> get user {
    return _auth.authStateChanges().map((User? user) => _userfromFirebase(user!));
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case "wrong-password":
          Fluttertoast.showToast(msg: 'Your password is wrong.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
          break;
        case "user-not-found":
          Fluttertoast.showToast(msg: 'Your email has not been registered . Please register.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
          break;
        default:
          Fluttertoast.showToast(msg: 'An undefined error happened.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String displayName, String phone, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      if(user!=null) {
        await user.sendEmailVerification();
        Fluttertoast.showToast(msg: 'An email has been sent to ${user.email}. Please verify during 2 minutes.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        int _start = 120;
        const oneSec = const Duration(seconds: 1);
        timer = Timer.periodic(oneSec, (Timer timer) async {
          if(_start == 0) {
            timer.cancel();
            if(user != null) user.delete();
            await _auth.signOut();
          }
          else {
            _start--;
            checkEmailVerified(displayName, email, phone);
          }
        });
      }
      return user;
    } on SocketException {
      Fluttertoast.showToast(msg: 'No internet, please connect to internet', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'This email is already registered. Please enter another email.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      if(await googleSignIn.isSignedIn() != null) googleSignIn.disconnect();
      //if(await fb.isLoggedIn != null) fb.logOut();
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> checkEmailVerified(String displayName, String email, String phone) async {
    User? user = _auth.currentUser;
    if (user!=null) await user.reload();
    if(user!= null && user.emailVerified) {
      timer.cancel();
      MUser user_model  = new MUser(
          id: user.uid,
          displayName: displayName,
          email: email,
          phone: "",
          dob: defaultDOB,
          gender: 1,
          address: new MAddress(userID: user.uid, fullStreetName: "", latitude: 0, longitude: 0),
          point: 0,
          totalSpending: 0,
          role: 1,
          avatarUri: defaultAvatarUri,
          preference: new MPreference(userID: user.uid, brandHistory: [], skinTypeHistory: [], categoryHistory: [], sessionHistory: [], structureHistory: []));
      await userServices.createBeBeautyUser(user_model);
      await cartServices.createCart(user_model);
      await addressServices.createAddress(user_model);
      await preferenceServices.createPreference(user_model);
      await chatServices.createChatRoom(user_model.getID());
      await _auth.signOut();
      Fluttertoast.showToast(msg: 'Verify email successfully. Your account was created', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM);
    }
  }

  Future signInWithGoogle() async {
    try{
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken
      );

      //Firebase Sign In
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Check isNewUser or Not
      if (result.additionalUserInfo!.isNewUser) {
        if (user != null) {
          String displayName = "";
          if(user.displayName != "") displayName = user.displayName.toString();
          String email = "";
          if(user.email != "") email = user.email.toString();
          MUser user_model  = new MUser(
              id: user.uid,
              displayName: displayName,
              email: email,
              phone: "",
              dob: defaultDOB,
              gender: 1,
              address: new MAddress(userID: user.uid, fullStreetName: "", latitude: 0, longitude: 0),
              point: 0,
              totalSpending: 0,
              role: 1,
              avatarUri: defaultAvatarUri,
              preference: new MPreference(userID: user.uid, brandHistory: [], skinTypeHistory: [], categoryHistory: [], sessionHistory: [], structureHistory: []));
          await userServices.createBeBeautyUser(user_model);
          await cartServices.createCart(user_model);
          await addressServices.createAddress(user_model);
          await preferenceServices.createPreference(user_model);
          await chatServices.createChatRoom(user_model.getID());
        }
      }
      return user;
    } catch(e) {
      print(e.toString());
    }
  }

  // Sign in with Facebook
  Future signInWithFacebook() async {
    print('Starting Facebook Login');
    final res = await fb.logIn(
        permissions: [
          FacebookPermission.publicProfile,
          FacebookPermission.email
        ]
    );

    if(res.status == FacebookLoginStatus.success) {
      print('It worked');

      //Get Token
      final FacebookAccessToken? fbToken = res.accessToken;

      //Convert to Auth Credential
      final AuthCredential credential
      = FacebookAuthProvider.credential(fbToken!.token);

      //Firebase Sign In
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Check isNewUser or Not
      if (result.additionalUserInfo!.isNewUser) {
        if (user != null) {
          String displayName = "";
          if(user.displayName != "") displayName = user.displayName.toString();
          String email = "";
          if(user.email != "") email = user.email.toString();
          MUser user_model  = new MUser(
              id: user.uid,
              displayName: displayName,
              email: email,
              phone: "",
              dob: defaultDOB,
              gender: 1,
              address: new MAddress(userID: user.uid, fullStreetName: "", latitude: 0, longitude: 0),
              point: 0,
              totalSpending: 0,
              role: 1,
              avatarUri: defaultAvatarUri,
              preference: new MPreference(userID: user.uid, brandHistory: [], skinTypeHistory: [], categoryHistory: [], sessionHistory: [], structureHistory: []));
          await userServices.createBeBeautyUser(user_model);
          await cartServices.createCart(user_model);
          await addressServices.createAddress(user_model);
          await preferenceServices.createPreference(user_model);
          await chatServices.createChatRoom(user_model.getID());
        }
      }
      print('${result.user!.displayName} is now logged in');
      return user;
    }
    else if(res.status == FacebookLoginStatus.cancel) {
      print('The user canceled the login');
      Fluttertoast.showToast(msg: 'The user canceled the login.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      User? user = null;
      return user;
    }
    else {
      print('There was an error');
      Fluttertoast.showToast(msg: 'There was an error happened.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      User? user = null;
      return user;
    }
  }

  // Send email to reset password
  Future sendPasswordResetEmail(String email) async {
    return _auth.sendPasswordResetEmail(email: email);
  }



}
