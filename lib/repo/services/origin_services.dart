import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/MOrigin.dart';

class OriginServices {
  final CollectionReference refOrigin = FirebaseFirestore.instance.collection(
      'Origin');

  Future<List<MOrigin>> getOrigins() async {
    List<MOrigin> origins = [];
    await refOrigin.orderBy('id', descending: false).get().then((result) {
      for (DocumentSnapshot Origin in result.docs) {
        origins.add(MOrigin.fromSnapshot(Origin));
      }
    });
    return origins;
  }

  String getOriginName(List<MOrigin> origins, int originID) {
    for(int i = 0; i < origins.length; i++) {
      if(origins[i].getID() == originID) return origins[i].getName();
    }
    return "";
  }
}