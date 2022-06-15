
import 'package:bebeautyapp/model/MCriteria.dart';
import 'package:bebeautyapp/model/user/MUser.dart';

import 'MProduct.dart';


class MDataCFR {
  late List<MProduct> products;
  late List<MUser> users;
  late MUser user;

  MDataCFR(
      {required this.products,
        required this.users,
        required this.user});


  List<MProduct> getProducts() {return this.products;}
  void setProducts(List<MProduct> Products) {this.products = Products;}

  List<MUser> getUsers() {return this.users;}
  void setUsers(List<MUser> Users) {this.users = Users;}

  MUser getUser() {return this.user;}
  void setUser(MUser User) {this.user = User;}

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['products'] = this.products;
    data['users'] = this.users;
    data['user'] = this.user;
    return data;
  }

}