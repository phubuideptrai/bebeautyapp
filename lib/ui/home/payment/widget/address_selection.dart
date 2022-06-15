import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:bebeautyapp/ui/home/payment/widget/address_item.dart';

import 'package:bebeautyapp/ui/profile/widgets/address.dart';
import 'package:bebeautyapp/ui/profile/widgets/address_card.dart';
import 'package:bebeautyapp/ui/profile/widgets/change_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../repo/providers/savedAddress_provider.dart';
import '../../../../repo/providers/user_provider.dart';
import '../../../../repo/services/savedAddress_services.dart';

class AddressSelection extends StatefulWidget {
  @override
  _AddressSelection createState() => _AddressSelection();
}

class _AddressSelection extends State<AddressSelection> {
  final savedAddressServices = new SavedAddressServices();

  @override
  Widget build(BuildContext context) {
    final savedAddressProvider = Provider.of<SavedAddressProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Address Selection"),
        titleTextStyle: TextStyle(
            color: kPrimaryColor,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: savedAddressProvider.savedAddresses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: AddressItem(
                        savedAddress:
                            savedAddressProvider.savedAddresses[index],
                      ),
                      onTap: () async {
                        bool result = await savedAddressServices
                            .updateDefaultSavedAddress(
                                savedAddressProvider.savedAddresses[index]
                                    .getID(),
                                userProvider.user.id);
                        if (result == true) {
                          savedAddressProvider.updateDefaultSavedAddress(
                              savedAddressProvider.savedAddresses[index]
                                  .getID(),
                              userProvider.user.id);
                          Fluttertoast.showToast(
                              msg: 'Updated default address successfully.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM);
                          Navigator.pop(context,
                              savedAddressProvider.savedAddresses[index]);
                        }
                      });
                }),
          ),
          Card(
            color: Colors.white,
            child: MaterialButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddAddressScreen(userID: userProvider.user.id)),
                ),
              },
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Add new address",
                    style: TextStyle(
                        fontSize: 14, fontFamily: 'Poppins', color: kTextColor),
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Icon(
                      Icons.add,
                      size: 30,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
