
import 'package:bebeautyapp/model/MCriteria.dart';
import 'package:bebeautyapp/model/user/MUser.dart';

import 'MProduct.dart';


class MData {
  late List<MProduct> products;
  late MProduct product;

  MData(
      {required this.products,
        required this.product});


  List<MProduct> getProducts() {return this.products;}
  void setProducts(List<MProduct> Products) {this.products = Products;}

  MProduct getProduct() {return this.product;}
  void setProduct(MProduct Product) {this.product = Product;}

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    data['product'] = this.product;
    return data;
  }

}