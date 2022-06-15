import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class MAddress {
  late String userID;
  late String fullStreetName;
  late double latitude;
  late double longitude;

  MAddress(
      {required this.userID,
        required this.fullStreetName,
        required this.latitude,
        required this.longitude});

  static MAddress copyFrom(MAddress address) {
    return MAddress(
      userID: address.userID,
      fullStreetName: address.fullStreetName,
      latitude: address.latitude,
      longitude: address.longitude
    );
  }

  String getUserID() {return this.userID;}
  void setUserID(String UserID) {this.userID= UserID;}

  String getFullNameStreet() {return this.fullStreetName;}
  void setFullNameStreet(String FullNameStreet) {this.fullStreetName = FullNameStreet;}

  double getLatitude() {return this.latitude;}
  void setLatitude(double Latitude) {this.latitude = Latitude;}

  double getlongitude() {return this.longitude;}
  void setLongitude(double Longitude) {this.longitude = Longitude;}

  MAddress.fromSnapshot(DocumentSnapshot snapshot) {
    userID = snapshot.get('userID');
    fullStreetName = snapshot.get('fullStreetName');
    latitude = snapshot.get('latitude');
    longitude = snapshot.get('longitude');
  }

}