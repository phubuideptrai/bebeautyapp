
import 'package:bebeautyapp/model/MSavedAddress.dart';
import 'package:bebeautyapp/repo/services/savedAddress_services.dart';
import 'package:flutter/material.dart';

class SavedAddressProvider with ChangeNotifier {
  SavedAddressServices savedAddressServices = SavedAddressServices();
  List<MSavedAddress> savedAddresses = [];
  MSavedAddress defaultSavedAddress = MSavedAddress("", "", "", "", "", false, false, 0.0, 0.0);
  MSavedAddress store_SavedAddress = MSavedAddress("", "", "", "", "", false, false, 0.0, 0.0);

  SavedAddressProvider.initialize(){
    loadStoreSavedAddress();
  }

  loadStoreSavedAddress() async {
    store_SavedAddress = await savedAddressServices.getSavedAddressByStore();
    notifyListeners();
  }

  getSavedAddresses(String userID) async {
    savedAddresses = await savedAddressServices.getSavedAddresses(userID);
    getDefaultSavedAddress();
    notifyListeners();
  }

  addSavedAddress(MSavedAddress savedAddress) async {
    if(savedAddress.isDefault == true) {
      for(int i = 0; i < savedAddresses.length; i++) {
        savedAddresses[i].isDefault = false;
      }
    }
    savedAddresses.add(savedAddress);
    notifyListeners();
  }

  deleteSavedAddress(MSavedAddress savedAddress) async {
    for(int i = 0; i < savedAddresses.length; i++) {
      if(savedAddress.id == savedAddresses[i].id) savedAddresses.removeAt(i);
    }
    notifyListeners();
  }

  updateDefaultSavedAddress(String addressID, String userID) {
    for(int i = 0; i < savedAddresses.length; i++) {
      if(savedAddresses[i].getID() == addressID) {
        savedAddresses[i].setIsDefault(true);
      }
      else {
        savedAddresses[i].setIsDefault(false);
      }
    }
    getDefaultSavedAddress();
    notifyListeners();
  }

  getDefaultSavedAddress() {
    for(int i = 0; i < savedAddresses.length; i++) {
      if(savedAddresses[i].isDefault == true) {
        savedAddressServices.copySavedAddress(defaultSavedAddress, savedAddresses[i]);
      }
    }
  }
}