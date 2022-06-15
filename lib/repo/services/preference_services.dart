
import 'package:bebeautyapp/model/MPreference.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreferenceServices {
  final CollectionReference refPreference = FirebaseFirestore.instance.collection('Preference');

  //Create Preference Collection in Firebase Database
  Future<void> createPreference(MUser user_model) async {
    return await refPreference
        .doc(user_model.id)
        .set({'userID': user_model.address.userID,
      'brandHistory': user_model.preference.brandHistory,
      'skinTypeHistory': user_model.preference.skinTypeHistory,
      'categoryHistory': user_model.preference.categoryHistory,
      'sessionHistory': user_model.preference.sessionHistory,
      'structureHistory': user_model.preference.structureHistory
    });
  }

  //Get User's Preference
  Future<MPreference> getPreference(String userID) async {
    MPreference preference = new MPreference(userID: "", brandHistory: [], skinTypeHistory: [], categoryHistory: [], sessionHistory: [], structureHistory: []);
    await refPreference.where('userID', isEqualTo: userID).get().then((result) {
      for (DocumentSnapshot Preference in result.docs) {
        preference = MPreference.fromSnapshot(Preference);
        return preference;
      }
    });
    return preference;
  }

  Future<void> updatePreference(MUser user, MProduct product) async {
    user.preference.brandHistory.add(product.brandID);
    user.preference.skinTypeHistory.add(product.skinID);
    user.preference.categoryHistory.add(product.categoryID);
    user.preference.sessionHistory.add(product.sessionID);
    user.preference.structureHistory.add(product.structureID);

    if(user.preference.brandHistory.length > 50) {
      user.preference.brandHistory.removeAt(0);
    }
    if(user.preference.skinTypeHistory.length > 50) {
      user.preference.skinTypeHistory.removeAt(0);
    }
    if(user.preference.categoryHistory.length > 50) {
      user.preference.categoryHistory.removeAt(0);
    }
    if(user.preference.sessionHistory.length > 50) {
      user.preference.sessionHistory.removeAt(0);
    }
    if(user.preference.structureHistory.length > 50) {
      user.preference.structureHistory.removeAt(0);
    }

    await refPreference.doc(user.getID().toString()).update({
      'brandHistory': user.preference.brandHistory,
      'categoryHistory': user.preference.categoryHistory,
      'sessionHistory': user.preference.sessionHistory,
      'skinTypeHistory': user.preference.skinTypeHistory,
      'structureHistory': user.preference.structureHistory,
    });
  }

  MPreference createTemp(MUser user, List<MProduct> products) {
    //List<int> brandHistory = [products[products.length - 1].getBrandID(), products[products.length - 2].getBrandID(), products[products.length - 3].getBrandID(), products[products.length - 4].getBrandID(), products[products.length - 5].getBrandID(), products[products.length - 6].getBrandID(), products[products.length - 7].getBrandID(), products[products.length - 8].getBrandID(), products[products.length - 9].getBrandID(), products[products.length - 10].getBrandID()];
    List<int> brandHistory = [products[products.length - 1].getBrandID()];

    //List<int> skinTypeHistory = [products[products.length - 1].getSkinID(), products[products.length - 2].getSkinID(), products[products.length - 3].getSkinID(), products[products.length - 4].getSkinID(), products[products.length - 5].getSkinID(), products[products.length - 6].getSkinID(), products[products.length - 7].getSkinID(), products[products.length - 8].getSkinID(), products[products.length - 9].getSkinID(), products[products.length - 10].getSkinID()];
    List<int> skinTypeHistory = [products[products.length - 1].getSkinID()];

    //List<int> categoryHistory = [products[products.length - 1].getCategoryID(), products[products.length - 2].getCategoryID(), products[products.length - 3].getCategoryID(), products[products.length - 4].getCategoryID(), products[products.length - 5].getCategoryID(), products[products.length - 6].getCategoryID(), products[products.length - 7].getCategoryID(), products[products.length - 8].getCategoryID(), products[products.length - 9].getCategoryID(), products[products.length - 10].getCategoryID()];
    List<int> categoryHistory = [products[products.length - 1].getCategoryID()];

    //List<int> sessionHistory = [products[products.length - 1].getSessionID(), products[products.length - 2].getSessionID(), products[products.length - 3].getSessionID(), products[products.length - 4].getSessionID(), products[products.length - 5].getSessionID(), products[products.length - 6].getSessionID(), products[products.length - 7].getSessionID(), products[products.length - 8].getSessionID(), products[products.length - 9].getSessionID(), products[products.length - 10].getSessionID()];
    List<int> sessionHistory = [products[products.length - 1].getSessionID()];

    //List<int> structureHistory = [products[products.length - 1].getStructureID(), products[products.length - 2].getStructureID(), products[products.length - 3].getStructureID(), products[products.length - 4].getStructureID(), products[products.length - 5].getStructureID(), products[products.length - 6].getStructureID(), products[products.length - 7].getStructureID(), products[products.length - 8].getStructureID(), products[products.length - 9].getStructureID(), products[products.length - 10].getStructureID()];
    List<int> structureHistory = [products[products.length - 1].getStructureID()];

    MPreference preference = new MPreference(userID: user.getID(), brandHistory: brandHistory, skinTypeHistory: skinTypeHistory, categoryHistory: categoryHistory, sessionHistory: sessionHistory, structureHistory: structureHistory);
    return preference;
  }

}