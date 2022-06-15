import 'package:cloud_firestore/cloud_firestore.dart';

/*
Type 1: Freeship with Fixed Maximum Discount Value
  maximumDiscountValue

Type 2: Freeship (Ship = 0)

Type 3: Discount Total Value of Order With Rate and Fixed Maximum Discount Value
  maximumDiscountValue
  discountRate


Type 4: Discount Total Value of Order With Fixed Maximum Discount Value
  maximumDiscountValue

Type 5: 0VND (Total value of order = 0)

 */
class MVoucher {
  late String id;
  late String voucherName;
  late String voucherCode;
  late String voucherImage;
  late int voucherType;
  late double minimumConditon;
  late int startDate;
  late int endDate;
  late int available;
  late double maximumDiscountValue;
  late int discountRate;


  MVoucher() {
    this.id = "";
    this.voucherName = "";
    this.voucherCode = "";
    this.voucherImage = "";
    this.voucherType = -1;
    this.minimumConditon = 0;
    this.startDate = 0;
    this.endDate = 0;
    this.available = 0;

    this.maximumDiscountValue = 0;
    this.discountRate = 0;
  }

  String getID() {
    return this.id;
  }

  void setID(String ID) {
    this.id = ID;
  }

  String getVoucherName() {
    return this.voucherName;
  }

  void setVoucherName(String VoucherName) {
    this.voucherName = VoucherName;
  }

  String getVoucherCode() {
    return this.voucherCode;
  }

  void setVoucherCode(String VoucherCode) {
    this.voucherCode = VoucherCode;
  }

  String getVoucherImage() {
    return this.voucherImage;
  }

  void setVoucherImage(String VoucherImage) {
    this.voucherImage = VoucherImage;
  }

  int getVoucherType() {
    return this.voucherType;
  }

  void setVoucherType(int VoucherType) {
    this.voucherType = VoucherType;
  }

  int getDiscountRate() {
    return this.discountRate;
  }

  void setDiscountRate(int DiscountRate) {
    this.discountRate = DiscountRate;
  }

  double getMinumumCondition() {
    return this.minimumConditon;
  }

  void setMinimumCondition(double MinimumCondition) {
    this.minimumConditon = MinimumCondition;
  }

  int getStartDate() {
    return this.startDate;
  }

  void setStartDate(int StartDate) {
    this.startDate = StartDate;
  }

  int getEndDate() {
    return this.endDate;
  }

  void setEndDate(int EndDate) {
    this.endDate = EndDate;
  }

  int getAvailable() {
    return this.available;
  }

  void setAvailable(int Available) {
    this.available = Available;
  }

  double getMaximumDiscountValue() {
    return this.maximumDiscountValue;
  }

  void setMaximumDiscountValue(double MaximumDiscountValue) {
    this.maximumDiscountValue = MaximumDiscountValue;
  }


  MVoucher.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('voucherID');
    voucherName = snapshot.get('voucherName');
    voucherCode = snapshot.get('voucherCode');
    voucherImage = snapshot.get('voucherImage');
    double intMinimumConditon = snapshot.get('minimumConditon') + .0;
    minimumConditon = intMinimumConditon.toDouble();
    startDate = snapshot.get('startDate');
    endDate = snapshot.get('endDate');
    available = snapshot.get('available');

    voucherType = snapshot.get('voucherType');
    if(voucherType == 1 || voucherType == 4) {
      double intMaximumDiscountValue = snapshot.get('maximumDiscountValue') + .0;
      maximumDiscountValue = intMaximumDiscountValue.toDouble();
    }

    else if(voucherType == 3) {
      double intMaximumDiscountValue = snapshot.get('maximumDiscountValue') + .0;
      maximumDiscountValue = intMaximumDiscountValue.toDouble();
      discountRate = snapshot.get('discountRate');
    }

  }
}