import 'package:animations/animations.dart';
import 'package:bebeautyapp/constants.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class TopBackSkipView extends StatelessWidget {
  final AnimationController animationController;
  final VoidCallback onBackClick;
  final VoidCallback onSkipClick;

  const TopBackSkipView({
    Key? key,
    required this.onBackClick,
    required this.onSkipClick,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget image_slider_carousel = Container(
      height: 360,
      child: Carousel(
        boxFit: BoxFit.cover,
        dotSize: 5.0,
        dotSpacing: 16.0,
        dotPosition: DotPosition.bottomCenter,
        images: [
          AssetImage("assets/images/product_detail.jpg"),
          AssetImage("assets/images/product_detail_1.jpg"),
        ],
        borderRadius: true,
        dotBgColor: Colors.transparent,
        dotColor: kTextColor,
        moveIndicatorFromBottom: 180.0,
        noRadiusForIndicator: true,
        indicatorBgPadding: 5.0,
      ),
    );

    final _signUpMoveAnimation =
        Tween<double>(begin: 0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    final _animation =
        Tween<Offset>(begin: Offset(0, -1), end: Offset(0.0, 0.0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    // final _backAnimation =
    //     Tween<Offset>(begin: Offset(0, 0), end: Offset(-2, 0))
    //         .animate(CurvedAnimation(
    //   parent: animationController,
    //   curve: Interval(
    //     0.6,
    //     0.8,
    //     curve: Curves.fastOutSlowIn,
    //   ),
    // ));
    final _skipAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(2, 0))
        .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(
        0.6,
        0.8,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
      position: _animation,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) => PageTransitionSwitcher(
            duration: const Duration(milliseconds: 480),
            reverse: _signUpMoveAnimation.value < 0.7,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                fillColor: Colors.transparent,
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.vertical,
              );
            },
            child: _signUpMoveAnimation.value > 0.7
                ? InkWell(
                    key: ValueKey('image slider'),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(0),
                      child: image_slider_carousel,
                    ),
                  )
                : InkWell(
                    key: ValueKey('skip view'),
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Container(
                        height: 58,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: onBackClick,
                                icon: Icon(Icons.arrow_back_ios_new_rounded),
                                //   ),
                              ),
                              SlideTransition(
                                position: _skipAnimation,
                                child: IconButton(
                                  onPressed: onSkipClick,
                                  icon: Text(
                                    'Skip',
                                    style: TextStyle(color: kTextColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
      ),
    );

    // return SlideTransition(
    //   position: _animation,
    //   child: Padding(
    //     padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    //     child: Container(
    //       height: 58,
    //       child: Padding(
    //         padding: const EdgeInsets.only(left: 8, right: 16),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //
    //             IconButton(
    //               onPressed: onBackClick,
    //               icon: Icon(Icons.arrow_back_ios_new_rounded),
    //               //   ),
    //             ),
    //             SlideTransition(
    //               position: _skipAnimation,
    //               child: IconButton(
    //                 onPressed: onSkipClick,
    //                 icon: Text('Skip',style: TextStyle(color: kTextColor),),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
