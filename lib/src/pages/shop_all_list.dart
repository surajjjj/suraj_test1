
import 'package:flutter/material.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../controllers/home_controller.dart';
import '../elements/no_shop_found_widget.dart';
import '../components/Shimmer/shop_list_shimmer_widget.dart';
import '../elements/shop_list_widget.dart';
//ignore: must_be_immutable
class ShopAllList extends StatefulWidget {
  String pageTitle;
  String coverImage;
  String type;
  String para;
  ShopAllList({Key key, this.pageTitle, this.coverImage, this.type, this.para}) : super(key: key);



  @override
  ShopAllListState createState() => ShopAllListState();
}

class ShopAllListState extends StateMVC<ShopAllList> {
  List<ShopFilter> superFilter;
  HomeController _con;
  ShopAllListState() : super(HomeController()) {
    _con = controller;

  }
  @override
  void initState() {

    super.initState();
    if(widget.type=='best') {
      _con.listenForVendorList('quick_on', 'no', 'all');
    }else if(widget.type=='discount_upto'){
      _con.listenForVendorList('discount_upto', widget.para, 'all');
    }else if(widget.type=='favorite_store'){
      _con.listenForVendorList('favorite_store',currentUser.value.id, 'all');
    }
  }
  final bool visible= false;
  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
          children:[
            Container(
              width: double.infinity,
              height: 160,
              decoration:  BoxDecoration(
                  image:DecorationImage(
                      image:AssetImage(widget.coverImage,
                      ),
                      fit: BoxFit.fill
                  )
              ),
              child:Container(
                padding: const EdgeInsets.only( left: 10.0),
                child: Row(
                  children: <Widget>[
                    widget.type!='favorite_store'?Align(
                      alignment: Alignment.topLeft,
                      child:Padding(
                        padding: const EdgeInsets.only(top:65,left:5),
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
                    ):Container(),
                    const SizedBox(width: 10.0),
                    Text(widget.pageTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
              ),
            ),
            Container(

              margin: const EdgeInsets.only(top:120),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top:10,),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),)),

                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                    _con.notFound?NoShopFoundWidget(): _con.vendorList.isEmpty?Container(
                        margin: const EdgeInsets.only(top:20,left:20,right:20),
                        child:const ShopListShimmerWidget()):SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [



              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                   Expanded(
                      child: Text('${ _con.vendorList.length} ${S.of(context).stores_near_by}',
                          style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color: Theme.of(context).colorScheme.background))),
                    ),

                  ],
                ),
              ),




              ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount:    _con.vendorList.length,
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, int index) {

                  return     _con.vendorList[index].shopId=='no_data'?NoShopFoundWidget():ShopList(choice:    _con.vendorList[index], focusId: 2,previewImage:    _con.vendorList[index].cover,);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 20);
                },
              ),
              const SizedBox(height: 50)
            ]
               ))],


                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )


          ]
      ),

    );
  }
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    superFilter   = <ShopFilter>[
      ShopFilter( type: 'All', selected: true, value: 'All'),
      ShopFilter( type: 'Opened Shop', selected: false, value: 'Opened Shop'),
      ShopFilter( type: S.of(context).rating, selected: false, value:'Rating'),
      ShopFilter( type: S.of(context).takeaway, selected: false, value: 'Takeaway'),
      ShopFilter( type: S.of(context).distance, selected: false, value: 'Distance'),
      ShopFilter( type: S.of(context).delivery_time, selected: false, value: 'Delivery Time'),
    ];

  }
}
class ShopFilter  {
  ShopFilter({this.type, this.selected, this.value});
  String type;
  bool selected;
  String value;
}