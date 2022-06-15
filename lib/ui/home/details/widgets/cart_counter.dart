import 'package:bebeautyapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class CartCounter extends StatefulWidget {
  /**
   * Minimum Value at Last User can Decrease.
   */
  int minimumValue;
  /**
   * Maximum Value at Last User can Increase.
   */
  int maximumValue;
  /**
   * Current Value.
   */
  int value;
  /**
   * Return updated value.
   */
  Function onChanged;
  /**
   * TextStyle of Counter.
   */
  TextStyle style;
  /**
   * For Enable Custom Enter value.
   */
  bool isEnable;

  /**
   * for Increase Botton Widget.
   */
  Widget increaseBottonWidget;
  /**
   * for Decrease Botton Widget.
   */
  Widget decreaseBottonWidget;
  CartCounter({
    required this.minimumValue,
    required this.maximumValue,
    required this.value,
    required this.onChanged,
    required this.style,
    required this.isEnable,
    required this.increaseBottonWidget,
    required this.decreaseBottonWidget,
  });

  @override
  _CartCounterState createState() => _CartCounterState(
        minimumValue,
        maximumValue,
        value,
        onChanged,
        style,
        isEnable,
        increaseBottonWidget,
        decreaseBottonWidget,
      );
}

class _CartCounterState extends State<CartCounter> {
  /**
   * Minimum Value at Last User can Decrease.
   */
  int minimumValue;
  /**
   * Maximum Value at Last User can Increase.
   */
  int maximumValue;
  /**
   * Current Value.
   */
  int value;
  /**
   * Return updated value.
   */
  Function onChanged;
  /**
   * TextStyle of Counter.
   */
  TextStyle style;
  /**
   * For Enable Custom Enter value.
   */
  bool isEnable;
  /**
   * for Increase Botton Widget.
   */
  Widget increaseBottonWidget;
  /**
   * for Decrease Botton Widget.
   */
  Widget decreaseBottonWidget;
  _CartCounterState(
    this.minimumValue,
    this.maximumValue,
    this.value,
    this.onChanged,
    this.style,
    this.isEnable,
    this.increaseBottonWidget,
    this.decreaseBottonWidget,
  );

  TextEditingController valueController = new TextEditingController();

  @override
  void initState() {
    valueController.text = value.toString();
    super.initState();
  }

/**
 * This function will be increase value of counter.
 */
  void _increase() {
    if (value < maximumValue) {
      // This Block will be true when current counter value will be less than maximum value.
      setState(() {
        value++; //increasing counter value.
      });
      valueController.text =
          value.toString(); //assigning updated coutner value to the text value.
      onChanged(value); // calling [onChanged] functions.
    }
  }

/**
 * This function will be decrease value of counter.
 */
  void _decrease() {
    if (value > minimumValue) {
      // This Block will be true when current counter value will be greater than minimum value.
      setState(() {
        value--; //Decreasing counter value.
      });
      valueController.text =
          value.toString(); //assigning updated coutner value to the text value.
      onChanged(value); // calling [onChanged] functions.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Bounce(
              duration: const Duration(milliseconds: 110),
              onPressed: () {
                _decrease(); //calling _decrease() function when user will be tap on - icon.
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Icon(
                      Icons.remove,
                      size: 20,
                      color: Colors.white,
                    ),
                  )),
            ),
            Flexible(
              child: Container(
                alignment: Alignment.center,
                child: TextField(
                    keyboardType: TextInputType.number,
                    onEditingComplete: () {
                      if (valueController.text.isEmpty) {
                        setState(() {
                          value = minimumValue;
                          valueController.text = minimumValue.toString();
                          onChanged(value);
                        });
                      }
                    },
                    enabled: isEnable,
                    controller: valueController,
                    autofocus: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      //  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    ),
                    style: //Applying given textStyle.
                        TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty) {
                        //if Entered value on TextField will be Not Empty.
                        if (int.parse(val) < maximumValue) {
                          //if Entered Value will be not Greater than Maximum Value.
                          setState(() {
                            value = int.parse(
                                val); //Assigning Entered Value to the Counter Value.
                            valueController.text = value
                                .toString(); //assigning updated coutner value to the text value.
                          });
                          onChanged(
                              value); //Calling onChanged() function for get Updated Counter Value.
                        } else {
                          //if Entered Value will be more than maximum value then Maximum value will be assign.
                          setState(() {
                            value =
                                maximumValue; //Assigning Maximum value to the counter.
                            valueController.text = value
                                .toString(); //Assigning counter updated value to the value controller.
                          });
                          onChanged(
                              value); //calling onChanged() function for get updated counter value.
                        }
                      } else {
                        setState(() {
                          valueController.text = '';
                          //Assigning counter updated value to the value controller.
                        });
                        onChanged(value);
                      }
                    }),
              ),
            ),
            Bounce(
              duration: const Duration(milliseconds: 110),
              onPressed: () {
                _increase(); //calling _increase() function when user will be tap on + icon.
              },
              child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
