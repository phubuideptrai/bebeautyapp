import 'package:bebeautyapp/model/MProductInCart.dart';

import 'MProduct.dart';

class MCart {
  late List<MProductInCart> products;

  MCart(
      {required this.products,});

  static MCart copyFrom(MCart cart) {
    return MCart(
      products: cart.products
    );
  }

  List<MProductInCart> getProductsInCart() {return this.products;}
  void setProductsInCart(List<MProductInCart> Products) {this.products = Products;}

  double getTotalPrice() {
    double totalPrice = 0;
    for(int i = 0; i < products.length; i++) {
      totalPrice += products[i].quantity * products[i].price;
    }
    return totalPrice;
  }

  int getTotalQuantity() {
    int totalQuantity = 0;
    for(int i = 0; i < products.length; i++) {
      totalQuantity += products[i].quantity;
    }
    return totalQuantity;
  }

  int getQuantityOfProductInCart(MProduct product) {
    for(int i = 0; i < products.length; i++) {
      if(product.id == products[i].id) return products[i].getQuantity();
    }
    return 0;
  }

  void addProductInCart(MProductInCart product) {
    bool isExistedInCart = false;
    for(int i = 0; i < products.length; i++) {
      if(product.id == products[i].id) {
        isExistedInCart = true;
        this.products[i].quantity += product.quantity;
      }
    }
    if(isExistedInCart == false) this.products.add(product);
  }

  void removeProductsInCart(List<int> IDs) {
    for(int i = 0; i < IDs.length; i++) {
      for(int j = 0; j < products.length; j++) {
        if(IDs[i] == products[j].id) {
          this.products.removeAt(j);
        }
      }
    }
  }

  void increaseProductQuantity(MProductInCart productInCart) {
    for(int i = 0; i < products.length; i++) {
      if(productInCart.id == products[i].id) products[i].quantity +=1;
    }
  }

  void decreaseProductQuantity(MProductInCart productInCart) {
    for(int i = 0; i < products.length; i++) {
      if(productInCart.id == products[i].id) products[i].quantity -=1;
    }
  }

}