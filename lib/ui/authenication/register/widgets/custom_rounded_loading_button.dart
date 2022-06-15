import 'package:bebeautyapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CustomRoundedLoadingButton extends StatelessWidget {
  final String text;
  final RoundedLoadingButtonController controller;
  final void Function() onPress;
  final double horizontalPadding;
  const CustomRoundedLoadingButton(
      {required this.text,
      required this.onPress,
      required this.controller,
      this.horizontalPadding = 0});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 18),
      child: RoundedLoadingButton(
        controller: controller,
        onPressed: onPress,
        successColor: kPrimaryColor,
        height: 60,
        width: 9999,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        color: kPrimaryColor,
      ),
    );
  }
}
