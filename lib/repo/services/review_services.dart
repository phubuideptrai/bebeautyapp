import 'package:bebeautyapp/model/MReview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewServices {
  final CollectionReference refReview =
      FirebaseFirestore.instance.collection('Review');

  Future<List<MReview>> getReviews() async {
    List<MReview> reviews = [];
    await refReview.get().then((result) {
      for (DocumentSnapshot Review in result.docs) {
        reviews.add(MReview.fromSnapshot(Review));
      }
    });
    return reviews;
  }

  Future<bool> addReview(MReview newReview) async {
    try {
      DocumentReference docRef = refReview.doc();
      String newReviewID = docRef.id;

      await refReview.doc().set({
        'id': newReviewID,
        'comment': newReview.comment,
        'date': DateTime.now(),
        'images': newReview.images,
        'productID': newReview.productID,
        'rating': newReview.rating,
        'userID': newReview.userID
      });

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addReviews(List<MReview> newReviews) async {
    try {
      int iCount = 0;
      for (int i = 0; i < newReviews.length; i++) {
        addReview(newReviews[i]);
        iCount++;
      }

      if (iCount == newReviews.length)
        return true;
      else
        return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  List<MReview> getReviewOfProduct(List<MReview> reviews, int productID) {
    List<MReview> results = [];
    for (int i = 0; i < reviews.length; i++) {
      if (reviews[i].productID == productID) results.add(reviews[i]);
    }
    return results;
  }

  List<double> getRatings(List<MReview> reviews) {
    List<double> ratings = [];

    double totalRate = 0;
    double totalRate1 = 0;
    double totalRate2 = 0;
    double totalRate3 = 0;
    double totalRate4 = 0;
    double totalRate5 = 0;

    for (int i = 0; i < reviews.length; i++) {
      totalRate += reviews[i].rating;

      if (reviews[i].rating == 1) {
        totalRate1++;
      } else if (reviews[i].rating == 2) {
        totalRate2++;
      } else if (reviews[i].rating == 3) {
        totalRate3++;
      } else if (reviews[i].rating == 4) {
        totalRate4++;
      } else if (reviews[i].rating == 5) {
        totalRate5++;
      }
    }

    ratings.add(totalRate1 / reviews.length);
    ratings.add(totalRate2 / reviews.length);
    ratings.add(totalRate3 / reviews.length);
    ratings.add(totalRate4 / reviews.length);
    ratings.add(totalRate5 / reviews.length);

    return ratings;
  }
}
