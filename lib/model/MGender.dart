import 'package:cloud_firestore/cloud_firestore.dart';

class MGender {
  late int id;
  late String name;

  MGender({required this.id, required this.name});

  static MGender copyFrom(MGender origin) {
    return MGender(
      id: origin.id,
      name: origin.name,
    );
  }

  int getID() {
    return this.id;
  }

  void setID(int ID) {
    this.id = ID;
  }

  String getName() {
    return this.name;
  }

  void setName(String Name) {
    this.name = Name;
  }

  MGender.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
  }
}
