import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MSavedAddress.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';
import 'package:bebeautyapp/ui/profile/widgets/sticky_label.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../repo/providers/savedAddress_provider.dart';
import '../../../repo/providers/user_provider.dart';
import '../../../repo/services/savedAddress_services.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({Key? key, required this.userID}) : super(key: key);

  final String userID;
  @override
  _AddAddressScreen createState() => _AddAddressScreen();
}

class _AddAddressScreen extends State<AddAddressScreen> {
  final formKey = GlobalKey<FormState>();

  final nameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String name = '';
  String phoneNumber = '';
  String address = '';
  double latitude = 0.0;
  double longitude = 0.0;
  bool isDefault = false;

  @override
  Widget build(BuildContext context) {
    final savedAddressProvider = Provider.of<SavedAddressProvider>(context);
    final savedAddressServices = new SavedAddressServices();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Add Address"),
          titleTextStyle: TextStyle(
              color: kPrimaryColor,
              fontSize: 16,
              fontFamily: 'Laila',
              fontWeight: FontWeight.w500),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: BackButton(color: kPrimaryColor),
        ),
        body: Form(
          key: formKey,
          child: Container(
            color: kTextLightColor.withOpacity(0.15),
            child: LayoutBuilder(
              builder:
                  (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Contact',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: kTextColor),
                              ),
                            ),
                          ),
                          StickyLabel(
                              text: 'Name',
                              textStyle: const TextStyle(
                                color: kTextLightColor,
                              )),
                          TextFormField(
                            focusNode: nameFocusNode,
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            cursorColor: kTextColor,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Name is empty';
                              }
                              return null;
                            },
                            controller: _nameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () => _nameController.clear()),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          StickyLabel(
                              text: 'Phone Number',
                              textStyle: const TextStyle(
                                color: kTextLightColor,
                              )),
                          TextFormField(
                            focusNode: phoneNumberFocusNode,
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            cursorColor: kTextColor,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Phone Number is empty';
                              }
                              return null;
                            },
                            controller: _phoneController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () => _phoneController.clear()),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Text(
                                'Address',
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    ?.copyWith(color: kTextColor),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            focusNode: addressFocusNode,
                            onChanged: (value) {
                              address = value;
                            },
                            cursorColor: kTextColor,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Address is empty';
                              }
                              return null;
                            },
                            controller: _addressController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () => _addressController.clear()),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                              color: kThirdColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onPressed: () async {
                                Position position =
                                    await _getGeoLocationPosition();
                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                        position.latitude, position.longitude);

                                Placemark place = placemarks[0];
                                setState(() {
                                  latitude = position.latitude;
                                  longitude = position.longitude;

                                  address =
                                      '${place.street}, ${place.subAdministrativeArea}, ${place.administrativeArea}';
                                });

                                var location =
                                    'Lat: ${position.latitude} , Long: ${position.longitude}';

                                _addressController.text = address;

                                Fluttertoast.showToast(
                                    backgroundColor: Colors.green,
                                    msg: 'Load address success!',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM);
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => MapView()),
                                // );

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => MapView()),
                                // );
                              },
                              child: const Text(
                                'Get current location',
                                style: TextStyle(color: Colors.white),
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 50,
                            color: Colors.white,
                            child: Row(
                              children: [
                                const Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    'Set default address',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      color: kTextColor,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: FlutterSwitch(
                                    height: 25.0,
                                    width: 50.0,
                                    padding: 4.0,
                                    toggleSize: 17.5,
                                    borderRadius: 15.0,
                                    activeColor: kPrimaryColor,
                                    value: isDefault,
                                    onToggle: (value) {
                                      setState(() {
                                        isDefault = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              //Validate
                              if (formKey.currentState!.validate()) {
                                if (latitude == 0.0 && longitude == 0.0) {
                                  Fluttertoast.showToast(
                                      backgroundColor: Colors.red,
                                      msg: 'This address is not valid.',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM);
                                } else {
                                  MSavedAddress result =
                                      await savedAddressServices
                                          .addSavedAddress(
                                              name,
                                              phoneNumber,
                                              address,
                                              this.widget.userID,
                                              false,
                                              latitude,
                                              longitude);
                                  if (result.id != "") {
                                    savedAddressProvider
                                        .addSavedAddress(result);
                                    setState(() {
                                      address = "";
                                      _addressController.text = address;

                                      phoneNumber = "";
                                      _phoneController.text = phoneNumber;

                                      name = "";
                                      _nameController.text = name;

                                      latitude = 0.0;
                                      longitude = 0.0;
                                    });
                                    Navigator.of(context).pop();
                                    Fluttertoast.showToast(
                                        backgroundColor: Colors.green,
                                        msg: 'Add new address succesfully.',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM);
                                  } else
                                    Fluttertoast.showToast(
                                        backgroundColor: Colors.red,
                                        msg: 'Some errors happened.',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM);
                                }
                              }
                            },
                            color: kPrimaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _deleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure to delete this Address?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _backDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update'),
          content: const Text(
              'Update has not been saved. Are you sure you want to cancel the change?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Exit'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
