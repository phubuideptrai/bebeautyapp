
import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:bebeautyapp/repo/services/user_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../constants.dart';
import '../../model/MReview.dart';
import '../../repo/providers/review_provider.dart';
import 'components/defaultAppBar.dart';
import 'components/defaultBackButton.dart';
import 'components/review_card.dart';
// import '../../size_config.dart';


class Reviews extends StatefulWidget {
  int productID;
  List<MReview> reviews;

  Reviews({Key? key, required this.productID, required this.reviews}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  bool isMore = false;


  List<double> ratings = [];
  List<MUser> users = [];

  final reviewServices = ReviewServices();
  final userServices = UserServices();

  @override
  void initState() {
    super.initState();
    getUsersReview();

  }

  Future<void> getUsersReview() async {
    List<MUser> results = [];
    for(int i = 0; i < widget.reviews.length; i++) {
      MUser user = await userServices.getUser(widget.reviews[i].userID);
      bool isAdd = false;
      for(int j = 0; j < results.length; j++) {
        if(results[j].getID() == user.getID()) isAdd = true;
      }

      if(isAdd == true) results.add(user);
    }
    setState(() {
      users = results;
    });
  }

  @override
  Widget build(BuildContext context) {

    ratings = reviewServices.getRatings(widget.reviews);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: "Reviews", child: DefaultBackButton(),
      ),
      body: Column(
        children: [
          Container(
            color: kSecondaryColor.withOpacity(0.1),
            padding: EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: NumberFormat("0.#").format(ratings[0]/widget.reviews.length).toString(),
                            style: TextStyle(fontSize: 48.0, color: kPrimaryColor),
                          ),
                          TextSpan(
                            text: "/5",
                            style: TextStyle(
                              fontSize: 24.0,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SmoothStarRating(
                      starCount: 5,
                      rating: ratings[0]/widget.reviews.length,
                      size: 20.0,
                      color: Color(0xFFFFC416),
                      borderColor: Color(0xFFFFC416),
                    ),
                    SizedBox(height: 14.0),
                    Text(
                      "${widget.reviews.length} Reviews",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  width: 200.0,
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Text(
                            "${index + 1}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(width: 4.0),
                          Icon(Icons.star, color:  Color(0xFFFFC416)),
                          SizedBox(width: 8.0),
                          LinearPercentIndicator(
                            lineHeight: 6.0,
                            // linearStrokeCap: LinearStrokeCap.roundAll,
                            width: 100,
                            animation: true,
                            animationDuration: 2500,
                            percent: ratings[index],
                            progressColor: kPrimaryColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          users.length == 0
              ? Container()
              : Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(15),
              itemCount: widget.reviews.length,
              itemBuilder: (context, index) {
                return ReviewCard(
                  review: widget.reviews[index],
                  onTap: () => setState(() {
                    isMore = !isMore;
                  }),
                  isLess: isMore,
                  user: userServices.getUserForReview(users, widget.reviews[index].userID),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 2.0,
                  color: kAccentColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}