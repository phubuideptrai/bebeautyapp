import 'package:bebeautyapp/model/MProductsInCart.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/MCart.dart';
import '../../model/MCategory.dart';
import '../../model/MProduct.dart';
import '../../model/MProductInCart.dart';

class CartServices {
  final List<MProductsInCart> products = [];
  final CollectionReference refCart = FirebaseFirestore.instance.collection('Cart');
  final CollectionReference refCategory = FirebaseFirestore.instance.collection('Category');


  //Create Cart Collection in Firebase Database
  Future<void> createCart(MUser user_model) async {
    return await refCart
        .doc(user_model.id)
        .set({'user_id': user_model.id,
              'products': products,
    });
  }

  //Add Product in Cart
  void addProductInCart(MCart cart, MProduct product, int quantity) {
    MProductInCart productInCart = new MProductInCart(id: product.id, name: product.name, engName: product.engName, displayImage: product.getImage(0), quantity: quantity, price: product.price);
    cart.addProductInCart(productInCart);
  }
  //Get New Category ID
  int getNewCategoryID(List<MCategory> categories) {
    return categories[categories.length - 1].getID() + 1;
  }

  // Add Category
  Future<bool> addCategory(MCategory category) async {
    try {
      await refCategory
          .doc(category.getID().toString())
          .set({'id': category.getID(), 'image': category.getImage(), 'name': category.getName()
      });

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Update Category Image
  Future<bool> updateCategoryImage(MCategory category) async {
    try {
      await refCategory
          .doc(category.getID().toString())
          .update({'image': category.getImage()});

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Update Brand Name
  Future<bool> updateCategoryName(MCategory brand) async {
    try {
      await refCategory
          .doc(brand.getID().toString())
          .update({'name': brand.getName()});

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //Calculate the total value of selected products in Cart
  double totalValueOfSelectedProductsInCart(List<MProductInCart> selectedProducts) {
    MCart cart = new MCart(products: selectedProducts);
    return cart.getTotalPrice();
  }

  //Calculate the total quantity of selected products in Cart
  int totalQuantityOfSelectedProductsInCart(List<MProductInCart> selectedProducts) {
    MCart cart = new MCart(products: selectedProducts);
    return cart.getTotalQuantity();
  }

  //Remove products in Cart
  void removeSelectedProductsInCart(List<MProductInCart> products, List<MProductInCart> selectedProducts) {
    for(int i = 0; i < selectedProducts.length; i++) {
      for(int j = 0; j < products.length; j++) {
        if(selectedProducts[i].getID() == products[j].getID()) products.removeAt(j);
      }
    }
  }

  //Calculate shipping value
  double calculateShippingValue(double totalDistance) {
    if(totalDistance > 0 && totalDistance < 2) {
      return 0;
    }
    else if(totalDistance >= 2 && totalDistance < 10) {
      return 30000;
    }
    else if(totalDistance >= 10 && totalDistance < 25) {
    return 60000;
    }
    else if(totalDistance >= 25 && totalDistance < 50) {
      return 100000;
    }
    else if(totalDistance >= 50) {
      return 200000;
    }
    else return 0;
  }

}