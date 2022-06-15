
import 'package:cloud_firestore/cloud_firestore.dart';

class MCategory {
  late int id;
  late String name;
  late String imageUri;

  MCategory(
      {required this.id,
        required this.name,
        required this.imageUri});

  static MCategory copyFrom(MCategory category) {
    return MCategory(
        id: category.id,
        name: category.name,
        imageUri: category.imageUri
    );
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id= ID;}

  String getName() {return this.name;}
  void setName(String Name) {this.name= Name;}

  String getImage() {return this.imageUri;}
  void setImage(String Uri) {this.imageUri= Uri;}

  MCategory.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
    imageUri = snapshot.get('image');
  }

}