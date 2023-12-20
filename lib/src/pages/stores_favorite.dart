
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import '../../generated/l10n.dart';
import '../elements/shop_list_box_general_widget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/vendor_controller.dart';
import '../Widget/custom_divider_view.dart';

// ignore: must_be_immutable
class StoresFavorite extends StatefulWidget {
  const StoresFavorite({Key key}) : super(key: key);



  @override
  StoresFavoriteState createState() => StoresFavoriteState();
}

class StoresFavoriteState extends StateMVC<StoresFavorite> {

  VendorController _con;

  StoresFavoriteState() : super(VendorController()) {
    _con = controller;
  }
  @override
  void initState() {
    // TODO: implement initState
   // _con.listenForVendorList(widget.storeType, widget.focusId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: SliverCustomHeaderDelegate(
                    collapsedHeight: 100,
                    expandedHeight: 150,
                    paddingTop: MediaQuery.of(context).padding.top,
                    shopType: 7,
                    pageTitle: S.of(context).my_favorite_store,
                    coverImage: '${GlobalConfiguration().getValue('base_upload')}uploads/general_image/my_favorite.png'
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  ShopListBoxGeneralWidget(con: _con,   pageTitle:S.of(context).my_favorite_store ,offer:'no',offerType: '',coverImage: '', key: null,),
                ]),
              ),
            ],
          ),
          Column(
              children:[
                Align(
                  alignment: Alignment.topLeft,
                  child:Padding(
                      padding: const EdgeInsets.only(top:40,left:10),
                      child:  SizedBox(
                        width:40,height:40,
                        child:IconButton(
                            onPressed: (){
                             Navigator.pop(context);
                            },
                            icon:const Icon(Icons.arrow_back_ios),
                            color:Theme.of(context).colorScheme.primary
                        ),
                      )

                  ),
                ),
              ]
          )
        ]
      ),
    );
  }
}

class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final int shopType;
  final String coverImage;
  final String pageTitle;

  String statusBarMode = 'dark';

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.shopType,
    this.pageTitle,
    this.coverImage,
  });

  @override
  double get minExtent => collapsedHeight + paddingTop;

  @override
  double get maxExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (maxExtent - minExtent) * 300).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            coverImage,
            height: MediaQuery.of(context).size.height / 0.5,
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),

          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: makeStickyHeaderBgColor(shrinkOffset),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: collapsedHeight,
                  padding: const EdgeInsets.only(top: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 25),
                                child: Text(
                                  pageTitle,
                                  style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: makeStickyHeaderTextColor(shrinkOffset, false),
                                      )),
                                )),
                          ],
                        ),
                        CustomDividerView(
                          dividerHeight: 1.0,
                          color: makeStickyHeaderTextColor(shrinkOffset, false),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                              S.of(context).stores_near_by,
                                  style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(
                                        color: makeStickyHeaderTextColor(shrinkOffset, false),
                                      )),
                                ),
                              ),
                           /**   Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Icon(
                                  Icons.filter_list,
                                  size: 19,
                                  color: this.makeStickyHeaderTextColor(shrinkOffset, false),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'SORT/FILTER',
                                style: Theme.of(context).textTheme.caption.merge(TextStyle(
                                      color: this.makeStickyHeaderTextColor(shrinkOffset, false),
                                    )),
                              ), */
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



