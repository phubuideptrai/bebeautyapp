import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProductInCart.dart';
import 'package:bebeautyapp/model/MVoucher.dart';
import 'package:bebeautyapp/repo/providers/cart_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/cart_services.dart';
import 'package:bebeautyapp/ui/home/cart/grid_item.dart';

import 'package:bebeautyapp/ui/home/payment/payment_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

import '../../../repo/services/voucher_services.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreen createState() => new _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  List<MProductInCart> selectedList = [];
  final cartServices = new CartServices();
  final voucherServices = new VoucherServices();
  String voucherCode = "";
  TextEditingController _voucherController = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(color: kPrimaryColor),
        title: Text(
          selectedList.length < 1
              ? "Cart"
              : "${selectedList.length} item selected",
          style: TextStyle(
            fontFamily: "Laila",
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kPrimaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (selectedList.length > 0) {
                cartProvider.removeProductsInCart(
                    cartProvider.cart, selectedList);
                setState(() {
                  selectedList = [];
                });
              } else {
                showDialogForRemove(context);
              }
            },
            icon: const Icon(
              Icons.delete_outlined,
              color: kPrimaryColor,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: cartProvider.cart.products.isNotEmpty
                ? GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: cartProvider.cart.products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 4,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      return GridItem(
                          productInCart: cartProvider.cart.products[index],
                          isSelected: (bool value) {
                            setState(() {
                              if (value) {
                                selectedList
                                    .add(cartProvider.cart.products[index]);
                              } else {
                                selectedList
                                    .remove(cartProvider.cart.products[index]);
                              }
                            });
                          },
                          key: Key(cartProvider.cart.products[index]
                              .getID()
                              .toString()));
                    })
                : Center(
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          child: SvgPicture.asset('assets/icons/not_order.svg'),
                        ),
                        Text('No Product In Cart!'),
                      ],
                    ),
                  ),
          ),
          Container(
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
                  offset: Offset(0, -15),
                  blurRadius: 20,
                  color: Color(0xFFDADADA).withOpacity(0.15),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset("assets/icons/receipt.svg"),
                      ),
                      Spacer(),
                      Container(
                        width: 200,
                        child: TextField(
                          controller: _voucherController,
                          style:
                              TextStyle(color: kTextLightColor, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Add voucher here',
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              voucherCode = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total:\n",
                          children: [
                            TextSpan(
                              text: "\n" +
                                  cartServices
                                      .totalValueOfSelectedProductsInCart(
                                          selectedList)
                                      .toStringAsFixed(0)
                                      .toVND(),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: MaterialButton(
                            color: kPrimaryColor,
                            onPressed: () async {
                              if (selectedList.length > 0) {
                                MVoucher defaultVoucher = MVoucher();
                                if (voucherCode != "") {
                                  double totalValue = cartServices
                                      .totalValueOfSelectedProductsInCart(
                                          selectedList);
                                  MVoucher voucher =
                                      await voucherServices.isValidVoucher(
                                          voucherCode,
                                          totalValue,
                                          userProvider.user.point);
                                  if (voucher.getID() != "") {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PaymentDetails(
                                          productsInCart: selectedList,
                                          voucher: voucher,
                                        ),
                                      ),
                                    );
                                  }
                                } else
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PaymentDetails(
                                        productsInCart: selectedList,
                                        voucher: defaultVoucher,
                                      ),
                                    ),
                                  );
                              }
                            },
                            child: Text(
                              'Check Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDialogForRemove(BuildContext) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Column(
              children: const [
                Icon(
                  Icons.announcement_outlined,
                  size: 40,
                  color: kPrimaryColor,
                ),
                Text(
                  'You have not select any item to delete!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        });
  }
}
