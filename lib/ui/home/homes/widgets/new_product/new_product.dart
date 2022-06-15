import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/model/MReview.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/preference_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/ui/home/details/details_screen.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/new_product/new_product_screen.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/product_card.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewProduct extends StatelessWidget {
  final preferenceServices = new PreferenceServices();
  final productServices = new ProductServices();
  final reviewServices = new ReviewServices();

  late List<MProduct> products;
  NewProduct(List<MProduct> Products) {
    this.products = Products;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final reviewProvider = Provider.of<ReviewProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SectionTitle(
            title: "New product",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewProductScreen(products),
                  ));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            spacing: 10, // gap between adjacent chips
            runSpacing: 25, // gap between lines
            direction: Axis.horizontal,
            children: List.generate(
              products.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ProductCard(
                    rating: true,
                    product: products[index],
                    press: () async {
                      // productProvider
                      //     .isNeededUpdated_SimilarProductsBasedUserByCBR = true;
                      // await preferenceServices.updatePreference(
                      //     userProvider.user, products[index]);
                      // await productProvider.updateSimilarProductsBasedUserByCBR(
                      //     productProvider.products, userProvider.user);

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
          ),
        ],
      ),
    );
  }
}
