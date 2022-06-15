import 'package:bebeautyapp/model/MSavedAddress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../model/MVoucher.dart';

class VoucherServices {
  final CollectionReference refVoucher = FirebaseFirestore.instance.collection('Voucher');

  //Create Saved Address Collection in Firebase Database
  Future<bool> addVoucher(MVoucher voucher) async {
    try {
      await refVoucher
          .doc()
          .set({'voucherID': voucher.getID(), 'voucherName': voucher.getVoucherName(), 'voucherCode': voucher.getVoucherCode(),
              'voucherImage': voucher.getVoucherImage(), 'voucherType': voucher.getVoucherType(), 'minimumConditon':voucher.getMinumumCondition(),
              'startDate': voucher.getStartDate(), 'endDate': voucher.getEndDate(), 'available': voucher.getAvailable(),
              'maximumDiscountValue': voucher.getMaximumDiscountValue(), 'discountRate': voucher.getDiscountRate()
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<List<MVoucher>> getVouchers() async =>
      refVoucher.get().then((result) {
        List<MVoucher> vouchers = [];
        for (DocumentSnapshot Voucher in result.docs) {
          vouchers.add(MVoucher.fromSnapshot(Voucher));
        }
        return vouchers;
      });

  Future<MVoucher> isValidVoucher(String voucherCode, double totalValue, int userPoint) async {
    MVoucher defaultVoucher = MVoucher();
    try {
      bool isValid = false;
      List<MVoucher> vouchers = [];
      await refVoucher.where('voucherCode', isEqualTo: voucherCode).get().then((result) {
        for (DocumentSnapshot Voucher in result.docs) {
          vouchers.add(MVoucher.fromSnapshot(Voucher));
        }
      });

      if(vouchers.length > 0) {
        int now = DateTime.now().millisecondsSinceEpoch;
        if(vouchers[0].getAvailable() == 0) {
          isValid = false;
          Fluttertoast.showToast(
              msg: 'These vouchers were sold out.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
        }
        else if(now < vouchers[0].getStartDate()) {
          Fluttertoast.showToast(
              msg: 'This voucher has not been activated yet.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
          isValid = false;
        }

        else if(now > vouchers[0].getEndDate()) {
          Fluttertoast.showToast(
              msg: 'This voucher was expired.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
          isValid = false;
        }

        else if(totalValue < vouchers[0].getMinumumCondition().toDouble()) {
          Fluttertoast.showToast(
              msg: 'This order is not eligible to apply vouchers.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
          isValid = false;
        }
        else if(vouchers[0].getVoucherType() == 5 && userPoint < 100) {
          Fluttertoast.showToast(
              msg: 'This order is not eligible to apply vouchers.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
          isValid = false;
        }
        else isValid = true;
      }
      else {
        isValid = false;
        Fluttertoast.showToast(
            msg: 'This voucher is not existed.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
      }

      if(isValid == true) return vouchers[0];
      else return defaultVoucher;

    } catch (e) {
      print(e.toString());
      return defaultVoucher;
    }
  }

  double calculateVoucherDiscount(MVoucher voucher, double shippingValue, double totalValue) {
    if(voucher.getID() == "") return 0;
    else {
      if(voucher.getVoucherType() == 1) {
        if(shippingValue < voucher.getMaximumDiscountValue()) return shippingValue;
        else return voucher.getMaximumDiscountValue();
      }
      else if(voucher.getVoucherType() == 2) {
        return shippingValue;
      }
      else if(voucher.getVoucherType() == 3) {
        double discountValue = voucher.getDiscountRate() * totalValue / 100 ;
        if(discountValue < voucher.getMaximumDiscountValue()) return discountValue;
        else return voucher.getMaximumDiscountValue();
      }
      else if(voucher.getVoucherType() == 4) {
        return voucher.getMaximumDiscountValue();
      }
      else if(voucher.getVoucherType() == 5) {
        return totalValue;
      }
      else return 0;
    }

  }

  Future<int> getAvailableByVoucherID(String voucherID) async =>
      await refVoucher.doc(voucherID.toString()).get().then((result) {
        if(result.exists == true) return result.get('available');
        return -1;
      });

  Future<bool> updateAvailableByVoucherID(String voucherID) async {
    int available = await getAvailableByVoucherID(voucherID);
    if(available == -1) return false;
    else if(available - 1 < 0) {
      Fluttertoast.showToast(msg: 'This voucher was out of stock.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
      return false;
    }
    else {
      int now_available = available - 1;
      await refVoucher.doc(voucherID.toString()).update({'available': now_available});
      return true;
    }
  }

}