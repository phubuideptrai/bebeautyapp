import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:flutter/material.dart';

import '../../model/MProductInCart.dart';
import '../services/order_services.dart';


class ProductProvider with ChangeNotifier {
  ProductServices productServices = ProductServices();
  final orderServices = new OrderServices();
  List<MProduct> products = [];
  List<MProduct> allProductsFromCategory = [];
  List<MProduct> sugesstionProducts = [];

  List<MProduct> similarProductsBasedUserByCBR = [];
  bool isNeededUpdated_SimilarProductsBasedUserByCBR = true;

  List<MProduct> similarProductsByCFR = [];
  bool isNeededUpdated_SimilarProductsByCFR = true;

  List<MProduct> similarProductsBySelectedProduct = [];
  bool isNeededUpdated_SimilarProductsBySelectedProduct = true;

  List<MProductInCart> productsInOrder = [];

  ProductProvider.initialize(){
    loadProducts();
  }

  loadProducts() async {
    products = await productServices.getProducts();
    notifyListeners();
  }

  void updateUserFavorite(String userID, int productID) {
    int index = productServices.getProductIndexWithID(products, productID);
    if(!products[index].getUserFavorite().contains(userID)) {
      products[index].getUserFavorite().add(userID);
    }
    else products[index].getUserFavorite().remove(userID);
    notifyListeners();
  }

  Future<void> updateSimilarProductsBasedUserByCBR(List<MProduct> products, MUser user) async {
    if(isNeededUpdated_SimilarProductsBasedUserByCBR == true) {
      similarProductsBasedUserByCBR = await productServices.getSimilarityProductsByCBR(products, user);
      isNeededUpdated_SimilarProductsBasedUserByCBR = false;
      for (int i = 0; i < similarProductsBasedUserByCBR.length; i++) {
        print(similarProductsBasedUserByCBR[i].getName());
      }
      notifyListeners();
    }
  }

  Future<void> updateSimilarProductsByCFR(List<MProduct> products, MUser user) async {
    if(isNeededUpdated_SimilarProductsByCFR == true) {
      similarProductsByCFR = await productServices.getSimilarityProductsByCFR(products, user);
      isNeededUpdated_SimilarProductsByCFR = false;
      for (int i = 0; i < similarProductsByCFR.length; i++) {
        print(similarProductsByCFR[i].getName());
      }
      notifyListeners();
    }
  }

  Future<void> updateSimilarProductsBySelectedProduct(List<MProduct> products, MProduct product) async {
    if(isNeededUpdated_SimilarProductsBySelectedProduct == true) {
      similarProductsBySelectedProduct = await productServices.getSimilarityProductsBySelectedProduct(products, product);
      isNeededUpdated_SimilarProductsBySelectedProduct = false;
      notifyListeners();
    }
  }

  void updateProductsFromCategory(List<MProduct> products) {
    allProductsFromCategory = [];
    for(int i = 0; i < products.length; i++) {
      allProductsFromCategory.add(products[i]);
    }
    notifyListeners();
  }

  Future<void> getProductsInOrder(List<MProduct> products, String orderID) async {
    productsInOrder = await orderServices.getProductsInOrder(orderID, products);
    notifyListeners();
  }
  void addProduct(MProduct product) {
    products.add(product);
    notifyListeners();
  }

  void updateProduct(MProduct product) {
    for(int i = 0; i < products.length; i++) {
      if(products[i].getID() == product.getID()) {
        products[i].setName(product.getName());
        products[i].setEngName(product.getEngName());
        products[i].setBrandID(product.getBrandID());
        products[i].setCategoryID(product.getCategoryID());
        products[i].setOriginID(product.getOriginID());
        products[i].setSkinID(product.getSkinID());
        products[i].setSessionID(product.getSessionID());
        products[i].setGenderID(product.getGenderID());
        products[i].setStructureID(product.getStructureID());
        products[i].setMarketPrice(product.getMarketPrice());
        products[i].setImportPrice(product.getImportPrice());
        products[i].setDefaultDiscountRate(product.getDefaultDiscountRate());
        products[i].setPrice(product.getPrice());
        products[i].setChemicalComposition(product.getChemicalComposition());
        products[i].setGuideLine(product.getGuideLine());
        products[i].setImages(product.getImages());
        products[i].setUserFavorite(product.getUserFavorite());
        products[i].setAvailable(product.getAvailable());
        products[i].setPopularSearchTitle(product.getPopularSearchTitle());
        products[i].setDescription(product.getDescription());
      }
    }
    notifyListeners();
  }

  loadSuggestionBooks({int? id})async{
    sugesstionProducts = await productServices.getSuggestionBooks();
    notifyListeners();
  }
}
