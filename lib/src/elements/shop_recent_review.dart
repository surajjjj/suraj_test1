import 'package:flutter/material.dart';

import '../models/shop_rating.dart';
import 'review_widget.dart';




// ignore: must_be_immutable
class ShopRecentReviewBox extends StatefulWidget {
  List<ShopRatingModel> reviewList;
  ShopRecentReviewBox({Key key, this.reviewList}) : super(key: key);
  @override
  State<ShopRecentReviewBox> createState() => _ShopRecentReviewBoxState();
}

class _ShopRecentReviewBoxState extends State<ShopRecentReviewBox> {



  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height:230,
        child:ListView.builder(
          itemCount:  widget.reviewList.length,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.only(right: 20),
          itemBuilder: (context, index) {
            return ReviewBox1(ratingDetails: widget.reviewList.elementAt(index));
          },
        ));
  }
}


