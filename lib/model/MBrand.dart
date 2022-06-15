
import 'package:cloud_firestore/cloud_firestore.dart';

class MBrand {
  late int id;
  late String name;
  late String imageUri;
  late int productQuantity;
  late int totalSoldOut;

  MBrand(
      {required this.id,
        required this.name,
        required this.imageUri,
        required this.productQuantity,
        required this.totalSoldOut});

  static MBrand copyFrom(MBrand brand) {
    return MBrand(
        id: brand.id,
        name: brand.name,
        imageUri: brand.imageUri,
        productQuantity: brand.productQuantity,
        totalSoldOut: brand.totalSoldOut
    );
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id= ID;}

  String getName() {return this.name;}
  void setName(String Name) {this.name= Name;}

  String getImage() {return this.imageUri;}
  void setImage(String Uri) {this.imageUri= Uri;}

  int getProductQuantity() {return this.productQuantity;}
  void setProductQuantity(int ProductQuantity) {this.productQuantity = ProductQuantity;}
  void addQuantity() { this.productQuantity = this.productQuantity + 1;}

  int getTotalSoldOut() {return this.totalSoldOut;}
  void setTotalSoldOut(int TotalSoldOut) {this.totalSoldOut = TotalSoldOut;}
  void addTotalSoldOut(int SoldOut) {this.totalSoldOut = this.totalSoldOut + SoldOut;}

  MBrand.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
    imageUri = snapshot.get('image');
    productQuantity = 0;
    totalSoldOut = 0;
  }

}