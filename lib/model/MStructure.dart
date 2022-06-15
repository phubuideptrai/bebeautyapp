import 'package:cloud_firestore/cloud_firestore.dart';

class MStructure {
  late int id;
  late String name;

  MStructure({required this.id, required this.name});

  static MStructure copyFrom(MStructure origin) {
    return MStructure(
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

  MStructure.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
  }
}
