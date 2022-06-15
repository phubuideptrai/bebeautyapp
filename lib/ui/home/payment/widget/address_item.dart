import 'package:bebeautyapp/constants.dart';

import 'package:flutter/material.dart';

import '../../../../model/MSavedAddress.dart';

class AddressItem extends StatefulWidget {
  final MSavedAddress savedAddress;

  const AddressItem({Key? key, required this.savedAddress}) : super(key: key);

  @override
  _AddressItemState createState() => _AddressItemState();
}

class _AddressItemState extends State<AddressItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: kFourthColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.savedAddress.fullUserName,
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.savedAddress.userPhone,
            style:
                TextStyle(fontWeight: FontWeight.w600, color: kTextLightColor),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.savedAddress.fullAddressName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(fontWeight: FontWeight.w600, color: kTextLightColor),
          ),
        ],
      ),
    );
  }
}
