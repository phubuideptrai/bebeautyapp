import 'package:flutter/material.dart';

class LoginWithButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final Color iconColor;
  final bool isOutLine;
  final Color textColor;
  final void Function() onPress;
  const LoginWithButton({
    required this.icon,
    required this.text,
    required this.color,
    required this.isOutLine,
    required this.iconColor,
    required this.textColor,
    required this.onPress,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: iconColor,
        ),
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: isOutLine
                  ? BorderSide(color: Colors.black54)
                  : BorderSide.none),
          minimumSize: Size(300, 46),
          primary: color,
        ),
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}