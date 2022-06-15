import 'package:bebeautyapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashView extends StatefulWidget {
  final AnimationController animationController;

  const SplashView({Key? key, required this.animationController})
      : super(key: key);

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    final _introductionanimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0.0, -1.0))
            .animate(CurvedAnimation(
      parent: widget.animationController,
      curve: Interval(
        0.0,
        0.2,
        curve: Curves.fastOutSlowIn,
      ),
    ));
    return SlideTransition(
        position: _introductionanimation,
        child: Container(
          height: MediaQuery.of(context).size.height,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/intro_background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 47,
                ),
                Text(
                  "BE BEAUTY",
                  style: TextStyle(
                      fontSize: 36.0,
                      fontWeight: FontWeight.w800,
                      fontFamily: "Laila",
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 210,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    "Be You.\nBe Authentic.\nBe Beauty.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 48.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: "Laila",
                        color: kFourthColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 64, right: 64),
                  child: Text(
                    "Lorem ipsum dolor sit amet,consectetur adipiscing elit,sed do eiusmod tempor incididunt ut labore",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kFourthColor),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  child: InkWell(
                    onTap: () {
                      widget.animationController.animateTo(0.2);
                    },
                    child: Container(
                        height: 57,
                        width: 263,
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: kPrimaryColor,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Let's begin",
                              style: TextStyle(
                                fontSize: 24,
                                color: kTextColor,
                              ),
                            ),
                            Spacer(),
                            SvgPicture.asset(
                              "assets/icons/arrow_next.svg",
                            )
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
