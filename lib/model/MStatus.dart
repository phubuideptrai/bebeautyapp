import 'package:cloud_firestore/cloud_firestore.dart';

class MStatus {
  late int id;
  late String name;

  MStatus({required this.id, required this.name});

  static MStatus copyFrom(MStatus origin) {
    return MStatus(
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

  MStatus.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
  }
}
