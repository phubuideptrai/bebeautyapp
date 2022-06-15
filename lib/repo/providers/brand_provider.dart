import 'package:bebeautyapp/model/MBrand.dart';
import 'package:bebeautyapp/repo/services/brand_services.dart';
import 'package:flutter/cupertino.dart';

class BrandProvider with ChangeNotifier {
  BrandServices brandServices = BrandServices();
  List<MBrand> brands = [];

  BrandProvider.initialize(){
    loadBrands();
  }

  loadBrands() async {
    brands = await brandServices.getBrands();
    notifyListeners();
  }

  addBrand(MBrand brand) {
    brands.add(brand);
    notifyListeners();
  }

  updateBrand(MBrand brand) {
    for(int i = 0; i < brands.length; i++) {
      if(brands[i].getID() == brand.getID()) {
        brands[i].setID(brand.getID());
        brands[i].setImage(brand.getImage());
        brands[i].setName(brand.getName());
        brands[i].setTotalSoldOut(0);
      }
    }
    notifyListeners();
  }

  updateTotalQuantity(int brandID) {
    for(int i = 0; i < brands.length; i++) {
      if(brands[i].getID() == brandID) {
        int totalQuantity = brands[i].getProductQuantity() + 1;
        brands[i].setProductQuantity(totalQuantity);
      }
    }
    notifyListeners();
  }
}