class MProductsInCart {
  late int productID;
  late String productName;
  late double productPrice;
  late int productQuantity;
  late double totalPrice;

  MProductsInCart(
      {required this.productID,
        required this.productName,
        required this.productPrice,
        required this.productQuantity,
        required this.totalPrice});

  static MProductsInCart copyFrom(MProductsInCart product) {
    return MProductsInCart(
      productID: product.productID,
      productName: product.productName,
      productPrice: product.productPrice,
      productQuantity: product.productQuantity,
      totalPrice: product.totalPrice,
    );
  }

  int getProductID() {return this.productID;}
  void setProductID(int ID) {this.productID = ID;}

  String getProductName() {return this.productName;}
  void setProductName(String Name) {this.productName = Name;}

  double getProductPrice() {return this.productPrice;}
  void setProductPrice(double price) {this.productPrice = price;}

  int getProductQuantity() {return this.productQuantity;}
  void setProductQuantity(int quantity) {this.productQuantity = quantity;}

  double getTotalPrice() {return this.totalPrice;}
  void setTotalPrice(double TotalPrice) {this.totalPrice = TotalPrice;}

}