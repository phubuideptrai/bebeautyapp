import 'package:bebeautyapp/model/MAddress.dart';
import 'package:bebeautyapp/model/MPreference.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class UserServices {
  final CollectionReference userRef = FirebaseFirestore.instance.collection('Users');
  PreferenceServices preferenceServices = PreferenceServices();
  String defaultAvatarUri = "https://firebasestorage.googleapis.com/v0/b/be-beauty-app.appspot.com/o/avatar.jpg?alt=media&token=4cb911b2-3282-4aea-b03a-0ab9b681602a";

  //Create User Collection in FireStore
  Future<void> createBeBeautyUser(MUser user_model) async {
    return await userRef
        .doc(user_model.id)
        .set({
      'id': user_model.id,
      'displayName': user_model.displayName,
      'email': user_model.email,
      'phone': user_model.phone,
      'dob': user_model.dob,
      'gender': user_model.gender,
      'point': user_model.point,
      'totalSpending': user_model.totalSpending,
      'role': user_model.role,
      'avatarUri': user_model.avatarUri}
    );
  }

  //Get User
  Future<MUser> getUser(String userID) async {
    MPreference preference = new MPreference(userID: "", brandHistory: [], skinTypeHistory: [], categoryHistory: [], sessionHistory: [], structureHistory: []);
    MUser user = new MUser(id: "",
        displayName: "",
        email: "",
        phone: "",
        dob: DateTime(2001, 1, 1),
        gender: 1,
        address: new MAddress(userID: "",fullStreetName: "", latitude: 0, longitude: 0),
        point: 0,
        totalSpending: 0,
        role: 1,
        avatarUri: "https://firebasestorage.googleapis.com/v0/b/be-beauty-app.appspot.com/o/avatar.jpg?alt=media&token=4cb911b2-3282-4aea-b03a-0ab9b681602a",
        preference: new MPreference(userID: "", brandHistory: [], skinTypeHistory: [], categoryHistory: [], sessionHistory: [], structureHistory: []));

    await userRef.where('id', isEqualTo: userID).get().then((result) {
      for (DocumentSnapshot User in result.docs) {
        user = MUser.fromSnapshot(User);
      }
    });

    preference = await preferenceServices.getPreference(userID);
    user.preference = preference;

    return user;

  }

  Future<List<MUser>> getUsers() async {
    MPreference preference = new MPreference(userID: "", brandHistory: [], skinTypeHistory: [], categoryHistory: [], sessionHistory: [], structureHistory: []);
    List<MUser> users = [];
    MUser user = new MUser(id: "",
        displayName: "",
        email: "",
        phone: "",
        dob: DateTime(2001, 1, 1),
        gender: 1,
        address: new MAddress(userID: "",fullStreetName: "", latitude: 0, longitude: 0),
        point: 0,
        totalSpending: 0,
        role: 1,
        avatarUri: "https://firebasestorage.googleapis.com/v0/b/be-beauty-app.appspot.com/o/avatar.jpg?alt=media&token=4cb911b2-3282-4aea-b03a-0ab9b681602a",
        preference: new MPreference(userID: "", brandHistory: [], skinTypeHistory: [], categoryHistory: [], sessionHistory: [], structureHistory: []));

    await userRef.get().then((result) async {
      for (DocumentSnapshot User in result.docs) {
        user = MUser.fromSnapshot(User);
        preference = await preferenceServices.getPreference(user.id);
        user.preference = preference;
        users.add(user);
      }
    });
    return users;

  }

  //Create User Collection in FireStore
  MUser checkAndReturnUser(MUser user, List<MProduct> products) {
    if(products.length > 0) {
      if(user.preference.brandHistory.length == 0 || user.preference.skinTypeHistory.length == 0 ||
          user.preference.categoryHistory.length == 0 || user.preference.sessionHistory.length == 0 ||
          user.preference.structureHistory.length == 0)
      {
        MPreference preference_temp = preferenceServices.createTemp(user, products);
        MUser user_temp = new MUser(id: user.id, displayName: user.displayName, email: user.email,
            phone: user.phone, dob: user.dob, gender: user.gender,
            address: user.address, point: user.point, totalSpending: user.totalSpending,
            role: user.role, avatarUri: user.avatarUri, preference: preference_temp);

        return user_temp;
      }
      else return user;
    }

    else return user;

  }

  Future<bool> updatePoint(String userID, int point, int bonus, String sign) async {
    try {
      if(sign == 'desc') {
        await userRef.doc(userID).update({'point': point - 100});
      }
      else if(sign == 'asc') {
        await userRef.doc(userID).update({'point': point + bonus});
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  List<MUser> checkAndReturnUsers(List<MUser> users, MUser user, List<MProduct> products) {
    List<MUser> results = [];
    if(products.length > 0) {
      for (int i = 0; i < users.length; i++) {
        if(users[i].getID() != user.getID()) {
          MUser user_temp = checkAndReturnUser(users[i], products);
          results.add(user_temp);
        }
      }
    }
    return results;
  }



  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('name', isEqualTo: searchField)
        .get();
  }

  searchUserByID(String id) {
    return FirebaseFirestore.instance
        .collection("Users")
        .where('id', isEqualTo: id)
        .get();
  }
  Future<bool> updateUserInformation(MUser user) async {
    try {
      await userRef.doc(user.getID().toString()).update({'dob': user.getDob()});
      if(user.getName() != "") {
        await userRef.doc(user.getID().toString()).update({'displayName': user.getName()});
      }
      if(user.getAvatarUri() != "") {
        await userRef.doc(user.getID().toString()).update({'avatarUri': user.getAvatarUri()});
      }
      if(user.getPhone() != "") {
        await userRef.doc(user.getID().toString()).update({'phone': user.getPhone()});
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateUserAvatar(String userID, String imageUrl) async {
    try {
      if(imageUrl != "") {
        await userRef.doc(userID).update({'avatarUri': imageUrl});
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    String email = user.email.toString();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: currentPassword,
      );

      user.updatePassword(newPassword).then((_){
        Fluttertoast.showToast(msg: 'Your password changed successfully', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      }).catchError((error){
        Fluttertoast.showToast(msg: 'Some errors occur. Your password not changed', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Not match with your current password', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      }
      return false;
    }
  }

  MUser getUserForReview(List<MUser> users, String userID) {
    MUser temp = new MUser(id: "",
        displayName: "",
        email: "",
        phone: "",
        dob: DateTime(2001, 1, 1),
        gender: 1,
        address: new MAddress(userID: "",fullStreetName: "", latitude: 0, longitude: 0),
        point: 0,
        totalSpending: 0,
        role: 1,
        avatarUri: "https://firebasestorage.googleapis.com/v0/b/be-beauty-app.appspot.com/o/avatar.jpg?alt=media&token=4cb911b2-3282-4aea-b03a-0ab9b681602a",
        preference: new MPreference(userID: "", brandHistory: [], skinTypeHistory: [], categoryHistory: [], sessionHistory: [], structureHistory: []));

    for(int i = 0; i < users.length; i++) {
      if(users[i].getID() == userID) return users[i];
    }

    return temp;

  }
}