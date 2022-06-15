import 'package:bebeautyapp/model/MCategory.dart';
import 'package:bebeautyapp/repo/services/category_services.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider with ChangeNotifier {
  CategoryServices categoryServices = CategoryServices();
  List<MCategory> categories = [];

  CategoryProvider.initialize(){
    loadCategories();
  }

  loadCategories() async {
    categories = await categoryServices.getCategories();
    notifyListeners();
  }
}