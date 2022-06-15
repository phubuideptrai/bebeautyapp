import 'package:bebeautyapp/model/MProduct.dart';

import 'package:flutter/material.dart';

import 'package:bebeautyapp/constants.dart';
import 'package:provider/provider.dart';

import '../../../../repo/providers/brand_provider.dart';
import '../../../../repo/providers/category_provider.dart';
import '../../../../repo/providers/origin_provider.dart';
import '../../../../repo/services/brand_services.dart';
import '../../../../repo/services/category_services.dart';
import '../../../../repo/services/gender_services.dart';
import '../../../../repo/services/origin_services.dart';
import '../../../../repo/services/session_services.dart';
import '../../../../repo/services/skin_services.dart';
import '../../../../repo/services/structure_services.dart';

class Description extends StatelessWidget {
  Description({
    Key? key,
    required this.product,
    required this.type,
  }) : super(key: key);

  final MProduct product;
  final String type;

  final brandServices = BrandServices();
  final originServices = OriginServices();
  final skinServices = SkinServices();
  final categoryServices = CategoryServices();
  final sessionServices = SessionServices();
  final structureServices = StructureServices();
  final genderServices = GenderServices();

  @override
  Widget build(BuildContext context) {
    final brandProvider = Provider.of<BrandProvider>(context);
    final originProvider = Provider.of<OriginProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    String description = "";

    int id = product.getID();

    String brand =
        brandServices.getBrandName(brandProvider.brands, product.getBrandID());

    String category = categoryServices.getCategoryName(
        categoryProvider.categories, product.getCategoryID());

    String origin = originServices.getOriginName(
        originProvider.origins, product.getOriginID());

    String skin = skinServices.getSkinName(product.getSkinID());

    String session = sessionServices.getSession(product.getSessionID());

    String structure =
        structureServices.getStructureName(product.getStructureID());

    String gender = genderServices.getGender(product.getGenderID());

    if (type == "product specifications") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Text(
          product.getDescription(),
          style: TextStyle(height: 1.5),
        ),
      );
    } else {
      if (type == "description") {
        description = product.getDescription();
      } else if (type == "chemical composition") {
        description = product.getChemicalComposition();
      } else if (type == "guideline") {
        description = product.getGuideLine();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
        child: Text(
          description,
          style: TextStyle(height: 1.5),
        ),
      );
    }
  }
}
