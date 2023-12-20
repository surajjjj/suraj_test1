import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../models/vendor.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'no_shop_found_widget.dart';
import '../components/Shimmer/rectangular_loader_widget.dart';
import 'shop_list_widget.dart';
// ignore: must_be_immutable
class SearchShopListWidget extends StatefulWidget {

  HomeController con;
  List<Vendor> vendor;
  SearchShopListWidget({Key key, this.con, this.vendor}) : super(key: key);
  @override
  SearchShopListWidgetState createState() => SearchShopListWidgetState();
}

class SearchShopListWidgetState extends StateMVC<SearchShopListWidget> {



  int shopType;
  int focusId;
  String previewImage;
  int i= 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),

      child:
      widget.vendor.isEmpty?const RectangularLoaderWidget(): ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: widget.vendor.length,
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.only(top: 16),
            itemBuilder: (context, int index) {
              return widget.vendor[index].shopId=='no_data'?NoShopFoundWidget():ShopList(choice: widget.vendor[index], shopType: int.parse(widget.vendor[index].shopType),focusId: 2,previewImage:previewImage,);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
          ),

    );
  }
}

