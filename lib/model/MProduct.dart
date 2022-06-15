
import 'package:cloud_firestore/cloud_firestore.dart';

class MProduct {
  late int id;
  late String name;
  late String engName;
  late int brandID;
  late int categoryID;
  late int originID;
  late int skinID;
  late int sessionID;
  late int genderID;
  late int structureID;
  late int soldOut;
  late double totalStarRating;
  late int totalRating;
  late double marketPrice;
  late double importPrice;
  late int defaultDiscountRate;
  late double price;
  late String chemicalComposition;
  late String guideLine;
  late List<String> images;
  late List<String> userFavorite;
  late int available;
  late int searchCount;
  late String popularSearchTitle;
  late String description;

  MProduct(
      {required this.id,
        required this.name,
        required this.engName,
        required this.brandID,
        required this.categoryID,
        required this.originID,
        required this.skinID,
        required this.sessionID,
        required this.genderID,
        required this.structureID,
        required this.soldOut,
        required this.totalStarRating,
        required this.totalRating,
        required this.marketPrice,
        required this.importPrice,
        required this.defaultDiscountRate,
        required this.price,
        required this.chemicalComposition,
        required this.guideLine,
        required this.images,
        required this.userFavorite,
        required this.available,
        required this.searchCount,
        required this.popularSearchTitle,
        required this.description});

  static MProductcopyFrom(MProduct product) {
    return MProduct(
        id: product.id,
        name: product.name,
        engName: product.engName,
        brandID: product.brandID,
        categoryID: product.categoryID,
        originID: product.originID,
        skinID: product.skinID,
        sessionID: product.sessionID,
        genderID: product.genderID,
        structureID: product.structureID,
        soldOut: product.soldOut,
        totalStarRating: product.totalStarRating,
        totalRating: product.totalRating,
        marketPrice: product.marketPrice,
        importPrice: product.importPrice,
        defaultDiscountRate: product.defaultDiscountRate,
        price: product.price,
        chemicalComposition: product.chemicalComposition,
        guideLine: product.guideLine,
        images: product.images,
        userFavorite: product.userFavorite,
        available: product.available,
        searchCount: product.searchCount,
        popularSearchTitle: product.popularSearchTitle,
        description: product.description,
    );
  }

  int getID() {return this.id;}
  void setID(int ID) {this.id= ID;}

  String getName() {return this.name;}
  void setName(String Name) {this.name= Name;}

  String getEngName() {return this.engName;}
  void setEngName(String EngName) {this.engName= EngName;}

  int getBrandID() {return this.brandID;}
  void setBrandID(int BrandID) {this.brandID= BrandID;}

  int getCategoryID() {return this.categoryID;}
  void setCategoryID(int CategoryID) {this.categoryID= CategoryID;}

  int getOriginID() {return this.originID;}
  void setOriginID(int OriginID) {this.originID = OriginID;}

  int getSkinID() {return this.skinID;}
  void setSkinID(int SkinID) {this.skinID = SkinID;}

  int getSessionID() {return this.sessionID;}
  void setSessionID(int SessionID) {this.sessionID = SessionID;}

  int getGenderID() {return this.genderID;}
  void setGenderID(int GenderID) {this.genderID = GenderID;}

  int getStructureID() {return this.structureID;}
  void setStructureID(int StructureID) {this.structureID = StructureID;}

  int getSoldOut() {return this.soldOut;}
  void setSoldOut(int SoldOut) {this.soldOut = SoldOut;}

  double getTotalStarRating() {return this.totalStarRating;}
  void setTotalStarRating(double TotalStarRating) {this.totalStarRating = TotalStarRating;}

  int getTotalRating() {return this.totalRating;}
  void setTotalRating(int TotalRating) {this.totalRating = TotalRating;}

  double getMarketPrice() {return this.marketPrice;}
  void setMarketPrice(double MarketPrice) {this.marketPrice = MarketPrice;}

  double getImportPrice() {return this.importPrice;}
  void setImportPrice(double ImportPrice) {this.importPrice = ImportPrice;}

  int getDefaultDiscountRate() {return this.defaultDiscountRate;}
  void setDefaultDiscountRate(int DefaultDiscountRate) {this.defaultDiscountRate = DefaultDiscountRate;}

  double getPrice() {return this.price;}
  void setPrice(double Price) {this..price = Price;}

  String getChemicalComposition() {return this.chemicalComposition;}
  void setChemicalComposition(String ChemicalComposition) {this.chemicalComposition= ChemicalComposition;}

  String getGuideLine() {return this.guideLine;}
  void setGuideLine(String GuideLine) {this.guideLine = GuideLine;}

  List<String> getImages() {return this.images;}
  void setImages(List<String> Images) {this.images = Images;}

  String getImage(int index) {return this.images[index];}
  void setImage(String image, int index) {this.images[index] = image;}

  List<String> getUserFavorite() {return this.userFavorite;}
  void setUserFavorite(List<String> UserFavorite) {this.userFavorite = UserFavorite;}

  int getAvailable() {return this.available;}
  void setAvailable(int Available) {this.available = Available;}

  int getSearchCount() {return this.searchCount;}
  void setSearchCount(int SearchCount) {this.searchCount = SearchCount;}

  String getPopularSearchTitle() {return this.popularSearchTitle;}
  void setPopularSearchTitle(String PopularSearchTitle) {this.popularSearchTitle = PopularSearchTitle;}

  String getDescription() {return this.description;}
  void setDescription(String Description) {this.description = Description;}

  MProduct.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    name = snapshot.get('name');
    engName = snapshot.get('engName');
    brandID = snapshot.get('brandID');
    categoryID = snapshot.get('categoryID');
    originID = snapshot.get('originID');
    skinID = snapshot.get('skinID');
    sessionID = snapshot.get('sessionID');
    genderID = snapshot.get('genderID');
    structureID = snapshot.get('structureID');
    soldOut = snapshot.get('soldOut');
    double intTotalStarRating = snapshot.get('totalStarRating') + .0;
    totalStarRating = intTotalStarRating.toDouble();
    totalRating = snapshot.get('totalRating');
    double intMarketPrice = snapshot.get('marketPrice') + .0;
    marketPrice = intMarketPrice.toDouble();
    double intImportPrice = snapshot.get('importPrice') + .0;
    importPrice = intImportPrice.toDouble();
    defaultDiscountRate = snapshot.get('defaultDiscountRate');
    double intPrice = snapshot.get('price') + .0;
    price = intPrice.toDouble();
    chemicalComposition = snapshot.get('chemicalComposition');
    guideLine = snapshot.get('guideLine');
    images = List.from(snapshot.get('image'));
    userFavorite = List.from(snapshot.get('userFavorite'));
    available = snapshot.get('available');
    searchCount = snapshot.get('searchCount');
    popularSearchTitle = snapshot.get('popularSearchTitle');
    description = snapshot.get('description');
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['brandID'] = this.brandID;
    data['skinID'] = this.skinID;
    data['categoryID'] = this.categoryID;
    data['sessionID'] = this.sessionID;
    data['structureID'] = this.structureID;

    return data;
  }

}