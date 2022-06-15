import 'package:flutter/material.dart';

import '../../../constants.dart';

class StickyLabel extends StatelessWidget {
  final String text;

  final TextStyle textStyle;
  const StickyLabel({
    required this.text,
    required this.textStyle,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: kFixPadding,
      ),
      child: Text(text, style: textStyle),
    );
  }
}
