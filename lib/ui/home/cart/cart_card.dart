import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProductInCart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.productInCart,
  }) : super(key: key);

  final MProductInCart productInCart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(productInCart.getImage()),
            ),
          ),
        ),
        Container(
          width: 300,
          padding: const EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productInCart.getName(),
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    productInCart
                        .getPrice()
                        .toStringAsFixed(0)
                        .toVND(unit: 'đ'),
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                  Text('   x${productInCart.getQuantity()}',
                      style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
