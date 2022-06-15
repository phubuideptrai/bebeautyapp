import 'package:bebeautyapp/ui/home/homes/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../constants.dart';
import '../../../../repo/providers/user_provider.dart';
import '../order_checkout/myorder.dart';
import '../order_checkout/widget/order_details.dart';

class CompleteOrder extends StatefulWidget {
  @override
  _CompleteOrder createState() => _CompleteOrder();
}

class _CompleteOrder extends State<CompleteOrder> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: kPrimaryColor,
        ),
        title: Text("Check out"),
        titleTextStyle: TextStyle(
            color: kPrimaryColor,
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 48,
          ),
          Center(
            child: SizedBox(
                height: 164,
                width: 164,
                child: SvgPicture.asset("assets/icons/complete.svg")),
          ),
          const SizedBox(
            height: 32,
          ),
          const Text(
            "Congratulations!!!",
            style: TextStyle(
                fontSize: 24,
                fontFamily: "Laila",
                fontWeight: FontWeight.w600,
                letterSpacing: -1,
                color: kTextColor),
          ),
          const SizedBox(
            height: 32,
          ),
          const SizedBox(
            width: 220,
            child: Text(
              "Your order have been taken and is being attended to",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  letterSpacing: -1,
                  color: kTextColor),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyOrderScreen(index: 0, userID: userProvider.user.id)),
              );
            },
            color: kPrimaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "Track order",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  letterSpacing: -1,
                  color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 48,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              side: BorderSide(color: kPrimaryColor, width: 1),
            ),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text("Continue shopping",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    letterSpacing: -1,
                    color: kPrimaryColor)),
          ),
        ],
      ),
    );
  }
}
