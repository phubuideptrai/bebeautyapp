import 'package:bebeautyapp/repo/services/review_services.dart';
import 'package:flutter/material.dart';
import '../../model/MReview.dart';

class ReviewProvider with ChangeNotifier{

  ReviewServices reviewServices = ReviewServices();
  List<MReview> reviews = [];

  ReviewProvider.initialize() {
    loadReviews();
  }

  loadReviews() async{
    reviews = await reviewServices.getReviews();
    notifyListeners();
  }

  void addReviews(List<MReview> Reviews) {
    for(int i = 0; i < Reviews.length; i++) {
      reviews.add(Reviews[i]);
    }
    notifyListeners();
  }

}