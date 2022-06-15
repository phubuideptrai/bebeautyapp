import 'package:bebeautyapp/model/MSavedAddress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SavedAddressServices {
  final CollectionReference refSavedAddress = FirebaseFirestore.instance.collection('SavedAddress');

  //Create Saved Address Collection in Firebase Database
  Future<MSavedAddress> addSavedAddress(String fullUserName, String userPhone,String fullAddressName,
      String userID, bool isStore, double latitude, double longitude) async {

    MSavedAddress temp = new MSavedAddress("", "", "", "", "", false, false, 0.0, 0.0);
    try {

      String addressID = "";

      await refSavedAddress
          .doc()
          .set({'addressID': "", 'userID': userID, 'fullAddressName': fullAddressName,
        'fullUserName': fullUserName, 'userPhone': userPhone, 'isDefault': false,
        'isStore': isStore, 'latitude': latitude, 'longitude': longitude
      });

      await refSavedAddress.where('userID', isEqualTo: userID).get().then((result) {
        for (DocumentSnapshot SavedAddress in result.docs) {
          if(SavedAddress.get('addressID') == "") addressID = SavedAddress.id;
        }
      });

      if(addressID != "") {
        bool result = await updateSavedAddressID(addressID);
        if(result == true) {
          MSavedAddress result_SavedAddress = await getSavedAddressByAddressID(addressID);
          return result_SavedAddress;
        }
        else return temp;
      }
      else return temp;
    } catch (e) {
      print(e.toString());
      return temp;
    }
  }

  Future<List<MSavedAddress>> getSavedAddresses(String userID) async =>
      await refSavedAddress.where('userID', isEqualTo: userID).get().then((result) {
        List<MSavedAddress> savedAddresses = [];
        for (DocumentSnapshot SavedAddress in result.docs) {
          savedAddresses.add(MSavedAddress.fromSnapshot(SavedAddress));
        }
        return savedAddresses;
      });

  Future<MSavedAddress> getSavedAddressByAddressID(String addressID) async =>
      await refSavedAddress.where('addressID', isEqualTo: addressID).get().then((result) {
        List<MSavedAddress> savedAddresses = [];
        for (DocumentSnapshot SavedAddress in result.docs) {
          savedAddresses.add(MSavedAddress.fromSnapshot(SavedAddress));
        }
        return savedAddresses[0];
      });

  Future<MSavedAddress> getSavedAddressByStore() async =>
      await refSavedAddress.where('isStore', isEqualTo: true).get().then((result) {
        List<MSavedAddress> savedAddresses = [];
        for (DocumentSnapshot SavedAddress in result.docs) {
          savedAddresses.add(MSavedAddress.fromSnapshot(SavedAddress));
        }
        return savedAddresses[0];
      });

  void copySavedAddress(MSavedAddress savedAddress1, MSavedAddress savedAddress2) {
    savedAddress1.setID(savedAddress2.getID());
    savedAddress1.setFullAddressName(savedAddress2.getFullAddressName());
    savedAddress1.setFullUserName(savedAddress2.getFullUserName());
    savedAddress1.setPhone(savedAddress2.getPhone());
    savedAddress1.setUserID(savedAddress2.getUserID());
    savedAddress1.setIsDefault(savedAddress2.getIsDefault());
    savedAddress1.setIsStore(savedAddress2.getIsStore());
    savedAddress1.setLatitude(savedAddress2.getLatitude());
    savedAddress1.setLongitude(savedAddress2.getLongitude());
  }

  Future<bool> updateSavedAddressID(String addressID) async {
    try {
      await refSavedAddress.doc(addressID).update({'addressID': addressID});
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateDefaultSavedAddress(String addressID, String userID) async {
    try {
      List<MSavedAddress> savedAddresses = await getSavedAddresses(userID);
      for(int i = 0; i < savedAddresses.length; i++) {
        if(savedAddresses[i].getID() == addressID) {
          await refSavedAddress.doc(savedAddresses[i].getID()).update({'isDefault': true});
        }
        else {
          await refSavedAddress.doc(savedAddresses[i].getID()).update({'isDefault': false});
        }
      }

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateSavedAddress(MSavedAddress address) async {
    try {
      if(address.getFullAddressName() != "") await refSavedAddress.doc(address.getID()).update({'fullAddressName': address.getFullAddressName()});
      if(address.getFullUserName() != "") await refSavedAddress.doc(address.getID()).update({'fullUserName': address.getFullUserName()});
      if(address.getPhone() != "") await refSavedAddress.doc(address.getID()).update({'userPhone': address.getPhone()});
      if(address.getLatitude() > 0) await refSavedAddress.doc(address.getID()).update({'latitude': address.getLatitude()});
      if(address.getLongitude() > 0) await refSavedAddress.doc(address.getID()).update({'longitude': address.getLongitude()});

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> deleteSavedAddress(MSavedAddress address) async {
    try {
      await refSavedAddress.doc(address.getID()).delete();
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }


}