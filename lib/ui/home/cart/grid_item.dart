import 'package:bebeautyapp/constants.dart';
import 'package:bebeautyapp/model/MProductInCart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

class GridItem extends StatefulWidget {
  final MProductInCart productInCart;
  final ValueChanged<bool> isSelected;

  const GridItem(
      {Key? key, required this.productInCart, required this.isSelected})
      : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: isSelected
                ? Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.check_box,
                      color: kPrimaryColor,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.check_box_outline_blank,
                      color: kPrimaryColor,
                    ),
                  ),
          ),
          Container(
            width: 120,
            child: Image.network(
              widget.productInCart.getImage(),
              fit: BoxFit.fill,
              colorBlendMode: BlendMode.color,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 162,
            padding: const EdgeInsets.only(top: 8, left: 8),
            //color: kPrimaryColor.withOpacity(isSelected ? 0.05 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productInCart.getName(),
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      widget.productInCart
                          .getPrice()
                          .toStringAsFixed(0)
                          .toVND(unit: 'đ'),
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: kPrimaryColor),
                    ),
                    Spacer(),
                    Text(" x${widget.productInCart.getQuantity()}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
