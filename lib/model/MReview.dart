import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MReview {
  String id = "";
  List<String> images = [];
  int productID = 0;
  String userID = "";
  double rating = 0;
  String date = " ";
  String comment = " ";

  MReview() {}

  MReview.fromSnapshot(DocumentSnapshot snapshot) {
    id = snapshot.get('id');
    images = List.from(snapshot.get('images'));
    userID = snapshot.get('userID');
    productID = snapshot.get('productID');
    double intRating = snapshot.get('rating') + .0;
    rating = intRating.toDouble();
    date = formatTimestamp(snapshot.get("date"));
    comment = snapshot.get('comment');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'images': this.images,
      'userID': this.userID,
      'productID': this.productID,
      'rating': this.rating,
      'date': this.date,
      'comment': this.comment
    };
  }
}

String formatTimestamp(Timestamp timestamp) {
  var format = new DateFormat('dd/MM/yyyy hh:mm'); // 'hh:mm' for hour & min
  return format.format(timestamp.toDate());
}
