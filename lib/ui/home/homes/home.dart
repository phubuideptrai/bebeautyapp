import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/brand_provider.dart';
import 'package:bebeautyapp/repo/providers/category_provider.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/services/brand_services.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/home/cart/cart_screens.dart';

import 'package:bebeautyapp/ui/home/homes/search/search_screens.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/best_sell/best_sell.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/category/categories.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/brand/brand_card.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/new_product/new_product.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/recommend_product/recommend_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:provider/provider.dart';

import '../../../model/MBrand.dart';

class HomeScreens extends StatelessWidget {
  final productServices = new ProductServices();
  final brandServices = new BrandServices();

  List<MProduct> products = [];
  List<MProduct> suggestProducts = [];
  List<MBrand> brands = [];

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final brandProvider = Provider.of<BrandProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    List<MBrand> getBrandList() {
      return brandProvider.brands;
    }

    List<MProduct> getSuggestionProductList() {
      productProvider.loadSuggestionBooks();
      return productProvider.sugesstionProducts;
    }

    List<MProduct> getProductList() {
      return productProvider.products;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/icons/search.svg",
            color: kPrimaryColor,
          ),
          onPressed: () {
            showSearch(
                context: context,
                delegate: DataSearch(getProductList(),
                    getSuggestionProductList(), getBrandList()));
          },
        ),
        title: kAppNameTextPinksm,
        centerTitle: true,
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
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                height: MediaQuery.of(context).size.height / 3,
                child: Carousel(
                  images: const [
                    NetworkImage(
                        'https://cf.shopee.vn/file/dac4992cd9609052f3c50ab4f7caa096_xxhdpi'),
                    NetworkImage(
                        'https://cf.shopee.vn/file/c64e8430deec41e474be2c15e128fb9b_xxhdpi'),
                    NetworkImage(
                        'https://cf.shopee.vn/file/9effbe0829a3f513afe65109b40d1aa1_xxhdpi')
                  ],
                  boxFit: BoxFit.fill,
                  showIndicator: false,
                  borderRadius: false,
                  moveIndicatorFromBottom: 180.0,
                  noRadiusForIndicator: true,
                  radius: Radius.circular(30.0),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 60,
            ),

            Categories(categoryProvider.categories),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            BrandCard(brandServices.getTop5Brand(brandProvider.brands)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            BestSell(productServices
                .getTop10BestSellerProduct(productProvider.products)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            //RecommendProduct(),
            //RecommendProduct(productProvider.similarProductsByCFR),

            NewProduct(
                productServices.getTop10NewProducts(productProvider.products)),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
          ],
        ),
      ),
    );
  }
}
