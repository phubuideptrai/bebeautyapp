import 'dart:async';

import 'package:bebeautyapp/model/MProductInCart.dart';
import 'package:bebeautyapp/ui/home/cart/cart_card.dart';
import 'package:bebeautyapp/ui/home/payment/widget/address_selection.dart';
import 'package:bebeautyapp/ui/home/payment/widget/complete_order.dart';
import 'package:bebeautyapp/ui/profile/widgets/sticky_label.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';
import 'package:latlng/latlng.dart';
import 'package:provider/provider.dart';
import 'dart:math' show cos, sqrt, asin;
import '../../../constants.dart';
import '../../../model/MSavedAddress.dart';
import '../../../model/MVoucher.dart';
import '../../../repo/providers/cart_provider.dart';
import '../../../repo/providers/savedAddress_provider.dart';
import '../../../repo/providers/user_provider.dart';
import '../../../repo/services/cart_services.dart';
import '../../../repo/services/order_services.dart';
import '../../../repo/services/product_services.dart';
import '../../../repo/services/user_services.dart';
import '../../../repo/services/voucher_services.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails(
      {Key? key, required this.productsInCart, required this.voucher})
      : super(key: key);
  final List<MProductInCart> productsInCart;
  final MVoucher voucher;
  @override
  _PaymentDetailsState createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  final cartServices = new CartServices();
  final voucherServices = new VoucherServices();
  final productServices = new ProductServices();
  final orderServices = new OrderServices();
  final userServices = new UserServices();

  double voucherDiscount = 0;
  double totalValue = 0;
  double shippingValue = 0;
  double totalPayment = 0;

  MSavedAddress savedAddress =
      new MSavedAddress("", "", "", "", "", true, false, 0.0, 0.0);

  List<LatLng> polylineCoordinates = [];
  String? _placeDistance;
  bool isCalculate = true;

  FutureOr onGoBack(dynamic value) {
    setState(() {
      savedAddress.setID(value.getID());
      savedAddress.setFullAddressName(value.getFullAddressName());
      savedAddress.setFullUserName(value.getFullUserName());
      savedAddress.setPhone(value.getPhone());
      savedAddress.setUserID(value.getUserID());
      savedAddress.setIsDefault(value.getIsDefault());
      savedAddress.setIsStore(value.getIsStore());
      savedAddress.setLatitude(value.getLatitude());
      savedAddress.setLongitude(value.getLongitude());

      isCalculate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    totalValue =
        cartServices.totalValueOfSelectedProductsInCart(widget.productsInCart);
    final savedAddressProvider = Provider.of<SavedAddressProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    savedAddressProvider.getSavedAddresses(userProvider.user.id);

    if (isCalculate == true) {
      if (savedAddressProvider.store_SavedAddress.latitude != 0.0 &&
          savedAddressProvider.store_SavedAddress.longitude != 0.0 &&
          savedAddressProvider.defaultSavedAddress.latitude != 0.0 &&
          savedAddressProvider.defaultSavedAddress.longitude != 0.0) {
        _calculateDistance(savedAddressProvider.store_SavedAddress,
            savedAddressProvider.defaultSavedAddress);
        totalPayment = totalValue + shippingValue + voucherDiscount;
      } else {
        setState(() {
          shippingValue = 0;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: BackButton(color: kPrimaryColor),
        title: Text(
          'Check out',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Poppins',
            color: kPrimaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddressSelection())).then(onGoBack);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Row(children: [
                SvgPicture.asset(
                  'assets/icons/location.svg',
                  color: kPrimaryColor,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      savedAddressProvider.defaultSavedAddress.fullUserName !=
                              ""
                          ? savedAddressProvider
                              .defaultSavedAddress.fullUserName
                          : "No information about user's full name",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      savedAddressProvider.defaultSavedAddress.userPhone != ""
                          ? savedAddressProvider.defaultSavedAddress.userPhone
                          : "No information about user's phone number",
                      style: TextStyle(fontSize: 16),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: Text(
                        savedAddressProvider
                                    .defaultSavedAddress.fullAddressName !=
                                ""
                            ? savedAddressProvider
                                .defaultSavedAddress.fullAddressName
                            : "No information about user's address",
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 16,
                ),
              ]),
            ),
          ),
          StickyLabel(
            text: "Product",
            textStyle: kPop400TextStyle,
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.productsInCart.length,
              itemBuilder: (context, index) =>
                  CartCard(productInCart: widget.productsInCart[index]),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/dollars.png',
                      color: kPrimaryColor,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      'Payment Option',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    const Spacer(),
                    const Text(
                      'Cash on Delivery',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Merchandise Subtotal',
                          style: TextStyle(
                              color: kTextLightColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Shipping Subtotal',
                          style: TextStyle(
                              color: kTextLightColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Voucher Discount',
                          style: TextStyle(
                              color: kTextLightColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total Payment',
                          style: TextStyle(
                              color: kTextColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          cartServices
                              .totalValueOfSelectedProductsInCart(
                                  this.widget.productsInCart)
                              .toStringAsFixed(0)
                              .toVND(unit: 'đ'),
                          style: const TextStyle(
                              color: kTextLightColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          shippingValue.toStringAsFixed(0).toVND(unit: 'đ'),
                          style: const TextStyle(
                              color: kTextLightColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          voucherDiscount.toStringAsFixed(0).toVND(unit: 'đ'),
                          style: const TextStyle(
                              color: kTextLightColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          totalPayment.toStringAsFixed(0).toVND(unit: 'đ'),
                          style: const TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.list_alt),
                const SizedBox(
                  width: 4,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('By clicking "Place Order", you are agreeing to'),
                    Text(
                      "BeBeauty's General Transaction Terms",
                      style: TextStyle(
                        color: kCopy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 30,
        ),
        // height: 174,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -15),
              blurRadius: 20,
              color: const Color(0xFFDADADA).withOpacity(0.15),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      text: "Total Payment:\n",
                      children: [
                        TextSpan(
                          text:
                              totalPayment.toStringAsFixed(0).toVND(unit: 'đ'),
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextButton(
                      onPressed: () async {
                        EasyLoading.show(status: 'Adding new order...');
                        double total =
                            cartServices.totalValueOfSelectedProductsInCart(
                                widget.productsInCart);
                        if (widget.voucher.getID() == "") {
                          //Update the current number of products
                          bool checkUpdateAvailableOfProducts =
                              await productServices
                                  .checkUpdateAvailableByProductID(
                                      widget.productsInCart);

                          if (checkUpdateAvailableOfProducts == true) {
                            //Add New Order
                            int time = DateTime.now().millisecondsSinceEpoch;
                            bool result = await orderServices.addOrder(
                                userProvider.user.id,
                                widget.voucher.getVoucherCode(),
                                voucherDiscount,
                                shippingValue,
                                totalPayment,
                                cartServices
                                    .totalQuantityOfSelectedProductsInCart(widget
                                        .productsInCart),
                                widget.productsInCart.length,
                                savedAddressProvider
                                    .defaultSavedAddress.fullAddressName,
                                savedAddressProvider
                                    .defaultSavedAddress.latitude,
                                savedAddressProvider
                                    .defaultSavedAddress.longitude,
                                savedAddressProvider
                                    .defaultSavedAddress.fullUserName,
                                savedAddressProvider
                                    .defaultSavedAddress.userPhone,
                                time,
                                widget.productsInCart);

                            if (result == true) {
                              cartProvider.resetCart();
                              double bonus = totalValue / 100000;
                              int intBonus = bonus.round();
                              await userServices.updatePoint(
                                  userProvider.user.id,
                                  userProvider.user.point,
                                  intBonus,
                                  "asc");

                              EasyLoading.showSuccess(
                                  'Added this book successfully');
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                EasyLoading.dismiss();
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CompleteOrder()),
                              );
                            } else {
                              EasyLoading.showError(
                                  'Some errors happened when adding this order.');
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                EasyLoading.dismiss();
                              });
                            }
                          } else {
                            EasyLoading.showError(
                                'Some errors happened when updating available of products.');
                            Future.delayed(const Duration(milliseconds: 1000),
                                () {
                              EasyLoading.dismiss();
                            });
                          }
                        } else {
                          MVoucher isValidVoucher =
                              await voucherServices.isValidVoucher(
                                  widget.voucher.voucherCode,
                                  total,
                                  userProvider.user.point);

                          if (isValidVoucher.getID() != "") {
                            //Update the current number of products
                            bool checkUpdateAvailableOfProducts =
                                await productServices
                                    .checkUpdateAvailableByProductID(
                                        widget.productsInCart);

                            //Update the available number of voucher
                            bool checkUpdateAvailableOfVoucher =
                                await voucherServices
                                    .updateAvailableByVoucherID(
                                        isValidVoucher.getID());

                            if (checkUpdateAvailableOfVoucher == true &&
                                checkUpdateAvailableOfProducts == true) {
                              //Add New Order
                              int time = DateTime.now().millisecondsSinceEpoch;
                              bool result = await orderServices.addOrder(
                                  userProvider.user.id,
                                  widget.voucher.getVoucherCode(),
                                  voucherDiscount,
                                  shippingValue,
                                  totalPayment,
                                  cartServices.totalQuantityOfSelectedProductsInCart(
                                      widget.productsInCart),
                                  widget.productsInCart.length,
                                  savedAddressProvider
                                      .defaultSavedAddress.fullAddressName,
                                  savedAddressProvider
                                      .defaultSavedAddress.latitude,
                                  savedAddressProvider
                                      .defaultSavedAddress.longitude,
                                  savedAddressProvider
                                      .defaultSavedAddress.fullUserName,
                                  savedAddressProvider
                                      .defaultSavedAddress.userPhone,
                                  time,
                                  widget.productsInCart);

                              if (result == true) {
                                cartProvider.resetCart();
                                double bonus = totalValue / 100000;
                                int intBonus = bonus.round();
                                await userServices.updatePoint(
                                    userProvider.user.id,
                                    userProvider.user.point,
                                    intBonus,
                                    "asc");

                                if (widget.voucher.getVoucherType() == 5) {
                                  await userServices.updatePoint(
                                      userProvider.user.id,
                                      userProvider.user.point,
                                      0,
                                      "desc");
                                }

                                EasyLoading.showSuccess(
                                    'Added this book successfully');
                                Future.delayed(
                                    const Duration(milliseconds: 1000), () {
                                  EasyLoading.dismiss();
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CompleteOrder()),
                                );
                              } else {
                                EasyLoading.showError(
                                    'Some errors happened when adding this order.');
                                Future.delayed(
                                    const Duration(milliseconds: 1000), () {
                                  EasyLoading.dismiss();
                                });
                              }
                            } else {
                              EasyLoading.showError(
                                  'Some errors happened when updating available of products or voucher.');
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                EasyLoading.dismiss();
                              });
                            }
                          }
                        }
                      },
                      child: Text(
                        'Place Order',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance(MSavedAddress store_SavedAdress,
      MSavedAddress default_SavedAddress) async {
    try {
      setState(() {
        polylineCoordinates = [];
      });
      // Use the retrieved coordinates of the current position,
      // instead of the address if the start position is user's
      // current position, as it results in better accuracy.
      double startLatitude = store_SavedAdress.latitude;
      double startLongitude = store_SavedAdress.longitude;

      double destinationLatitude = default_SavedAddress.latitude;
      double destinationLongitude = default_SavedAddress.longitude;
      print(default_SavedAddress.fullAddressName);

      String startCoordinatesString = '($startLatitude, $startLongitude)';
      String destinationCoordinatesString =
          '($destinationLatitude, $destinationLongitude)';

      print(
        'START COORDINATES: ($startLatitude, $startLongitude)',
      );
      print(
        'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      );
      polylineCoordinates.add(LatLng(startLatitude, startLongitude));
      polylineCoordinates
          .add(LatLng(destinationLatitude, destinationLongitude));

      // Calculating the distance between the start and the end positions
      // with a straight path, without considering any route
      // double distanceInMeters = await Geolocator.bearingBetween(
      //   startLatitude,
      //   startLongitude,
      //   destinationLatitude,
      //   destinationLongitude,
      // );

      double totalDistance = 0.0;
      // Calculating the total distance by adding the distance
      // between small segments
      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }

      setState(() {
        isCalculate = false;
        _placeDistance = totalDistance.toStringAsFixed(2);
        print('DISTANCE: $_placeDistance km');
        shippingValue = cartServices.calculateShippingValue(totalDistance);
        print('shipping: $shippingValue');
        voucherDiscount = 0 -
            voucherServices.calculateVoucherDiscount(
                widget.voucher, shippingValue, totalValue);
      });

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  /*double getDiscountValue(MVoucher voucher, double totalValue) {
    if(voucher.getVoucherType() == 1) {
      if(to)
    }
  }*/
}
