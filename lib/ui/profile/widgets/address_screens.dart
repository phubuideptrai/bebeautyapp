import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';

import 'package:bebeautyapp/ui/profile/widgets/address.dart';
import 'package:bebeautyapp/ui/profile/widgets/address_card.dart';
import 'package:bebeautyapp/ui/profile/widgets/change_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../constants.dart';
import '../../../model/MAddress.dart';
import '../../../repo/providers/savedAddress_provider.dart';
import '../../../repo/providers/user_provider.dart';
import '../../../repo/services/address_services.dart';

class AddressScreens extends StatefulWidget {
  @override
  _AddressScreens createState() => _AddressScreens();
}

class _AddressScreens extends State<AddressScreens> {
  @override
  Widget build(BuildContext context) {
    final savedAddressProvider = Provider.of<SavedAddressProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    savedAddressProvider.getSavedAddresses(userProvider.user.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Delivery Address"),
        titleTextStyle: TextStyle(
            color: kPrimaryColor,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: BackButton(color: kPrimaryColor),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: savedAddressProvider.savedAddresses.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Dismissible(
                  key: Key(
                      savedAddressProvider.savedAddresses[index].toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      savedAddressProvider.savedAddresses.removeAt(index);
                    });
                  },
                  background: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: kFourthColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Spacer(),
                        SvgPicture.asset("assets/icons/trash.svg"),
                      ],
                    ),
                  ),
                  child: AddressCard(
                      address: savedAddressProvider.savedAddresses[index]),
                ),
              ),
            ),
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
                    "    Add new address",
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
