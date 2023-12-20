
import 'package:flutter/material.dart';
import '../components/Shimmer/homepage_shimmer_widget.dart';

import '../elements/my_recommended_type_widge.dart';
import 'shop_all_list.dart';
import '../components/custom_appbar.dart';
import '../elements/best_restaurants_widget.dart';
import '../elements/bottom_live_status_widget.dart';
import '../components/Shimmer/category_shimmer_widget.dart';
import '../elements/featured_box_widget.dart';
import '../elements/restaurant_product_slider_widget.dart';
import '../controllers/home_controller.dart';
import '../elements/home_slider_widget.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/search_results_widget.dart';
import '../elements/service_not_available_widget.dart';
import '../elements/slider_shop_widget.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import '../../generated/l10n.dart';
import 'h_category.dart';
import 'recommed_shop.dart';



class HomeWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
 final Function selectTab;
  const HomeWidget({Key key,  this.iconColor,
    this.labelColor,this.parentScaffoldKey, this.selectTab}) : super(key: key);
  final Color iconColor;
  final Color labelColor;
  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends StateMVC<HomeWidget> {

  HomeController _con;

  HomeWidgetState() : super(HomeController()) {
    _con = controller;

  }
  bool loader = false;



  @override
  void initState() {

    // TODO: implement initState
    super.initState();
     _con.listenForZone();



  }






  @override
  Widget build(BuildContext context) {


    return _con.zoneDetect=='no'?const HomePageShimmerWidget():Scaffold(
     floatingActionButton: const BottomLiveStatusWidget(),
      floatingActionButtonLocation:FloatingActionButtonLocation.centerDocked,
      body: Stack(children: <Widget>[
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: <Widget>[
                 SliverPersistentHeader(
                    pinned: true,
                    delegate: CustomSliverDelegate(
                      expandedHeight:MediaQuery.of(context).size.height * 0.35,
                      con: _con,
                      loadUser: loadUser,
                    ),
                  ),
                  _con.zoneDetect=='not_match'?const ServiceNotAvailableWidget(): SliverList(
                    delegate: SliverChildListDelegate(<Widget>[
                    // Container(
                    //     padding: const EdgeInsets.only(left:20,right: 10),
                    //     child:Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children:[
                    //           Expanded(
                    //             child:Text(setting.value.categoryTitle,
                    //                 style: Theme.of(context).textTheme.displayMedium
                    //             ),),
                    //           _con.categoryList.length>8?SizedBox(
                    //             height: 40,
                    //             child: MaterialButton(
                    //               child: Center(
                    //                 child: Container(
                    //                     padding: const EdgeInsets.only(top:3,left:10,right:5),
                    //                     child:Text(S.of(context).see_all,
                    //                         textAlign: TextAlign.center,
                    //                         style:Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).primaryColorDark))
                    //                     )
                    //                 ),
                    //               ),
                    //               onPressed: () {
                    //                 Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    //                   return   Category(categoryList: _con.categoryList);
                    //                 })
                    //
                    //                 );
                    //
                    //               },
                    //             ),
                    //
                    //           ):Container(),
                    //
                    //
                    //         ]
                    //     ),
                    //   ),
                    //   const SizedBox(height: 50),
                    //   _con.categoryList.isEmpty?const CategoryShimmerWidget() :MyRecommendedTypeWidget(categoryList: _con.categoryList,),


                     // Container(
                     //    padding: const EdgeInsets.only(left:20,right: 10),
                     //    child:Row(
                     //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     //        children:[
                     //          Expanded(
                     //            child:Text(S.of(context).best_restaurants,
                     //                style: Theme.of(context).textTheme.displayMedium
                     //            ),),
                     //          SizedBox(
                     //            height: 40,
                     //            child: MaterialButton(
                     //              child: Center(
                     //                child: Container(
                     //                    padding: const EdgeInsets.only(top:3,left:10,right:5),
                     //                    child:Text(S.of(context).see_all,
                     //                        textAlign: TextAlign.center,
                     //                        style:Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).primaryColorDark))
                     //                    )
                     //                ),
                     //              ),
                     //              onPressed: () {
                     //                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                     //                  return  ShopAllList(pageTitle: S.of(context).best_restaurants, type: 'best',coverImage: 'assets/img/cover3.jpg',);
                     //                })
                     //
                     //                );
                     //
                     //              },
                     //            ),
                     //
                     //          ),
                     //
                     //
                     //        ]
                     //    ),
                     //  ),
                      const SizedBox(height: 10),

                      BestRestaurantsWidget(vendorList:_con.vendorList),

                      const SizedBox(height:10),
                  // BannerShimmerWidget(),
                  //     InkWell(
                  //       onTap: (){
                  //         if(setting.value.fbRdLink=='discount_upto') {
                  //           Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  //             return  ShopAllList(pageTitle: S.of(context).discount, type: 'discount_upto',coverImage: 'assets/img/cover1.jpg',para: setting.value.fbPara,);
                  //           }));
                  //         }
                  //         if(setting.value.fbRdLink=='link_to_item'){
                  //           Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultWidget(searchTxt: setting.value.fbPara)));
                  //         }
                  //       },
                  //       child: Container(
                  //           margin: const EdgeInsets.only(bottom:10),
                  //           child:Container(
                  //               padding:const EdgeInsets.only(left:5,right:5),
                  //               height:250,width:double.infinity,
                  //               child:  ClipRRect(
                  //                 borderRadius: const BorderRadius.all(Radius.circular(5)),
                  //                 child:Image.network(setting.value.fixedBanner,
                  //                   fit: BoxFit.fill,
                  //                 ),)
                  //           )
                  //       ),
                  //     ),
                  //


                      // const SizedBox(height:10),
                      // _con.featuredProductList.isNotEmpty?RestaurantProductSliderWidget(itemDetails: _con.featuredProductList,):Container(),
                      // const FeaturedBoxWidget(),
                      // const SizedBox(height:10),
                      // _con.popularProductList.isNotEmpty?
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child:Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children:[
                      //         Expanded(
                      //           child:Text(S.of(context).popular_foods_nearby,
                      //               style: Theme.of(context).textTheme.displayMedium
                      //           ),
                      //         ),
                      //       ]
                      //   ),
                      // ):Container(),
                      const SizedBox(height:10),
                     _con.popularProductList.isNotEmpty?RestaurantProductSliderWidget(itemDetails: _con.popularProductList,):Container(),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child:Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children:[
                      //         Expanded(
                      //           child:Text('${S.of(context).new_on} ${setting.value.appName}',
                      //               style: Theme.of(context).textTheme.displayMedium
                      //           ),
                      //         ),
                      //       ]
                      //   ),
                      // ),
                     // const SliderShopWidget(),
                     //  const SizedBox(height:10),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child:Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children:[
                      //         Expanded(
                      //           child:Text(S.of(context).recommended_shop,
                      //               style: Theme.of(context).textTheme.displayMedium
                      //           ),
                      //         ),
                      //       ]
                      //   ),
                      // ),
                      const SizedBox(height:10),
                      RecommendShop(vendorList: _con.vendorList,),
                      const SizedBox(height:80),


                    ]),
                  ),
                ],
              ),
            ]),

        );



  }

  loadUser(){
    setState(() => currentUser.value);
    _con.listenForZone();
  }

}




class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final HomeController con;
   Function loadUser;

  CustomSliverDelegate({
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
    this.con,
    this.loadUser,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;

    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return SizedBox(
      height: expandedHeight + expandedHeight / 6,
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.38,
            child: CustomAppBar(loadUser: loadUser,),
          ),
          con.zoneDetect=='not_match'?Container(): Positioned(
            left: 0.0,
            right: 0.0,
            top: 110,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: SingleChildScrollView(
                child: HomeSliderWidget(slides: con.slides),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 7;

  @override
  double get minExtent => expandedHeight / 2.26;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
