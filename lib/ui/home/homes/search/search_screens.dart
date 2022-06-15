import 'package:bebeautyapp/model/MReview.dart';
import 'package:bebeautyapp/repo/providers/review_provider.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../constants.dart';
import '../../../../model/MBrand.dart';
import '../../../../model/MProduct.dart';
import '../../../../repo/providers/product_provider.dart';
import '../../../../repo/services/product_services.dart';
import '../../details/details_screen.dart';

class DataSearch extends SearchDelegate<String> {
  List<MProduct> products = [];
  List<MProduct> suggestProducts = [];
  List<MBrand> brands = [];

  final reviewServices = new ReviewServices();

  DataSearch(List<MProduct> list1, List<MProduct> list2, List<MBrand> list3) {
    this.products = list1;
    this.suggestProducts = list2;
    this.brands = list3;
  }

  String getBrands(List<MBrand> list, int ID) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].getID() == ID) return list[i].getName();
    }
    return "";
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        color: kPrimaryColor,
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          color: kPrimaryColor,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final productServices = new ProductServices();
    final reviewProvider = Provider.of<ReviewProvider>(context);

    List<MProduct> results = [];

    if (query.isEmpty) {
      results = suggestProducts;
    } else {
      List<MProduct> list = [];
      for (int i = 0; i < products.length; i++) {
        String search_text = query.toLowerCase();
        String name = products[i].getName().toLowerCase();
        if (name.startsWith(search_text)) list.add(products[i]);
      }
      results = list;
    }
    return results.isNotEmpty
        ? ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) => ListTile(
                onTap: () async {
                  // List<MProduct> similarProductsFromSelectedProducts =
                  //     await productServices
                  //         .getSimilarityProductsBySelectedProduct(
                  //             productProvider.products, results[index]);

                  List<MReview> reviewsOfProduct =
                      reviewServices.getReviewOfProduct(
                          reviewProvider.reviews, results[index].id);

                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => DetailsScreen(
                        product: results[index],
                        // similarProductsFromSelectedProducts:
                        //     similarProductsFromSelectedProducts,
                        reviewsOfProduct: reviewsOfProduct,
                      ),
                    ),
                  );
                },
                leading: Image.network(results[index].images[1],
                    fit: BoxFit.cover), // image book
                title: RichText(
                  text: TextSpan(
                      text: results[index].getName().substring(0, query.length),
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text:
                              results[index].getName().substring(query.length),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        TextSpan(
                            text: '\n' +
                                getBrands(brands, results[index].getBrandID()) +
                                '\n \n',
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 16)),
                      ]),
                )))
        : Container(
            child: Center(
              child: Text('No product found!'),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final productServices = new ProductServices();
    final reviewProvider = Provider.of<ReviewProvider>(context);

    List<MProduct> results = [];

    if (query.isEmpty) {
      results = suggestProducts;
    } else {
      List<MProduct> list = [];
      for (int i = 0; i < products.length; i++) {
        String search_text = query.toLowerCase();
        String name = products[i].getName().toLowerCase();
        if (name.startsWith(search_text)) list.add(products[i]);
      }
      results = list;
    }
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) => ListTile(
            onTap: () async {
              List<MProduct> similarProductsFromSelectedProducts =
                  await productServices.getSimilarityProductsBySelectedProduct(
                      productProvider.products, results[index]);

              List<MReview> reviewsOfProduct =
                  reviewServices.getReviewOfProduct(
                      reviewProvider.reviews, results[index].id);

              Navigator.push<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                  builder: (BuildContext context) => DetailsScreen(
                    product: results[index],
                    // similarProductsFromSelectedProducts:
                    //     similarProductsFromSelectedProducts,
                    reviewsOfProduct: reviewsOfProduct,
                  ),
                ),
              );
            },
            leading: Image.network(results[index].images[1],
                fit: BoxFit.cover), // image book
            title: RichText(
              text: TextSpan(
                  text: results[index].getName().substring(0, query.length),
                  style: TextStyle(
                      color: kPrimaryColor, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: results[index].getName().substring(query.length),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                        text: '\n' +
                            getBrands(brands, results[index].getBrandID()) +
                            '\n \n',
                        style: TextStyle(color: kPrimaryColor, fontSize: 16)),
                  ]),
            )));
  }
}
