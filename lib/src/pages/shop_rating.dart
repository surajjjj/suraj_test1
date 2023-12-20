import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../elements/rating_review_widget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../components/Shimmer/rectangular_loader_widget.dart';

// ignore: must_be_immutable
class RatingReviews extends StatefulWidget {
  int vendorid;
  RatingReviews({Key key, this.vendorid}) : super(key: key);
  @override
  RatingReviewsState createState() => RatingReviewsState();
}

class RatingReviewsState extends StateMVC<RatingReviews> {
  ProductController _con;
  RatingReviewsState() : super(ProductController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
   _con.listenForShopReview(widget.vendorid);
  }
  int dropDownValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.background
        ),
        title: Text(S.of(context).reviews,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
      body:(_con.shopReviewList.isEmpty)?const RectangularLoaderWidget():SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
            children:[
              Container(
                  padding: const EdgeInsets.only(top:20,left:15,right:15,bottom:20,),
                  child: RatingsReviewWidget(reviewList: _con.shopReviewList)
              ),

            ]
        ),
      ),
    );
  }
}
