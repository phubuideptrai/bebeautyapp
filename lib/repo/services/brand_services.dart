import 'package:bebeautyapp/model/MBrand.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BrandServices {
  final CollectionReference refBrand= FirebaseFirestore.instance.collection('Brand');
  ProductServices productServices = ProductServices();

  Future<List<MBrand>> getBrands() async {
    List<MBrand> brands= [];
    await refBrand.orderBy('id', descending: false).get().then((result) {
      for (DocumentSnapshot Brand in result.docs) {
        brands.add(MBrand.fromSnapshot(Brand));
      }
    });
    List<MProduct> products = await productServices.getProducts();

    //Add total quantity of products in a brand
    getTotalQuantity(brands, products);
    return brands;

  }

  //Get New Brand ID
  int getNewBrandID(List<MBrand> brands) {
    return brands[brands.length - 1].getID() + 1;
  }

  //Add brand
  Future<bool> addBrand(MBrand brand) async {
    try {
      await refBrand
          .doc(brand.getID().toString())
          .set({'id': brand.getID(), 'image': brand.getImage(), 'name': brand.getName()
      });

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Update Brand Image
  Future<bool> updateBrandImage(MBrand brand) async {
    try {
      await refBrand
          .doc(brand.getID().toString())
          .update({'image': brand.getImage()});

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Update Brand Name
  Future<bool> updateBrandName(MBrand brand) async {
    try {
      await refBrand
          .doc(brand.getID().toString())
          .update({'name': brand.getName()});

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void getTotalQuantity(List<MBrand> brands, List<MProduct> products) {
    for(int i = 0; i < products.length; i++) {
      int brandID = products[i].getBrandID();
      for(int j = 0; j<brands.length; j++) {
        if(brands[j].getID() == brandID) {
          brands[j].addQuantity();
          brands[j].addTotalSoldOut(products[i].getSoldOut());
          break;
        }
      }
    }
  }

  //Insertion Sort
  List<MBrand> orderBrandsWithDesc(List<MBrand> brands) {
    int i, j;
    MBrand brand;
    for (i = 1; i < brands.length; i++)
    {
      brand = brands[i];
      j = i-1;

      /* Di chuyển các phần tử có giá trị lớn hơn giá trị
       key về sau một vị trí so với vị trí ban đầu
       của nó */
      while (j >= 0 && brands[j].getTotalSoldOut() < brand.getTotalSoldOut())
      {
        brands[j+1] = brands[j];
        j = j-1;
      }
      brands[j+1] = brand;
    }
    return brands;
  }

  List<MBrand> getTop5Brand(List<MBrand> brands) {
    List<MBrand> top5 = [];
    List<MBrand> temp = [];
    for (int i = 0; i < brands.length; i++)
    {
      temp.add(brands[i]);
    }
    orderBrandsWithDesc(temp);
    for (int i = 0; i < temp.length; i++)
    {
      top5.add(temp[i]);
      if(temp.length == 5) break;
    }
    return top5;
  }

  String getBrandName(List<MBrand> brands, int brandID) {
    for(int i = 0; i < brands.length; i++) {
      if(brands[i].getID() == brandID) return brands[i].getName();
    }
    return "";
  }
}