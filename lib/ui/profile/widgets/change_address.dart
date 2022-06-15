import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/repo/providers/savedAddress_provider.dart';
import 'package:bebeautyapp/repo/services/savedAddress_services.dart';
import 'package:bebeautyapp/ui/authenication/register/widgets/custom_rounded_loading_button.dart';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../model/MAddress.dart';
import '../../../model/MSavedAddress.dart';
import '../../../repo/providers/user_provider.dart';

class ChangeAddressScreen extends StatefulWidget {
  const ChangeAddressScreen({
    Key? key,
    required this.address,
  }) : super(key: key);

  final MSavedAddress address;

  @override
  _ChangeAddressScreen createState() => _ChangeAddressScreen();
}

class _ChangeAddressScreen extends State<ChangeAddressScreen> {
  final formKey = GlobalKey<FormState>();

  final nameFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  String address = '';
  String name = '';
  String phone = '';
  bool isDefault = false;
  double latitude = 0;
  double longitude = 0;
  final savedAddressServices = SavedAddressServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final savedAddressProvider = Provider.of<SavedAddressProvider>(context);

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
                onPressed: () async {
                  bool result = await savedAddressServices
                      .deleteSavedAddress(widget.address);
                  if (result == true) {
                    savedAddressProvider.deleteSavedAddress(widget.address);
                    Navigator.pop(context, 'OK');
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          automaticallyImplyLeading: true,
          title: const Text("Change Address"),
          titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.delete_forever_outlined),
              color: Colors.white,
              onPressed: () {
                _deleteDialog();
              },
            ),
          ],
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
                          const SizedBox(
                            height: 15,
                          ),
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
                              hintText: widget.address.fullUserName,
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _nameController.clear();
                                    setState(() {
                                      name = "";
                                    });
                                  }),
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
                          TextFormField(
                            focusNode: phoneNumberFocusNode,
                            onChanged: (value) {
                              setState(() {
                                phone = value;
                              });
                            },
                            cursorColor: kTextColor,
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Phone Number is empty';
                              }
                              return null;
                            },
                            controller: _phoneController,
                            decoration: InputDecoration(
                              hintText: widget.address.userPhone,
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _phoneController.clear();
                                    setState(() {
                                      phone = "";
                                    });
                                  }),
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
                              setState(() {
                                address = value;
                              });
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
                              hintText: widget.address.fullAddressName,
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _addressController.clear();
                                    setState(() {
                                      address = "";
                                      latitude = 0;
                                      longitude = 0;
                                    });
                                  }),
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
                              onPressed: () async {
                                Position position =
                                    await _getGeoLocationPosition();
                                LatLng location = new LatLng(
                                    position.latitude, position.longitude);
                                GetAddressFromLatLong(position);
                                _addressController.text = address;
                                setState(() {
                                  latitude = location.latitude;
                                  longitude = location.longitude;
                                });
                              },
                              color: kThirdColor,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text('Get Location')),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(height: 30),
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
                                    value: widget.address.isDefault,
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
                              if (isDefault == true) {
                                await savedAddressServices
                                    .updateDefaultSavedAddress(
                                        widget.address.id,
                                        widget.address.userID);
                              }

                              MSavedAddress temp = new MSavedAddress(
                                  widget.address.id,
                                  widget.address.userID,
                                  address,
                                  name,
                                  phone,
                                  false,
                                  false,
                                  latitude,
                                  longitude);
                              temp.setPhone(phone);
                              temp.setFullUserName(name);
                              temp.setFullAddressName(address);
                              temp.setLongitude(longitude);
                              temp.setLatitude(latitude);
                              bool result = await savedAddressServices
                                  .updateSavedAddress(temp);
                              if (result == true) {
                                setState(() {
                                  address = "";
                                  _addressController.clear();
                                  phone = "";
                                  _phoneController.clear();
                                  name = "";
                                  _nameController.clear();
                                  latitude = 0;
                                  longitude = 0;
                                });
                                await savedAddressProvider
                                    .getSavedAddresses(widget.address.userID);
                                Fluttertoast.showToast(
                                    msg: 'Updated this address successfully',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM);
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Updated this address failed',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM);
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
                                  color: kTextColor),
                            ),
                          ),
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

  Future<void> GetAddressFromLatLong(position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    print(place);

    setState(() {
      address =
          '${place.street}, ${place.subAdministrativeArea},${place.administrativeArea}';
    });
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
