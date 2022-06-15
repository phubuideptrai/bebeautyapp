import 'package:flutter/material.dart';
import 'package:bebeautyapp/ui/authenication/login/widgets/text_field_container.dart';
import 'package:bebeautyapp/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final TextInputType inputType;
  final FocusNode focusNode;
  final Function validator;
  final Function onFieldSubmitted;
  final TextEditingController textController;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.textController,
    required this.validator,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.inputType = TextInputType.visiblePassword,
    required this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        focusNode: focusNode,
        onChanged: onChanged,
        cursorColor: kTextColor,
        validator: (value) => validator (),
        controller: textController,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}