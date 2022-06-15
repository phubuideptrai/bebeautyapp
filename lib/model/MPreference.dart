import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class MPreference {
  late String userID;
  late List<int> brandHistory;
  late List<int> skinTypeHistory;
  late List<int> categoryHistory;
  late List<int> sessionHistory;
  late List<int> structureHistory;

  MPreference(
      {required this.userID,
        required this.brandHistory,
        required this.skinTypeHistory,
        required this.categoryHistory,
        required this.sessionHistory,
        required this.structureHistory});

  static MPreference copyFrom(MPreference preference) {
    return MPreference(
        userID: preference.userID,
        brandHistory: preference.brandHistory,
        skinTypeHistory: preference.skinTypeHistory,
        categoryHistory: preference.categoryHistory,
        sessionHistory: preference.sessionHistory,
        structureHistory: preference.structureHistory
    );
  }

  String getUserID() {return this.userID;}
  void setUserID(String UserID) {this.userID= UserID;}

  List<int> getBrandHistory() {return this.brandHistory;}
  void setBrandHistory(List<int> BrandHistory) {this.brandHistory = BrandHistory;}

  List<int> getSkinTypeHistory() {return this.skinTypeHistory;}
  void setSkinTypeHistory(List<int> SkinTypeHistory) {this.skinTypeHistory = SkinTypeHistory;}

  List<int> getCategoryHistory() {return this.categoryHistory;}
  void setgetCategoryHistory(List<int> getCategoryHistory) {this.categoryHistory = getCategoryHistory;}

  List<int> getSessionHistory() {return this.sessionHistory;}
  void setSessionHistory(List<int> SessionHistory) {this.sessionHistory = SessionHistory;}

  List<int> getStructureHistory() {return this.structureHistory;}
  void setStructureHistory(List<int> StructureHistory) {this.structureHistory = StructureHistory;}


  MPreference.fromSnapshot(DocumentSnapshot snapshot) {
    userID = snapshot.get('userID');
    brandHistory = List.from(snapshot.get('brandHistory'));
    skinTypeHistory = List.from(snapshot.get('skinTypeHistory'));
    categoryHistory = List.from(snapshot.get('categoryHistory'));
    sessionHistory = List.from(snapshot.get('sessionHistory'));
    structureHistory = List.from(snapshot.get('structureHistory'));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brandHistory'] = this.brandHistory;
    data['skinTypeHistory'] = this.skinTypeHistory;
    data['categoryHistory'] = this.categoryHistory;
    data['sessionHistory'] = this.sessionHistory;
    data['structureHistory'] = this.structureHistory;

    return data;
  }

}