
import 'package:bebeautyapp/model/MCriteria.dart';
import 'package:bebeautyapp/model/user/MUser.dart';

import 'MProduct.dart';


class MDataCBR {
  late List<MProduct> products;
  late MUser user;

  MDataCBR(
      {required this.products,
        required this.user});


  List<MProduct> getProducts() {return this.products;}
  void setProducts(List<MProduct> Products) {this.products = Products;}

  MUser getUser() {return this.user;}
  void setUser(MUser User) {this.user = User;}

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    data['user'] = this.user;
    return data;
  }

}