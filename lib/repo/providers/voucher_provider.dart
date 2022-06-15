import 'package:flutter/material.dart';

import '../../model/MVoucher.dart';
import '../services/voucher_services.dart';

class VoucherProvider with ChangeNotifier {
  VoucherServices originServices = VoucherServices();
  List<MVoucher> vouchers = [];

  VoucherProvider.initialize(){
    loadVouchers();
  }

  loadVouchers() async {
    vouchers = await originServices.getVouchers();
    notifyListeners();
  }

  void addVoucher(MVoucher voucher) {
    vouchers.add(voucher);
    notifyListeners();
  }
}