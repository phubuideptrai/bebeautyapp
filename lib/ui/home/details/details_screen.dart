import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MReview.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/ui/home/details/widgets/cart_counter.dart';

import 'package:bebeautyapp/ui/home/cart/cart_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/ui/home/details/widgets/body.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../repo/providers/cart_provider.dart';
import '../../../repo/providers/product_provider.dart';
import '../../../repo/providers/user_provider.dart';
import '../../../repo/services/product_services.dart';

class DetailsScreen extends StatelessWidget {
  final MProduct product;
  //final List<MProduct> similarProductsFromSelectedProducts;
  final List<MReview> reviewsOfProduct;

  final productServices = new ProductServices();

  final ScrollController _scrollController = ScrollController();

  DetailsScreen(
      {Key? key,
      required this.product,
      //required this.similarProductsFromSelectedProducts,
      required this.reviewsOfProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    bool isFavorite = productServices.checkFavorite(
        userProvider.user.getID(), product.getUserFavorite());

    void addToCartDrawer(BuildContext context, MProduct product) {
      ProductServices productServices = new ProductServices();
      int quantity = 1;

      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0)),
          ),
          isDismissible: false,
          context: context,
          builder: (context) {
            return Container(
                height: 240.0,
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: AspectRatio(
                              aspectRatio: 0.88,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  //color: Color(0xFFF5F6F9),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Image.network(
                                  product.images[0],
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Text(product.price
                                        .toStringAsFixed(0)
                                        .toVND()),
                                    Spacer(),
                                    Text('Inventory: ' +
                                        product.available.toString()),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Row(
                      children: [
                        const Text("Number: "),
                        const Spacer(),
                        SizedBox(
                          width: 100,
                          child: CartCounter(
                            increaseBottonWidget: const Icon(Icons.add,
                                color: Colors.white,
                                size:
                                    20), // if you want to add custom add botton then here you can pass your custom widget.
                            decreaseBottonWidget: const Icon(Icons.remove,
                                color: Colors.white,
                                size:
                                    20), // if you want to add custom Remove botton then here you can pass your custom widget.

                            maximumValue: product.available,
                            minimumValue: 1,
                            value: 1,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                            isEnable:
                                true, //if you want to Enter custom value then here you should be enable.
                            onChanged: (val) {
                              //here in val variable you'll get updated counter value.
                              print(val);
                              quantity = val;
                            },
                          ),
                        ),
                      ],
                    ),
                    MaterialButton(
                      onPressed: () async {
                        MProduct currentProduct = await productServices
                            .getProductForRealTime(product);
                        if (currentProduct.available < quantity) {
                          Fluttertoast.showToast(
                              backgroundColor: Colors.red,
                              msg:
                                  "Sorry, this product don't have enough quantity in invertory to supply you.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM);
                        } else {
                          int totalQuantity = cartProvider.cart
                              .getQuantityOfProductInCart(product);
                          if (totalQuantity + quantity <=
                              currentProduct.available) {
                            cartProvider.addProductInCart(product, quantity);
                            Fluttertoast.showToast(
                                backgroundColor: Colors.green,
                                msg: "Add this product successfully.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else
                            Fluttertoast.showToast(
                                backgroundColor: Colors.red,
                                msg:
                                    "Sorry but the total quantity of this product you have added to your cart exceeds the quantity in stock we can supply.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                        }
                      },
                      color: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        "Add to cart",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ));
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context, isFavorite, userProvider.user.id),
      drawer: Drawer(),
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(children: [
            Body(
              product: product,
              // similarProductsFromSelectedProducts:
              //     similarProductsFromSelectedProducts,
              reviewsOfProduct: reviewsOfProduct,
            ),
          ])),
      floatingActionButton: FloatingActionButton(
        elevation: 0.5,
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.arrow_circle_up,
          color: Colors.white,
        ),
        onPressed: () {
          _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn);
        },
      ),
      bottomNavigationBar: Material(
        elevation: kLess,
        color: Colors.white,
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 8.0, left: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: kPrimaryColor, width: 2.0),
              ),
              child: IconButton(
                icon: const Icon(Icons.add_shopping_cart, color: kPrimaryColor),
                onPressed: () async {
                  MProduct recheck_product =
                      await productServices.getProductForRealTime(product);
                  addToCartDrawer(context, recheck_product);
                },
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(right: 8.0),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: kPrimaryColor, width: 2.0),
            //   ),
            //   child: IconButton(
            //       icon: const Icon(Icons.chat, color: kPrimaryColor),
            //       onPressed: () {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(builder: (context) => Chat(user_id: '', chatRoomId: '', user_name: '',)),
            //           );
            //       }),
            // ),
            Expanded(
              child: Container(
                height: 52.0,
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor, width: 2.0),
                ),
                child: MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: kLessPadding),
                    color: kPrimaryColor,
                    textColor: Colors.white,
                    child: const Text("Buy Now",
                        style:
                            TextStyle(fontSize: 18.0, fontFamily: 'Poppins')),
                    onPressed: () {
                      cartProvider.addProductInCart(product, 1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context, bool isFavorite, String userID) {
    final productProvider = Provider.of<ProductProvider>(context);
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: const BackButton(
        color: kPrimaryColor,
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/heart.svg",
            color: isFavorite ? Color(0xFFFF4848) : Color(0xFFDBDEE4),
            // productServices.checkFavorite(
            //         userProvider.user.getID(),
            //         product.getUserFavorite())
            //     ? Color(0xFFFF4848)
            //     : Color(0xFFDBDEE4),
          ),
          onPressed: () async {
            bool result =
                await productServices.updateFavorite(product.getID(), userID);
            if (result == true) {
              productProvider.updateUserFavorite(userID, product.getID());
              Fluttertoast.showToast(
                  backgroundColor: Colors.green,
                  msg: 'Add it to your favorite list successfully',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM);
            } else {
              productProvider.updateUserFavorite(userID, product.getID());

              Fluttertoast.showToast(
                  backgroundColor: Colors.green,
                  msg: 'Remove it in your favorite list successfully',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM);
            }
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/cart.svg",
            color: kPrimaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
        ),
        const SizedBox(width: kDefaultPadding / 2)
      ],
    );
  }
}
