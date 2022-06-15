import 'package:bebeautyapp/model/MCart.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MProductInCart.dart';
import 'package:flutter/material.dart';

import '../services/cart_services.dart';

class CartProvider with ChangeNotifier {
  MCart cart = new MCart(products: []);
  CartServices cartServices = CartServices();

  CartProvider.initialize(){

  }

  void addProductInCart(MProduct product, int quantity) {
    cartServices.addProductInCart(this.cart, product, quantity);

    notifyListeners();

  }

  void removeProductsInCart(MCart cart, List<MProductInCart> selectedProducts) {
    cartServices.removeSelectedProductsInCart(cart.products, selectedProducts);
    notifyListeners();
  }

  void increaseProductQuantity(MProductInCart productInCart) {
    cart.increaseProductQuantity(productInCart);
    notifyListeners();
  }

  void decreaseProductQuantity(MProductInCart productInCart) {
    cart.decreaseProductQuantity(productInCart);
    notifyListeners();
  }

  void resetCart() {
    cart = new MCart(products: []);;
    notifyListeners();
  }

}