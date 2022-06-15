import 'package:bebeautyapp/constants.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatelessWidget {
  final AnimationController animationController;
  const WelcomeView({Key? key, required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget image_slider_carousel = Container(
      height: 360,
      width: double.infinity,
      child: Carousel(
        boxFit: BoxFit.cover,
        dotSize: 6.0,
        dotSpacing: 15.0,
        dotPosition: DotPosition.bottomCenter,
        images: [
          AssetImage("assets/images/introduction_bg.png"),
          AssetImage("assets/images/intro_background.png"),
        ],
      ),
    );

    final _firstHalfAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.6,
          0.8,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    final _secondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          0.8,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    final _welcomeFirstHalfAnimation =
        Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));

    final _welcomeImageAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: _firstHalfAnimation,
      child: SlideTransition(
        position: _secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SlideTransition(
              //   position: _welcomeImageAnimation,
              //   child: Container(
              //     // constraints: BoxConstraints(maxWidth: 350, maxHeight: 350),
              //     child: image_slider_carousel
              //   ),
              // ),
              SlideTransition(
                  position: _welcomeFirstHalfAnimation,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 36),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 360,
                          ),
                          Text.rich(TextSpan(
                              text: 'Welcome to\n',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Laila',
                                  color: kTextColor,
                                  fontWeight: FontWeight.w500),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: 'The world of\n',
                                  style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Laila',
                                      color: kTextColor),
                                ),
                                TextSpan(
                                  text: 'LaMuse',
                                  style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: 'Laila',
                                      color: kPrimaryColor),
                                )
                              ])),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
