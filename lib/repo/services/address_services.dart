
import 'package:bebeautyapp/model/MAddress.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddressServices {
  final CollectionReference refAddress = FirebaseFirestore.instance.collection('Address');

  //Create Address Collection in Firebase Database
  Future<void> createAddress(MUser user_model) async {
    return await refAddress
        .doc(user_model.id)
        .set({'userID': user_model.address.userID,
      'fullStreetName': user_model.address.fullStreetName,
      'latitude': user_model.address.latitude,
      'longitude': user_model.address.longitude
    });
  }

  //Get User's address
  Future<MAddress> getAddress(String userID) async {
    MAddress address = new MAddress(userID: "", fullStreetName: "", latitude: 0, longitude: 0);
    await refAddress.where('userID', isEqualTo: userID).get().then((result) {
      for (DocumentSnapshot Address in result.docs) {
        address = MAddress.fromSnapshot(Address);
        return address;
      }
    });
    return address;
  }



}