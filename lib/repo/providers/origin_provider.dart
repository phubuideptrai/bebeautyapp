import 'package:flutter/material.dart';

import '../../model/MOrigin.dart';
import '../services/origin_services.dart';

class OriginProvider with ChangeNotifier {
  OriginServices originServices = OriginServices();
  List<MOrigin> origins = [];

  OriginProvider.initialize(){
    loadOrigins();
  }

  loadOrigins() async {
    origins = await originServices.getOrigins();
    notifyListeners();
  }
}