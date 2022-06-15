import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MReview.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/ui/home/details/details_screen.dart';

import 'package:bebeautyapp/ui/home/homes/widgets/best_sell/best_sell_screens.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../section_title.dart';

class BestSell extends StatelessWidget {
  final preferenceServices = new PreferenceServices();
  final productServices = new ProductServices();
  final reviewServices = new ReviewServices();
  late List<MProduct> products;
  BestSell(List<MProduct> Products) {
    this.products = Products;
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
              title: "Best sell",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BestSellScreen(products),
                    ));
              }),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                products.length,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ProductCard(
                      rating: true,
                      product: products[index],
                      press: () async {
                        // productProvider
                        //         .isNeededUpdated_SimilarProductsBasedUserByCBR =
                        //     true;
                        // await preferenceServices.updatePreference(
                        //     userProvider.user, products[index]);

                        //productProvider.isNeededUpdated_SimilarProductsByCFR = true;
                        //await preferenceServices.updatePreference(userProvider.user, products[index]);

                        // List<MProduct> similarProductsFromSelectedProducts =
                        //     await productServices
                        //         .getSimilarityProductsBySelectedProduct(
                        //             productProvider.products, products[index]);

                        List<MReview> reviewsOfProduct =
                            reviewServices.getReviewOfProduct(
                                reviewProvider.reviews, products[index].id);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (context) => DetailsScreen(
                              //   product: products[index],
                              // ),
                              builder: (context) => DetailsScreen(
                                product: products[index],
                                // similarProductsFromSelectedProducts:
                                //     similarProductsFromSelectedProducts,
                                reviewsOfProduct: reviewsOfProduct,
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
