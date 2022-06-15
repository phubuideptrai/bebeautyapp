class MProductInCart {
  late int id;
  late String name;
  late String engName;
  late int quantity;
  late String displayImage;
  late double price;

  MProductInCart(
      {required this.id,
        required this.name,
        required this.engName,
        required this.quantity,
        required this.displayImage,
        required this.price,
      });

  static MProductcopyFrom(MProductInCart product) {
    return MProductInCart(
        id: product.id,
        name: product.name,
        engName: product.engName,
        quantity: product.quantity,
        displayImage: product.displayImage,
        price: product.price,
    );
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id= ID;}

  String getName() {return this.name;}
  void setName(String Name) {this.name= Name;}

  String getEngName() {return this.engName;}
  void setEngName(String EngName) {this.engName= EngName;}

  int getQuantity() {return this.quantity;}
  void setQuantity(int Quantity) {this.quantity= Quantity;}

  String getImage() {return this.displayImage;}
  void setImage(String image) {this.displayImage = image;}

  double getPrice() {return this.price;}
  void setPrice(double Price) {this.price = Price;}


}