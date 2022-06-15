import 'dart:io';

import 'package:badges/badges.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/ui/authenication/login/login_screen.dart';

import 'package:bebeautyapp/ui/home/payment/order_checkout/myorder.dart';
import 'package:bebeautyapp/ui/profile/widgets/address.dart';
import 'package:bebeautyapp/ui/profile/widgets/address_screens.dart';

import 'package:bebeautyapp/ui/profile/widgets/change_infomation.dart';
import 'package:bebeautyapp/ui/profile/widgets/change_password.dart';
import 'package:bebeautyapp/ui/profile/widgets/favorite_list_screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../repo/services/authentication_services.dart';
import '../../repo/services/order_services.dart';

class ProfileScreens extends StatefulWidget {
  @override
  _ProfileScreens createState() => _ProfileScreens();
}

class _ProfileScreens extends State<ProfileScreens> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    String user_id = userProvider.user.getID();
    final MUser user;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: kAppNameTextPinksm,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xffc1c2c6).withOpacity(0.2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(userProvider.user.getAvatarUri()),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ProfileMenu(
                text: "Purchase Order",
                icon: "assets/icons/menu-order.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyOrderScreen(
                              index: 0,
                              userID: userProvider.user.id,
                            )),
                  );
                },
              ),
              const SizedBox(
                height: 2,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    OrderMenu(
                      text: "Preparing",
                      icon: "assets/icons/check.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyOrderScreen(
                                  index: 1, userID: userProvider.user.id)),
                        );
                      },
                    ),
                    OrderMenu(
                      text: "Shipping",
                      icon: "assets/icons/package.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyOrderScreen(
                                  index: 2, userID: userProvider.user.id)),
                        );
                      },
                    ),
                    OrderMenu(
                      text: "Received",
                      icon: "assets/icons/delivery.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyOrderScreen(
                                  index: 3, userID: userProvider.user.id)),
                        );
                      },
                    ),
                    OrderMenu(
                      text: "Completed",
                      icon: "assets/icons/star-rate.svg",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyOrderScreen(
                                  index: 5, userID: userProvider.user.id)),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "My Profile",
                icon: "assets/icons/user_icon.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfileScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "My Address",
                icon: "assets/icons/location.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddressScreens()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "Favorite List",
                icon: "assets/icons/heart.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoriteListScreens()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "Change Password",
                icon: "assets/icons/settings.svg",
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()),
                  );
                },
              ),
              const SizedBox(height: 8),
              ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/log_out.svg",
                press: () {
                  signOutDrawer(context);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: kPrimaryColor,
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.white,
      ),
      onPressed: press,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            color: kPrimaryColor,
            width: 22,
          ),
          const SizedBox(width: 20),
          Expanded(child: Text(text)),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}

class OrderMenu extends StatelessWidget {
  const OrderMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;

  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    final orderServices = OrderServices();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: kPrimaryColor,
        ),
        onPressed: press,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: 24,
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
                child: Text(
              text,
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            )),
          ],
        ),
      ),
    );
  }
}

void signOutDrawer(BuildContext context) {
  final authServices = new AuthenticationServices();
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      isDismissible: false,
      context: context,
      builder: (context) {
        return Container(
          height: 150.0,
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Are you sure you want Logout ?',
                style: TextStyle(
                  color: kTextColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("NO",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      authServices.signOut();
                      await authServices.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false,
                      );
                    },
                    color: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "YES",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      });
}
