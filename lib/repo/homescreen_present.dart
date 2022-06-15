

import '../model/MBrand.dart';
import '../model/MProduct.dart';
import 'homeScreen_view.dart';

class HomeScreenPresenter {
  late HomeScreenView view;
  List<MProduct> books = [];
  List<MProduct> suggestionBook = [];
  List<MBrand> authors = [];

  HomeScreenPresenter(HomeScreenView view) {
    this.view = view;
  }

  void getBookList(){
    books = view.getProductList();
  }
  void getSuggestionBookList(){
    suggestionBook = view.getSuggestionProductList();
  }
  void getAuthorList() {
    authors = view.getBrandList();
  }

}