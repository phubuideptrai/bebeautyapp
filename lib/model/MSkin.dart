import 'package:cloud_firestore/cloud_firestore.dart';

class MSkin {
  late int id;
  late String name;

  MSkin({required this.id, required this.name});

  static MSkin copyFrom(MSkin origin) {
    return MSkin(
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

  MSkin.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
  }
}
