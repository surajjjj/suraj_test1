import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/search_results_widget.dart';
import '../elements/shop_list_box_widget.dart';
import '../controllers/vendor_controller.dart';


// ignore: must_be_immutable
class Stores extends StatefulWidget {

   String pageTitle;
   String coverImage;
   String previewImage;
   String pageType;
   String id;
   bool subcategoryStatus;
   Stores({Key key,this.pageTitle, this.coverImage, this.previewImage,this.pageType, this.id, this.subcategoryStatus}) : super(key: key);
  @override
  StoresState createState() => StoresState();
}

class StoresState extends StateMVC<Stores> {

  VendorController _con;

  StoresState() : super(VendorController()) {
    _con = controller;
  }
  @override
  void initState() {
    // TODO: implement initState

    callBack();
    super.initState();
    _con.listenForMasterSubCategory(widget.id);
  }

  callBack(){

    if(widget.pageTitle=='quick_on'){
      _con.listenForVendorList('quick_on','no', 'all');
    } else if(widget.pageType=='category'){
      _con.listenForVendorList('category_wise_vendor',widget.id, 'all');
    } else {
      _con.listenForVendorList('all_vendor','no', 6);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children:[
          CustomScrollView(

            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: SliverCustomHeaderDelegate(
                    collapsedHeight: 100,
                    expandedHeight: 150,
                    paddingTop: MediaQuery.of(context).padding.top,

                    pageTitle: widget.pageTitle,
                    coverImage: widget.coverImage
                ),
              ),
              SliverList(

                delegate: SliverChildListDelegate(<Widget>[
                ShopListBoxWidget(con: _con, pageTitle: widget.pageTitle, previewImage: widget.previewImage, key: null,focusId: int.parse(widget.id),subcategoryStatus: widget.subcategoryStatus,callback:callBack,
                    notFound: _con.notFound),
                ]),
              ),
            ],
          ),
          Column(
              children:[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Align(
                        alignment: Alignment.topLeft,
                        child:Padding(
                          padding: const EdgeInsets.only(top:40,left:5),
                          child:  Container(
                              margin: const EdgeInsets.only(left: 10),
                              height: 35,
                              width: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              child: Container(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(Icons.arrow_back_ios,
                                        color:
                                        Theme.of(context).colorScheme.primary,
                                        size: 18),
                                  ))),

                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:45),
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.5),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultWidget()));
                          },
                          child: const Icon(
                            Icons.search,
                          ),
                        )),
                  ]
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

            width: double.infinity,
            fit: BoxFit.fill,
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
                                padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
                                child: Text(
                                  pageTitle,
                                  style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: makeStickyHeaderTextColor(shrinkOffset, false),
                                      )),
                                )),
                          ],
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



