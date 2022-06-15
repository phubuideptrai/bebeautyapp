import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../constants.dart';

class ErrorOrder extends StatefulWidget {
  @override
  _ErrorOrder createState() => _ErrorOrder();
}

class _ErrorOrder extends State<ErrorOrder> {
  @override
  Widget build(BuildContext context) {
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
                child: SvgPicture.asset("assets/icons/error.svg")),
          ),
          const SizedBox(
            height: 32,
          ),
          const Text(
            "Sorry!!!",
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
              "We are sorry, but somthing went wrong. Don’t worry. It’s not your fault. Please check your connection and try again.",
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
          MaterialButton(
            onPressed: () {},
            color: kPrimaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Text(
              "Try again",
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  letterSpacing: -1,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
