import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/product_details2.dart';
import '../controllers/product_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/vendor.dart';
import 'restaurant_product_box.dart';

// ignore: must_be_immutable
class ProductBox1Widget extends StatefulWidget {
  final List<ProductDetails2> productData;


  String km;
  int focusId;
  Vendor shopDetails;
  ProductBox1Widget({Key key, this.productData,  this.km,  this.focusId, this.shopDetails}) : super(key: key);
  @override
  ProductBox1WidgetState createState() => ProductBox1WidgetState();
}

class ProductBox1WidgetState extends StateMVC<ProductBox1Widget> {
  ProductController _con;

  ProductBox1WidgetState() : super(ProductController()) {
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.productData.length,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 1, right: 2,bottom:40),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return RestaurantProductBox(choice: widget.productData[index], con: _con,km: widget.km,shopDetails: widget.shopDetails,);
      },
    );
  }
}


