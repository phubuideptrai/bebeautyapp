

import '../model/MBrand.dart';
import '../model/MProduct.dart';

abstract class HomeScreenView {
  List<MProduct> getProductList();
  List<MProduct> getSuggestionProductList();
  List<MBrand> getBrandList();
}