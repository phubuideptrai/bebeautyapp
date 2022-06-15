import 'package:cloud_firestore/cloud_firestore.dart';

class MSavedAddress {
  String id = "";
  String userID = "";
  String fullAddressName = "";
  String fullUserName = "";
  String userPhone = "";
  bool isDefault = false;
  bool isStore = false;
  double latitude = 0.0;
  double longitude = 0.0;


  MSavedAddress(String ID, String UserID, String FullAddressName, String FullUserName,
      String UserPhone, bool IsDefault, bool IsStore, double Latitude, double Longitude) {
    this.id = ID;
    this.userID = UserID;
    this.fullAddressName = fullAddressName;
    this.fullUserName = fullUserName;
    this.userPhone = UserPhone;
    this.isDefault = IsDefault;
    this.isStore = IsStore;
    this.latitude = Latitude;
    this.longitude = Longitude;
  }

  String getID() {
    return this.id;
  }

  void setID(String ID) {
    this.id = ID;
  }

  String getUserID() {
    return this.userID;
  }

  void setUserID(String UserID) {
    this.userID = UserID;
  }

  String getFullAddressName(){
    return this.fullAddressName;
  }

  void setFullAddressName(String FullAddressName) {
    this.fullAddressName = FullAddressName;
  }

  String getFullUserName() {
    return this.fullUserName;
  }

  void setFullUserName(String FullUserName) {
    this.fullUserName = FullUserName;
  }

  String getPhone() {
    return this.userPhone;
  }

  void setPhone(String Phone) {
    this.userPhone = Phone;
  }

  bool getIsDefault() {
    return this.isDefault;
  }

  void setIsDefault(bool IsDefault) {
    this.isDefault = IsDefault;
  }

  bool getIsStore() {
    return this.isStore;
  }

  void setIsStore(bool IsDefault) {
    this.isDefault = IsDefault;
  }

  double getLatitude() {
    return this.latitude;
  }

  void setLatitude(double Latitude) {
    this.latitude = Latitude;
  }

  double getLongitude() {
    return this.longitude;
  }

  void setLongitude(double Longitude) {
    this.longitude = Longitude;
  }

  MSavedAddress.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('addressID');
    userID = snapshot.get('userID');
    fullAddressName = snapshot.get('fullAddressName');
    fullUserName = snapshot.get('fullUserName');
    userPhone = snapshot.get('userPhone');
    isDefault = snapshot.get('isDefault');
    isStore = snapshot.get('isStore');
    double intLatitude = snapshot.get('latitude');
    latitude = intLatitude.toDouble();
    double intLongitude = snapshot.get('longitude');
    longitude = intLongitude.toDouble();
  }
}