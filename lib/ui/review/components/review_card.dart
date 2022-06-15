import 'package:bebeautyapp/model/user/MUser.dart';
import 'package:bebeautyapp/repo/providers/user_provider.dart';
import 'package:bebeautyapp/repo/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../constants.dart';
import '../../../model/MReview.dart';

class ReviewCard extends StatelessWidget {
  final Function onTap;
  final bool isLess;
  final MReview review;
  final MUser user;

  ReviewCard(
      {Key? key,
      required this.review,
      required this.onTap,
      required this.isLess,
      required this.user})
      : super(key: key);

  UserServices userServices = UserServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.0,
        bottom: 2.0,
        left: 16.0,
        right: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                    child: user.avatarUri == ""
                        ? Container()
                        : Image.network(user.avatarUri, fit: BoxFit.cover)),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Row(children: [
                Text(
                  user.displayName != "" ? user.displayName : "",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                Spacer(),
                Text(
                  review.date,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ])),
            ],
          ),
          SizedBox(height: 8.0),
          SmoothStarRating(
            isReadOnly: true,
            starCount: 5,
            rating: review.rating,
            size: 20.0,
            color: Color(0xFFFFC416),
            borderColor: Color(0xFFFFC416),
          ),
          SizedBox(height: 5.0),
          GestureDetector(
            onTap: () {},
            child: isLess
                ? Text(
                    review.comment,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kSecondaryColor,
                    ),
                  )
                : Text(
                    review.comment,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kLightColor,
                    ),
                  ),
          ),
          review.images.length == 0
              ? SizedBox(height: 1.0)
              : Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: GridView.builder(
                    itemCount: review.images.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 4,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        review.images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
