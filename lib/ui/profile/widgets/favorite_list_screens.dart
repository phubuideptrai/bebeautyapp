import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MReview.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/ui/home/cart/cart_screens.dart';
import 'package:bebeautyapp/ui/home/details/details_screen.dart';

import 'package:bebeautyapp/ui/home/homes/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class FavoriteListScreens extends StatelessWidget {
  final productServices = new ProductServices();
  List<MProduct> favoriteProducts = [];
  final reviewServices = new ReviewServices();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final productProvider = Provider.of<ProductProvider>(context);

    final reviewProvider = Provider.of<ReviewProvider>(context);

    if (productProvider.products.length > 10) {
      if (userProvider.user.id != "") {
        favoriteProducts = productServices.getFavoriteProducts(
            productProvider.products, userProvider.user);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Favorite List"),
        titleTextStyle: TextStyle(
            color: kPrimaryColor,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: BackButton(
          color: kPrimaryColor,
        ),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/cart.svg",
              // By default our  icon color is white
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 16),
                    child: Text(
                      favoriteProducts.length.toString() + " product",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: kTextLightColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: GridView.builder(
                        itemCount: favoriteProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: kDefaultPadding,
                          crossAxisSpacing: kDefaultPadding,
                          childAspectRatio: 0.5,
                        ),
                        itemBuilder: (context, index) => ProductCard(
                          rating: true,
                          product: favoriteProducts[index],
                          press: () async {
                            // List<MProduct> similarProductsFromSelectedProducts =
                            //     await productServices
                            //         .getSimilarityProductsBySelectedProduct(
                            //             productProvider.products,
                            //             favoriteProducts[index]);

                            List<MReview> reviewsOfProduct =
                                reviewServices.getReviewOfProduct(
                                    reviewProvider.reviews,
                                    favoriteProducts[index].id);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // builder: (context) => DetailsScreen(
                                  //   product: products[index],
                                  // ),
                                  builder: (context) => DetailsScreen(
                                    product: productServices
                                        .getTop10BestSellerProduct(
                                            productProvider.products)[index],
                                    // similarProductsFromSelectedProducts:
                                    //     similarProductsFromSelectedProducts,
                                    reviewsOfProduct: reviewsOfProduct,
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
