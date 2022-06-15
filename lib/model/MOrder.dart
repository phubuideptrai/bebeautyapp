import 'package:bebeautyapp/model/MProductInCart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MOrder {
  String id = "";
  String userID = "";
  String voucherCode = "";
  double discountValue = 0.0;
  double shippingValue = 0.0;
  double totalPayment = 0.0;
  int totalQuantity = 0;
  int numOfProducts = 0;
  String address = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String userName = "";
  String phone = "";
  int time = 0;
  int status = 0;


  List<MProductInCart> productsInCart = [];

  MOrder(String ID, String UserID, String VoucherCode, double DiscountValue, double shippingValue,
      double TotalPayment, int TotalQuantity, int numOfProducts, String Address, double Latitude,
      double Longitude, String UserName, String Phone, int Time, int Status){
    this.id = ID;
    this.userID = UserID;
    this.voucherCode = VoucherCode;
    this.discountValue = DiscountValue;
    this.shippingValue = shippingValue;
    this.totalPayment = TotalPayment;
    this.totalQuantity = TotalQuantity;
    this.numOfProducts = numOfProducts;
    this.address = Address;
    this.latitude = Latitude;
    this.longitude = Longitude;
    this.userName = UserName;
    this.phone = Phone;
    this.time = Time;
    this.status = Status;
    this.productsInCart = [];
  }

  void updateOrder(String id, String userID, String voucherCode, double discountValue, double shippingValue,
      double totalPayment, int totalQuantity, int numOfProducts, String address, double latitude,
      double longitude, String userName, String Phone, int time, int status) {
    setID(id);
    setUserID(userID);
    setVoucherCode(voucherCode);
    setDiscountValue(discountValue);
    setShippingValue(shippingValue);
    setTotalPayment(totalPayment);
    setTotalQuantity(totalQuantity);
    setNumOfProducts(numOfProducts);
    setAddress(address);
    setLatitude(latitude);
    setLongitude(longitude);
    setUserName(userName);
    setPhone(Phone);
    setTime(time);
    setStatus(status);
  }


  String getID() {return this.id;}
  void setID(String ID) {this.id= ID;}

  String getUserID() {return this.userID;}
  void setUserID(String UserID) {this.userID = UserID;}

  String getVoucherCode() {return this.voucherCode;}
  void setVoucherCode(String VoucherCode) {this.voucherCode = VoucherCode;}

  double getDiscountValue() {return this.discountValue;}
  void setDiscountValue(double DiscountValue) {this.discountValue = DiscountValue;}

  double getShippingValue() {return this.shippingValue;}
  void setShippingValue(double ShippingValue) {this.shippingValue = ShippingValue;}

  double getTotalPayment() {return this.totalPayment;}
  void setTotalPayment(double TotalPayment) {this.totalPayment = TotalPayment;}

  int getTotalQuantity() {return this.totalQuantity;}
  void setTotalQuantity(int TotalQuantity) {this.totalQuantity= TotalQuantity;}

  int getNumOfProducts() {return this.numOfProducts;}
  void setNumOfProducts(int number) {this.numOfProducts = number;}

  String getAddress() {return this.address;}
  void setAddress(String Address) {this.address = Address;}

  double getLatitude() {return this.latitude;}
  void setLatitude(double Latitude) {this.latitude = Latitude;}

  double getLongitude() {return this.longitude;}
  void setLongitude(double Longitude) {this.longitude = Longitude;}

  String getUserName() {return this.userName;}
  void setUserName(String UserName) {this.userName = UserName;}

  String getPhone() {return this.phone;}
  void setPhone(String Phone) {this.phone = Phone;}

  List<MProductInCart> getProductsInOrder() {return this.productsInCart;}
  void setProductsInOrder(List<MProductInCart> Products) {
    productsInCart = [];
    for(int i = 0; i < Products.length; i++) {
      productsInCart.add((Products[i]));
    }
  }

  int getTime() {return this.time;}

  String getDate() {
    var date = DateTime.fromMillisecondsSinceEpoch(this.time);
    return DateFormat('EEEE, d MMM, yyyy').format(date);
  }

  void setTime(int Time) {this.time = Time;}

  int getStatus() {return this.status;}
  void setStatus(int Status) {this.status = Status;}

  MOrder.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('orderID');
    userID = snapshot.get('userID');
    voucherCode = snapshot.get('voucherCode');
    double intDiscountValue = snapshot.get('discountValue') + .0;
    discountValue = intDiscountValue.toDouble();
    double intShippingValue = snapshot.get('shippingValue') + .0;
    shippingValue = intShippingValue.toDouble();
    double intTotalPayment = snapshot.get('totalPayment') + .0;
    totalPayment = intTotalPayment.toDouble();
    totalQuantity = snapshot.get('totalQuantity');
    numOfProducts = snapshot.get('numOfProducts');
    address = snapshot.get('address');
    latitude = snapshot.get('latitude');
    longitude = snapshot.get('longitude');
    userName = snapshot.get('userName');
    phone = snapshot.get('phone');
    time = snapshot.get('time');
    productsInCart = [];
    status = snapshot.get('status');
  }

}