import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/vendor_controller.dart';
import '../Widget/custom_divider_view.dart';
import 'no_shop_found_widget.dart';
import '../components/Shimmer/rectangular_loader_widget.dart';
import 'shop_list_widget.dart';

// ignore: must_be_immutable
class ShopListBoxGeneralWidget extends StatefulWidget {
  VendorController con;
  String superId;
  String pageTitle;
  String coverImage;
  String offer;
  String offerType;
  String shopTypeId;
  ShopListBoxGeneralWidget({Key key,  this.con, this.pageTitle,this.offer, this.superId, this.offerType, this.coverImage, this.shopTypeId}) : super(key: key);
  @override
  ShopListBoxGeneralWidgetState createState() => ShopListBoxGeneralWidgetState();
}

class ShopListBoxGeneralWidgetState extends StateMVC<ShopListBoxGeneralWidget> {
  bool ratingOne = false;


  @override
  void initState() {

    super.initState();
    if(widget.offer!='no') {
      widget.con.listenForVendorListOffer(
          widget.superId, widget.offer, widget.offerType, widget.shopTypeId);
    } else{
      widget.con.listenForFavoritesShop();
    }


  }

  @override
  Widget build(BuildContext context) {
    return widget.con.vendorList.isEmpty?const RectangularLoaderWidget():SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Text(widget.pageTitle, style: Theme.of(context).textTheme.titleLarge)),

          CustomDividerView(dividerHeight: 1.0, color: Theme.of(context).dividerColor),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.con.notFound? const Text(''): Expanded(
                  child: Text('${widget.con.vendorList.length} ${S.of(context).stores_near_by}',
                      style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color: Theme.of(context).colorScheme.background))),
                ),
                /**  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Icon(Icons.filter_list, size: 19),
                    ),
                    SizedBox(width: 8),
                    Text('SORT/FILTER', style: Theme.of(context).textTheme.caption.merge(TextStyle(color: Theme.of(context).backgroundColor))) */
              ],
            ),
          ),

          ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: widget.con.vendorList.length,
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, int index) {
                       if (kDebugMode) {
                         print('not data ${widget.con.vendorList[index].shopId}');
                       }
              return widget.con.vendorList[index].shopId=='not_found'?NoShopFoundWidget(): ShopList(choice: widget.con.vendorList[index], shopType: int.parse(widget.con.vendorList[index].shopType),focusId: int.parse(widget.con.vendorList[index].focusType),previewImage: widget.coverImage,);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 20);
            },
          ),
          const SizedBox(height: 50)
        ]));
  }
}

