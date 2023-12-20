import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/vendor_controller.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart';
import 'top_rated_restaurants_widget.dart';

class FeaturedBoxWidget extends StatefulWidget {
  const FeaturedBoxWidget({Key key}) : super(key: key);

  @override
  FeaturedBoxWidgetState createState() => FeaturedBoxWidgetState();
}

class FeaturedBoxWidgetState extends StateMVC<FeaturedBoxWidget> {

  VendorController _con;
  FeaturedBoxWidgetState() : super(VendorController()) {
    _con = controller;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.listenForVendorList('featured','no', 6);
  }
  @override
  Widget build(BuildContext context) {
    return  !_con.notFound?Container(
      color: Helper.getColorFromHex(setting.value.featuredBgColor),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top:20,left:20,bottom:5),
            child: Text(setting.value.featuredText,
              style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color: Helper.getColorFromHex(setting.value.featuredTextColor))),
            ),
          ),
          FeatureRestaurantsWidget(vendorList: _con.vendorList,)
        ],
      ),
    ):Container();
  }
}
