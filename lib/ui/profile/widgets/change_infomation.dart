import 'dart:io';
import 'package:bebeautyapp/repo/services/image_services.dart';
import 'package:bebeautyapp/repo/services/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../repo/providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final formKey = GlobalKey<FormState>();
  String name = "";
  String phone = "";
  String email = "";

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool showPassword = false;

  String? filename;
  late String user_id;
  File? imageFile = null;

  final imageServices = ImageServices();
  final userServices = UserServices();

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user_model = Provider.of<UserProvider>(context);
    user_id = user_model.user.getID();
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/avt.png"),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.only(left: 16, top: 25, right: 16),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundImage: imageFile != null
                          ? Image.file(imageFile!, fit: BoxFit.cover).image
                          : Image.network(user_model.user.avatarUri,
                                  fit: BoxFit.cover)
                              .image,
                    ),
                    Positioned(
                      right: -16,
                      bottom: 0,
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(color: Colors.white),
                            ),
                            primary: Colors.white,
                            backgroundColor: Color(0xFFF5F6F9),
                          ),
                          onPressed: () {
                            _getFromGallery();
                          },
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "   Full name",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _nameController,
                            onChanged: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black)),
                                filled: true,
                                hintStyle:
                                    const TextStyle(color: Colors.black38),
                                prefixIcon:
                                    Icon(Icons.person, color: Colors.black),
                                hintText: user_model.user.getName()),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "   Phone number",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                phone = value;
                              });
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10),
                                fillColor: Colors.transparent,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide:
                                        const BorderSide(color: Colors.black)),
                                filled: true,
                                hintStyle:
                                    const TextStyle(color: Colors.black38),
                                prefixIcon:
                                    Icon(Icons.phone, color: Colors.black),
                                hintText: user_model.user.getPhone()),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "   Email",
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _emailController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide:
                                      const BorderSide(color: Colors.black)),
                              filled: true,
                              hintStyle: const TextStyle(color: Colors.black),
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.black),
                              hintText: user_model.user.email,
                            ),
                          ),
                        )
                      ]),
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      String image = "";
                      if (imageFile != null) {
                        image = await imageServices
                            .addImageAndReturnString(imageFile);
                        user_model.user.setAvatarURi(image);
                      }
                      if (name != "") {
                        user_model.user.setName(name);
                      }
                      if (phone != "") {
                        user_model.user.setPhone(phone);
                      }
                      bool result = await userServices
                          .updateUserInformation(user_model.user);
                      if (result == true) {
                        _nameController.text = "";
                        _phoneController.text = "";

                        user_model.getUser(user_id);

                        Fluttertoast.showToast(
                            msg: 'Updated your information successfully',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM);
                        Navigator.of(context).pop();
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Updated your information failed',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM);
                      }
                    },
                    color: kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
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
        ),
      ),
    );
  }
}
