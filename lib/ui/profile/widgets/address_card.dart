import 'package:bebeautyapp/constants.dart';

import 'package:bebeautyapp/ui/profile/widgets/change_address.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/MAddress.dart';
import '../../../model/MSavedAddress.dart';
import '../../../repo/providers/user_provider.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    Key? key,
    required this.address,
  }) : super(key: key);

  final MSavedAddress address;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: ListTile(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChangeAddressScreen(
                      address: address,
                    )),
          ),
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        leading: Icon(
          Icons.location_on_outlined,
          color: kPrimaryColor,
        ),
        minLeadingWidth: 24,
        trailing: address.isDefault == true
            ? const Text(
                '[Default]',
                style: TextStyle(
                  color: kPrimaryColor,
                ),
              )
            : Text(''),
        title: Text(address.fullUserName),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(address.userPhone),
          Text(address.fullAddressName),
        ]),
      ),
    );
  }
}
