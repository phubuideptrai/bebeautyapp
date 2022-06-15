import 'package:bebeautyapp/model/MPreference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../MAddress.dart';

class MUser {
  late String id;
  late String displayName;
  late String email;
  late String phone;
  late DateTime dob;
  late int gender;
  late MAddress address;
  late int point;
  late double totalSpending;
  late int role;
  late String avatarUri;
  late MPreference preference;

  MUser(
      {required this.id,
      required this.displayName,
      required this.email,
      required this.phone,
      required this.dob,
      required this.gender,
      required this.address,
      required this.point,
      required this.totalSpending,
      required this.role,
      required this.avatarUri,
      required this.preference});

  static MUser copyFrom(MUser user) {
    return MUser(
      id: user.id,
      displayName: user.displayName,
      email: user.email,
      phone: user.phone,
      dob: user.dob,
      gender: user.gender,
      address: user.address,
      point: user.point,
      totalSpending: user.totalSpending,
      role: user.role,
      avatarUri: user.avatarUri,
      preference: user.preference,
    );
  }

  String getID() {
    return this.id;
  }

  void setID(String ID) {
    this.id = ID;
  }

  String getName() {
    return this.displayName;
  }

  void setName(String Name) {
    this.displayName = Name;
  }

  String getEmail() {
    return this.email;
  }

  void setEmail(String Email) {
    this.email = Email;
  }

  String getPhone() {
    return this.phone;
  }

  void setPhone(String Phone) {
    this.phone = Phone;
  }

  DateTime getDob() {
    return this.dob;
  }

  void setDob(DateTime Dob) {
    this.dob = Dob;
  }

  int getGender() {
    return this.gender;
  }

  void setGender(int Gender) {
    this.gender = Gender;
  }

  MAddress getAddress() {
    return this.address;
  }

  void setAddress(MAddress Address) {
    this.address = Address;
  }

  MPreference getPreference() {
    return this.preference;
  }

  void setPreference(MPreference Preference) {
    this.preference = Preference;
  }

  int getPoint() {
    return this.point;
  }

  void setPoint(int Point) {
    this.point = Point;
  }

  double getTotalSpending() {
    return this.totalSpending;
  }

  void setTotalSpending(double TotalSpending) {
    this.totalSpending = TotalSpending;
  }

  int getRole() {
    return this.role;
  }

  void setRole(int Role) {
    this.role = Role;
  }

  String getAvatarUri() {
    return this.avatarUri;
  }

  void setAvatarURi(String newAvatarUri) {
    this.avatarUri = newAvatarUri;
  }

  MPreference getBrandHistory() {
    return this.preference;
  }

  void setBrandHistory(MPreference Preference) {
    this.preference = Preference;
  }

  MUser.fromSnapshot(DocumentSnapshot snapshot) {
    Timestamp timestamp = snapshot.get('dob');
    id = snapshot.get('id');
    displayName = snapshot.get('displayName');
    email = snapshot.get('email');
    phone = snapshot.get('phone');
    dob = timestamp.toDate();
    gender = snapshot.get('gender');
    address =
        new MAddress(userID: "", fullStreetName: "", latitude: 0, longitude: 0);
    point = snapshot.get('point');
    totalSpending = snapshot.get('totalSpending');
    role = snapshot.get('role');
    avatarUri = snapshot.get('avatarUri');
    preference = new MPreference(
        userID: "",
        brandHistory: [],
        skinTypeHistory: [],
        categoryHistory: [],
        sessionHistory: [],
        structureHistory: []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['preference'] = this.preference;
    return data;
  }
}

class MUser_IsNotLogout {
  final String? uid;

  MUser_IsNotLogout({this.uid});
}
