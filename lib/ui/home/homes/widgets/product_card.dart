import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProduct.dart';
import 'package:bebeautyapp/repo/providers/product_provider.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/product_services.dart';
import 'package:bebeautyapp/ui/home/details/details_screen.dart';

import 'package:bebeautyapp/ui/home/homes/widgets/best_sell/best_sell_screens.dart';
import 'package:bebeautyapp/ui/home/homes/widgets/star_rating.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  ProductCard({
    Key? key,
    required this.product,
    required this.press,
    required this.rating,
  }) : super(key: key);

  final MProduct product;
  final GestureTapCallback press;
  bool rating;

  @override
  Widget build(BuildContext context) {
    NumberFormat currencyformat = new NumberFormat("#,###,##0");
    final productServices = new ProductServices();
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 150,
        height: 300,
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(product.getImage(0)),
                Positioned(
                  right: -18,
                  top: -10,
                  child: Container(
                    padding: const EdgeInsets.only(left: 16.0),
                    alignment: Alignment.topRight,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 90 * 0.5833333333333334,
                          width: 90,
                          child: CustomPaint(
                            painter: RPSCustomPainter(),
                            size:
                                Size(90, (90 * 0.5833333333333334).toDouble()),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 38, top: 10),
                          child: Text(
                            product.defaultDiscountRate.toString() +
                                '%' +
                                '\nsale ',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      text: product.getName(),
                      style: const TextStyle(color: Colors.black)),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  currencyformat.format(product.getMarketPrice()) + 'đ',
                  style: const TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  currencyformat.format(product.getPrice()) + 'đ',
                  style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            rating
                ? Row(
                    children: [
                      StarRating(
                          rating: product.totalStarRating / product.totalRating,
                          size: 15),
                      Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () async {
                          bool result = await productServices.updateFavorite(
                              product.getID(), userProvider.user.getID());
                          if (result == true) {
                            productProvider.updateUserFavorite(
                                userProvider.user.getID(), product.getID());
                            Fluttertoast.showToast(
                                msg:
                                    'Add it to your favorite list successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            productProvider.updateUserFavorite(
                                userProvider.user.getID(), product.getID());
                            Fluttertoast.showToast(
                                msg:
                                    'Remove it in your favorite list successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            color: productServices.checkFavorite(
                                    userProvider.user.id,
                                    product.getUserFavorite())
                                ? kPrimaryColor.withOpacity(0.15)
                                : kSecondaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/heart.svg",
                            color: productServices.checkFavorite(
                                    userProvider.user.getID(),
                                    product.getUserFavorite())
                                ? Color(0xFFFF4848)
                                : Color(0xFFDBDEE4),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color(0xffFFD839)
      ..style = PaintingStyle.fill
      ..strokeWidth = 5;

    Path path0 = Path();
    path0.moveTo(size.width * 0.3750000, size.height * 0.2128571);
    path0.lineTo(size.width * 0.3755000, size.height * 1);
    path0.lineTo(size.width * 0.5825000, size.height * 0.8428571);
    path0.lineTo(size.width * 0.7920000, size.height * 1);
    path0.lineTo(size.width * 0.7910000, size.height * 0.2157143);
    path0.lineTo(size.width * 0.3750000, size.height * 0.2128571);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
