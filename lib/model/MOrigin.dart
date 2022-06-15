import 'package:cloud_firestore/cloud_firestore.dart';

class MOrigin {
  late int id;
  late String name;

  MOrigin(
      {required this.id,
        required this.name});

  static MOrigin copyFrom(MOrigin origin) {
    return MOrigin(
        id: origin.id,
        name: origin.name,
    );
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id= ID;}

  String getName() {return this.name;}
  void setName(String Name) {this.name= Name;}

  MOrigin.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
  }

}