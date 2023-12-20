import 'package:flutter/material.dart';
import 'package:foodzo/src/elements/review_box2_widget.dart';
import 'package:foodzo/src/models/shop_rating.dart';



// ignore: must_be_immutable
class RatingsReviewWidget extends StatefulWidget {
  List<ShopRatingModel> reviewList;
  RatingsReviewWidget({Key key, this.reviewList}) : super(key: key);
  @override
  State<RatingsReviewWidget> createState() => _RatingsReviewWidgetState();
}

class _RatingsReviewWidgetState extends State<RatingsReviewWidget> {



  @override
  Widget build(BuildContext context) {
    return  ListView.separated(
      scrollDirection: Axis.vertical,
      itemCount: widget.reviewList.length,
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.only(top: 0),
      itemBuilder: (context, int index) {
        return  ReviewBox2(review: widget.reviewList[index],);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height:7);
      },
    );
  }
}


