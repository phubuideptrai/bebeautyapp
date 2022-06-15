import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MReview.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/ui/home/details/details_screen.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/product_card.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/recommend_product/recommend_product_screens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../section_title.dart';

class RecommendProduct extends StatefulWidget {
  @override
  _RecommendProductState createState() => _RecommendProductState();
}

class _RecommendProductState extends State<RecommendProduct>
    with TickerProviderStateMixin {
  final preferenceServices = new PreferenceServices();
  final productServices = new ProductServices();
  final reviewServices = new ReviewServices();
  int length = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);

    if (userProvider.user.id != "") {
      if (productProvider.products.length > 10) {
        if (productProvider.isNeededUpdated_SimilarProductsBasedUserByCBR ==
            true) {
          productProvider.updateSimilarProductsBasedUserByCBR(
              productProvider.products, userProvider.user);
        }

        if (productProvider.similarProductsBasedUserByCBR.length > 10) {
          setState(() {
            length = 10;
          });
        }

        //if(productProvider.isNeededUpdated_SimilarProductsByCFR == true) {
        //productProvider.updateSimilarProductsByCFR(productProvider.products, userProvider.user);
        //}

        //if(productProvider.similarProductsByCFR.length > 10) {
        //setState(() {
        //length = 10;
        //});
        //}
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
              title: "Recommend product",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecommendProductScreen(
                          productProvider.similarProductsBasedUserByCBR),
                      //builder: (context) => RecommendProductScreen(productProvider.similarProductsByCFR),
                    ));
              }),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ProductCard(
                      rating: true,
                      product:
                          productProvider.similarProductsBasedUserByCBR[index],
                      //ProductCard(product: productProvider.similarProductsByCFR[index],
                      press: () async {
                        // productProvider
                        //         .isNeededUpdated_SimilarProductsBasedUserByCBR =
                        //     true;
                        // await preferenceServices.updatePreference(
                        //     userProvider.user,
                        //     productProvider
                        //         .similarProductsBasedUserByCBR[index]);

                        //productProvider.isNeededUpdated_SimilarProductsByCFR = true;
                        //await preferenceServices.updatePreference(userProvider.user, productProvider.similarProductsByCFR[index]);

                        // List<MProduct> similarProductsFromSelectedProducts =
                        //     await productServices
                        //         .getSimilarityProductsBySelectedProduct(
                        //             productProvider.products,
                        //             productProvider
                        //                 .similarProductsBasedUserByCBR[index]);

                        List<MReview> reviewsOfProduct =
                            reviewServices.getReviewOfProduct(
                                reviewProvider.reviews,
                                productProvider
                                    .similarProductsBasedUserByCBR[index].id);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => DetailsScreen(
                              //   product: products[index],
                              // ),
                              builder: (context) => DetailsScreen(
                                product: productProvider
                                    .similarProductsBasedUserByCBR[index],
                                // similarProductsFromSelectedProducts:
                                //     similarProductsFromSelectedProducts,
                                reviewsOfProduct: reviewsOfProduct,
                                //builder: (context) => DetailsScreen(product: productProvider.similarProductsByCFR[index],
                              ),
                            ));
                      },
                    ),
                  );
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        )
      ],
    );
  }
}
