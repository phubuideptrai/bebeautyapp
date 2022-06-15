import 'package:bebeautyapp/model/MBrand.dart';
import 'package:bebeautyapp/model/MCategory.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryServices {
  final CollectionReference refCategory = FirebaseFirestore.instance.collection(
      'Category');

  Future<List<MCategory>> getCategories() async {
    List<MCategory> categories = [];
    await refCategory.orderBy('id', descending: false).get().then((result) {
      for (DocumentSnapshot Category in result.docs) {
        categories.add(MCategory.fromSnapshot(Category));
      }
    });
    return categories;
  }

  String getCategoryName(List<MCategory> categories, int categoryID) {
    for(int i = 0; i < categories.length; i++) {
      if(categories[i].getID() == categoryID) return categories[i].getName();
    }
    return "";
  }
}