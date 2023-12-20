import 'package:flutter/material.dart';
import '../controllers/product_controller.dart';
import '../models/product_details2.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/vendor.dart';
import 'products_carousel_loader_widget.dart';
import 'restaurant_product_box.dart';
// ignore: must_be_immutable
class AddCartSliderWidget extends StatefulWidget {
  List<ProductDetails2> productList;
  Function callback;
  final int focusId;
  String searchType;
  Vendor vendor;
  AddCartSliderWidget({Key key, this.productList,this.vendor, this.callback, this.focusId, this.searchType}) : super(key: key);

  bool loader;
  @override
  AddCartSliderWidgetState createState() => AddCartSliderWidgetState();
}

class AddCartSliderWidgetState extends StateMVC<AddCartSliderWidget> {

  ProductController _con;
  AddCartSliderWidgetState() : super(ProductController()) {
    _con = controller;

  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  widget.productList.isEmpty
        ? const ProductsCarouselLoaderWidget()
        : SizedBox(
        height:190,
        child:ListView.builder(
            shrinkWrap: true,
            itemCount: widget.productList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {

              return SizedBox(
                height:160,width:size.width * 0.93,
                child:RestaurantProductBox(choice: widget.productList[index], con: _con,km:  widget.vendor.distance,shopDetails: widget.vendor,)
              );

            }
        )
    );
  }

  callback(){

  }

}


