import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MBrand.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MReview.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/ui/home/details/details_screen.dart';
import 'package:bebeautyapp/ui/home/cart/cart_screens.dart';

import 'package:bebeautyapp/ui/home/homes/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DetailsBrand extends StatelessWidget {
  final MBrand brand;
  final List<MProduct> allProductsFromBrand;

  final reviewServices = new ReviewServices();
  final preferenceServices = new PreferenceServices();
  final productServices = new ProductServices();

  DetailsBrand(
      {Key? key, required this.brand, required this.allProductsFromBrand})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: kPrimaryColor,
        ),
        title: Text(
          brand.name,
          style: TextStyle(color: kPrimaryColor, fontSize: 18),
        ),
        centerTitle: true,
        actions: <Widget>[
          // IconButton(
          //   icon: SvgPicture.asset(
          //     "assets/icons/search.svg",
          //     // By default our  icon color is white
          //     color: kTextColor,
          //   ),
          //   onPressed: () {
          //     // showSearch(context: context, delegate: DataSearch(products, suggestProducts, brands));
          //   },
          // ),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 153,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: GridView.builder(
                          itemCount: allProductsFromBrand.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: kDefaultPadding,
                            crossAxisSpacing: kDefaultPadding,
                            childAspectRatio: 0.5,
                          ),
                          itemBuilder: (context, index) => ProductCard(
                            rating: true,
                            product: allProductsFromBrand[index],
                            press: () async {
                              // productProvider
                              //         .isNeededUpdated_SimilarProductsBasedUserByCBR =
                              //     true;
                              // await preferenceServices.updatePreference(
                              //     userProvider.user,
                              //     allProductsFromBrand[index]);

                              //productProvider.isNeededUpdated_SimilarProductsByCFR = true;
                              //await preferenceServices.updatePreference(userProvider.user, products[index]);

                              // List<MProduct>
                              //     similarProductsFromSelectedProducts =
                              //     await productServices
                              //         .getSimilarityProductsBySelectedProduct(
                              //             productProvider.products,
                              //             allProductsFromBrand[index]);

                              List<MReview> reviewsOfProduct =
                                  reviewServices.getReviewOfProduct(
                                      reviewProvider.reviews,
                                      allProductsFromBrand[index].id);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // builder: (context) => DetailsScreen(
                                    //   product: products[index],
                                    // ),
                                    builder: (context) => DetailsScreen(
                                      product: allProductsFromBrand[index],
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

            // const SizedBox(
            //   height: MediaQuery.of(context).size.height,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            //     child: GridView.builder(
            //       itemCount: brandProvider.brands.length,
            //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //         crossAxisCount: 2,
            //         mainAxisSpacing: kDefaultPadding,
            //         crossAxisSpacing: kDefaultPadding,
            //         childAspectRatio: 1.15,
            //       ),
            //       itemBuilder: (context, index) => ProductCard(
            //         product: brandProvider.brands[index].,
            //
            //         press: (){Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //               builder: (context) => DetailsBrand(
            //                 brand: brandProvider.brands[index],
            //               ),
            //             ));},
            //       ),
            //     ),
            //   ),
            //
            // ),
          ),
        ],
      ),
    );
  }
}
