import 'package:cloud_firestore/cloud_firestore.dart';

class MSession {
  late int id;
  late String name;

  MSession({required this.id, required this.name});

  static MSession copyFrom(MSession origin) {
    return MSession(
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

  MSession.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
  }
}
