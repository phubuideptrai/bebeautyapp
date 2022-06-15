import 'dart:core';
import 'dart:io';
import 'dart:async';
import 'package:bebeautyapp/model/MProductInCart.dart';
import 'package:bebeautyapp/repo/services/image_services.dart';
import 'package:bebeautyapp/repo/services/order_services.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../../constants.dart';
import '../../../model/MReview.dart';
import '../../../repo/providers/review_provider.dart';
import 'defaultAppBar.dart';
import 'defaultBackButton.dart';



class AddReviewScreen extends StatefulWidget {
  static String routeName = "/addReivew";

  List<MProductInCart> products;
  String userID;
  String orderID;

  AddReviewScreen(
  {Key? key,
  required this.products,
  required this.userID,
  required this.orderID}) : super(key: key);

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  TextEditingController reviewcontroller = new TextEditingController();
  String comment = "";
  double rate = 1;

  final ImagePicker imagePicker = ImagePicker();
  List<File> fileImageArray = [];
  List<Asset> images = [];

  final imageServices = ImageServices();
  final reviewServices = ReviewServices();
  final orderServices = OrderServices();

  void selectImages() async {
    List<Asset> resultList = [];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "Be Beauty",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
    setState(() {
      images = resultList;
      fileImageArray = imageServices.convertAssetListToFileList(resultList);
    });
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: DefaultAppBar(
          title: 'Add review',
          child: DefaultBackButton(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: (20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(
                      (10)),
                  child:Column(
                      children: <Widget> [
                        fileImageArray.length == 0 ? SizedBox(height: 1) : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            itemCount: fileImageArray.length,
                            shrinkWrap: true,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                            itemBuilder: (BuildContext context, int index) {
                              return Image.file(
                                fileImageArray[index],
                                fit: BoxFit.cover,
                              );

                            },),),
                        // Padding(
                        //   padding: const EdgeInsets.all(16.0),
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     height: 200.0,
                        //     child: Center(
                        //       child: _image == null ? Text("No Image Selected!") : Image.file(_image!),
                        //     ),
                        //   ),
                        // ),
                        RaisedButton.icon(
                          label: Text('Add images',
                            style: TextStyle(color: Colors.white, fontSize: 14),),
                          icon: Icon(Icons.camera_enhance_rounded, color:Colors.white,size: 18,),
                          onPressed: () async {
                            selectImages();
                          },
                          color: kPrimaryColor,
                        ),

                      ])),

              SizedBox(
                height: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                    EdgeInsets.only(right: (
                        20)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Rate",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 79, 119, 45),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]
                    ),
                  ),
                  SmoothStarRating(
                    allowHalfRating: false,
                    starCount: 5,
                    rating: 1,
                    size: 30.0,
                    color: Color(0xFFFFC416),
                    borderColor: Color(0xFFFFC416),
                    onRated: (value) {
                      rate = value;
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 3.0,
              ),
              Padding(
                padding: EdgeInsets.all(
                    (10)),
                child: TextFormField(
                  controller: reviewcontroller,
                  onSaved: (newValue) => comment = newValue!,
                  onChanged: (value) {
                    comment = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Say something about the product",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),

              Padding(
                  padding: EdgeInsets.all(
                      (10)),
                  child: RaisedButton(
                      onPressed: ()  async {
                        if(fileImageArray.length < 1 && comment == "") {
                          Fluttertoast.showToast(msg: 'Please leave a comment or image before leaving a review.', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
                        }
                        else {
                          EasyLoading.show(status: 'Adding this review...');
                          List<MReview> newReviews = [];

                          List<String> urls = [];

                          if(fileImageArray.length > 0) {
                            urls = await imageServices.addImagesAndReturnStrings(fileImageArray);
                          }

                          for(int i = 0; i < widget.products.length; i++) {
                            MReview newReview = new MReview();
                            newReview.userID = widget.userID;
                            newReview.rating = rate;
                            newReview.date = DateFormat('dd/MM/yyyy hh:mm')
                                .format(DateTime.now());
                            newReview.productID = widget.products[i].id;
                            newReview.comment = comment;

                            if(fileImageArray.length > 0) {
                              newReview.images = urls;
                            }

                            newReviews.add(newReview);
                          }

                          bool result = await reviewServices.addReviews(newReviews);
                          if(result == false) {
                            EasyLoading.showError('Some errors happened when adding this review');
                            Future.delayed(const Duration(milliseconds: 1000), () {
                              EasyLoading.dismiss();
                            });
                          }
                          else {
                            bool result2 = await orderServices.updateOrderStatus(widget.orderID, 4);
                            if(result2 == false) {
                              EasyLoading.showError('Some errors happened when adding this review');
                              Future.delayed(const Duration(milliseconds: 1000), () {
                                EasyLoading.dismiss();
                              });
                            }
                            else {
                              reviewProvider.addReviews(newReviews);
                              EasyLoading.showSuccess('Added this review successfully');
                              Future.delayed(const Duration(milliseconds: 1000), () {
                                EasyLoading.dismiss();
                              });
                              Navigator.pop(context);
                            }
                          }

                        }
                      },
                      child:Text("Add Review")
                  )
              )

            ],
          ),
        ),)
    );
  }



}


