import 'package:bebeautyapp/model/MBrand.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/brand/brand_screens.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/brand/details_brand.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrandCard extends StatelessWidget {
  late List<MBrand> brands;
  final productServices = new ProductServices();
  BrandCard(List<MBrand> Brands) {
    this.brands = Brands;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Popular Brands",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BrandScreens(),
                  ));
            },
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              brands.length,
              (index) {
                return SpecialOfferCard(
                  category: brands[index].getName(),
                  image: brands[index].getImage(),
                  numOfBrands: brands[index].productQuantity,
                  press: () {
                    List<MProduct> allProductsFromBrand =
                        productServices.getAllProductsFromBrand(
                            productProvider.products, brands[index].id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsBrand(
                            brand: brands[index],
                            allProductsFromBrand: allProductsFromBrand,
                          ),
                        ));
                  },
                );
              },
              // children: [
              //   SpecialOfferCard(
              //     image: brands[0].getImage(),
              //     category: brands[0].getName(),
              //     numOfBrands: brands[0].getProductQuantity(),
              //     press: () {},
              //   ),
              //   SpecialOfferCard(
              //     image: brands[1].getImage(),
              //     category: brands[1].getName(),
              //     numOfBrands: brands[1].getProductQuantity(),
              //     press: () {},
              //   ),
              //   SpecialOfferCard(
              //     image: brands[2].getImage(),
              //     category: brands[2].getName(),
              //     numOfBrands: brands[2].getProductQuantity(),
              //     press: () {},
              //   ),
              //   SpecialOfferCard(
              //     image: brands[3].getImage(),
              //     category: brands[3].getName(),
              //     numOfBrands: brands[3].getProductQuantity(),
              //     press: () {},
              //   ),
              //   SpecialOfferCard(
              //     image: brands[4].getImage(),
              //     category: brands[4].getName(),
              //     numOfBrands: brands[4].getProductQuantity(),
              //     press: () {},
              //   ),
              //   const SizedBox(width: 20),
              // ],
            ),
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: 130,
          height: 130,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfBrands Product")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
