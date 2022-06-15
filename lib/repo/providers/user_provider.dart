import 'package:bebeautyapp/model/MAddress.dart';
import 'package:bebeautyapp/model/MPreference.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/services/address_services.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:bebeautyapp/repo/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';

class UserProvider with ChangeNotifier{
  final AddressServices addressServices = new AddressServices();
  final PreferenceServices preferenceServices = new PreferenceServices();
  final UserServices userServices = new UserServices();

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

  UserProvider.initialize(){}

  UserProvider(){}

  Future<void> getUser(String userID) async {
    MAddress address = await addressServices.getAddress(userID) as MAddress;
    MPreference preference = await preferenceServices.getPreference(userID) as MPreference;
    MUser user1 = await userServices.getUser(userID) as MUser;
    user1.setAddress(address);
    user1.setPreference(preference);
    user = user1;
    notifyListeners();
  }

/*Future<void> getUserForChatRoom(String User_ID) async =>
      _firestore.collection(collection).where('id', isEqualTo: User_ID).get().then((result) {
        for (DocumentSnapshot User in result.docs) {
          user_temp = User_Model.fromSnapshot(User);
          notifyListeners();
        }
      });

  void setUser(User user) {
    user = user;
    notifyListeners();
  }

  void updatePhoto(String url) {
    user.setPhoto(url);
    notifyListeners();
  }

  Future<void> updateAddress(String User_ID, String Address) async {
    _firestore.collection(collection).doc(User_ID).update({'address': Address});
    user.setAddress(Address);
    notifyListeners();
  }

  Future<void> updatePhoneNumber(String User_ID, String PhoneNumber) async {
    _firestore.collection(collection).doc(User_ID).update({'phone': PhoneNumber});
    user.setPhone(PhoneNumber);
    notifyListeners();
  }*/

}