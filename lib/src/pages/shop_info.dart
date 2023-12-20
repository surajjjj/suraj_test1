import 'dart:ui';

import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import '../../generated/l10n.dart';
import '../elements/restaurant_product_slider_widget.dart';
import '../elements/shop_recent_review.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:responsive_ui/responsive_ui.dart';

import '../Widget/custom_divider_view.dart';
import '../controllers/vendor_controller.dart';
import '../elements/slider_shop_widget.dart';
import '../models/vendor.dart';
// ignore: must_be_immutable
class ShopInfo extends StatefulWidget {
   Vendor shopDetails;
   ShopInfo({Key key, this.shopDetails}) : super(key: key);

  @override
  ShopInfoState createState() => ShopInfoState();
  void callBack(int index) {}
}

class ShopInfoState extends StateMVC<ShopInfo> with TickerProviderStateMixin{
  double appBarHeight = 0.0;

  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  bool isFav = false;
  bool isReadless = false;
  AnimationController animationController;
  VendorController _con;

  ShopInfoState() : super(VendorController()) {
    _con = controller;

  }

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    animationController.forward();
    super.initState();
    _con.listenShopInfo(widget.shopDetails.shopId);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }



  _callNumber(number) async{
    //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }


  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(


      body: Stack(
        children: <Widget>[
          NestedScrollView(
            controller: scrollController,
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: ContestTabHeader(
                    (size.height),
                    widget.shopDetails,
                        () {
                      scrollController.animateTo(size.height - size.height / 5,
                          duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                    },
                    getShopDetails(vendorDetails: widget.shopDetails),
                  ),
                ),
              ];
            },
            body: ListView(
              padding: const EdgeInsets.only(top: 24),
              children: <Widget>[

                Text(S.of(context).about,textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium
                ),
                Container(
                  padding: const EdgeInsets.only(top:10,left: 20,right:20),
                  child:Text(widget.shopDetails.subtitle,
                style: Theme.of(context).textTheme.titleSmall,
                ),),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:Text(S.of(context).details,
                      style: Theme.of(context).textTheme.displayMedium
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(top:20,left:20,right:20),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          const Icon(
                              Icons.access_time,size:19
                          ),
                          const SizedBox(width:10),
                          Expanded(
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  widget.shopDetails.shopTiming.availableType=='1'? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                       //   Text ('(Monday)',maxLines: 1,style: Theme.of(context).textTheme.bodyText2),
                                          Text ('${widget.shopDetails.shopTiming.allTimes.fromAvailableTime}-${widget.shopDetails.shopTiming.allTimes.toAvailableTime}',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),

                                        ],

                                  ):widget.shopDetails.shopTiming.availableType=='2'?ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: widget.shopDetails.shopTiming.sameTime.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.only(top: 10),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, int index) {

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          //   Text ('(Monday)',maxLines: 1,style: Theme.of(context).textTheme.bodyText2),
                                          Text ('${widget.shopDetails.shopTiming.sameTime[index].fromAvailableTime}-${widget.shopDetails.shopTiming.sameTime[index].toAvailableTime}',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),

                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                  ): Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                                  Text ('(Monday)',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),
                                  ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: widget.shopDetails.shopTiming.differentTime.monDay.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.only(top: 10),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, int index) {

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text ('${widget.shopDetails.shopTiming.differentTime.monDay[index].fromAvailableTime}-${widget.shopDetails.shopTiming.differentTime.monDay[index].toAvailableTime}',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),

                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                  ),
                    Text ('(TuesDay)',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: widget.shopDetails.shopTiming.differentTime.tueDay.length,
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.only(top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, int index) {

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text ('${widget.shopDetails.shopTiming.differentTime.tueDay[index].fromAvailableTime}-${widget.shopDetails.shopTiming.differentTime.tueDay[index].toAvailableTime}',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),

                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                    ),
                    Text ('(Wednesday)',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemCount: widget.shopDetails.shopTiming.differentTime.wedDay.length,
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.only(top: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, int index) {

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text ('${widget.shopDetails.shopTiming.differentTime.wedDay[index].fromAvailableTime}-${widget.shopDetails.shopTiming.differentTime.wedDay[index].toAvailableTime}',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),

                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 10);
                      },
                    )
                  ]),
                                  Text ('(Thursday)',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),
                                  ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: widget.shopDetails.shopTiming.differentTime.thurDay.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.only(top: 10),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, int index) {

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text ('${widget.shopDetails.shopTiming.differentTime.thurDay[index].fromAvailableTime}-${widget.shopDetails.shopTiming.differentTime.thurDay[index].toAvailableTime}',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),

                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                  ),

                                  Text ('(Friday)',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),
                                  ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: widget.shopDetails.shopTiming.differentTime.friDay.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.only(top: 10),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, int index) {

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text ('${widget.shopDetails.shopTiming.differentTime.friDay[index].fromAvailableTime}-${widget.shopDetails.shopTiming.differentTime.friDay[index].toAvailableTime}',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),

                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                  ),
                                  Text ('(Saturday)',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),
                                  ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: widget.shopDetails.shopTiming.differentTime.satDay.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.only(top: 10),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, int index) {

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text ('${widget.shopDetails.shopTiming.differentTime.satDay[index].fromAvailableTime}-${widget.shopDetails.shopTiming.differentTime.satDay[index].toAvailableTime}',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),

                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                  ),
                                  Text ('(Sunday)',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),
                                  ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: widget.shopDetails.shopTiming.differentTime.sunDay.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.only(top: 10),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, int index) {

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text ('${widget.shopDetails.shopTiming.differentTime.sunDay[index].fromAvailableTime}-${widget.shopDetails.shopTiming.differentTime.sunDay[index].toAvailableTime}',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),

                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 10);
                                    },
                                  ),



                                ],
                              )
                          ),
                          const SizedBox(width:10),
                          InkWell(
                            onTap: (){
                              _callNumber(widget.shopDetails.phone);
                            },
                            child: Align(
                                child:Icon(Icons.call_outlined,size:23,color:Theme.of(context).primaryColorDark,)
                            ),
                          )


                        ]
                    )
                ),
                Container(
                    padding: const EdgeInsets.only(top:20,left:20,right:20),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          const Icon(
                              Icons.monetization_on_outlined,size:19
                          ),
                          const SizedBox(width:10),
                          Expanded(
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text ('250 for two',maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              )
                          ),



                        ]
                    )
                ),
                Container(
                    padding: const EdgeInsets.only(top:20,left:20,right:20),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          const Icon(
                              Icons.brunch_dining,size:19
                          ),
                          const SizedBox(width:10),
                          Expanded(
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text (widget.shopDetails.subtitle,maxLines: 1,style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              )
                          ),




                        ]
                    )
                ),

                Container(
                    padding: const EdgeInsets.only(top:20,left:20,right:20),
                    child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          IconButton(onPressed: (){

                          }, icon: const Icon(
                              Icons.location_on_outlined,size:23
                          )),
                          const SizedBox(width:10),
                          Expanded(
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  RichText(
                                    text: TextSpan(text: '6.8 kms ',
                                        style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color:Colors.blue)),
                                        children: [
                                          TextSpan(
                                              text: widget.shopDetails.locationMark,
                                              style: Theme.of(context).textTheme.bodyMedium

                                          )
                                        ]),
                                  ),
                                ],
                              )
                          ),
                          const SizedBox(width:10),
                          InkWell(
                            onTap: (){
                              Helper.openMap(double.parse(widget.shopDetails.latitude),double.parse( widget.shopDetails.longitude));
                            },
                            child: Align(
                                child:Icon(Icons.directions,size:23,color:Theme.of(context).primaryColorDark,)
                            ),
                          )

                        ]
                    )
                ),
                const SizedBox(height:10),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  elevation: 0,

                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.transparent, width: 1, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    S.of(context).view_all_outlet_of_this_restaurant,
                    style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: Theme.of(context).primaryColorDark)),
                  ),
                ),
                const SizedBox(height:10),
                const CustomDividerView(
                  dividerHeight: 10,
                ),
                const SizedBox(height:10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:Text(S.of(context).delivery_types,
                      style: Theme.of(context).textTheme.displayMedium
                  ),

                ),
                Container(
                    padding: const EdgeInsets.only(top:10,left:20,right:20,bottom:15),
                  child:Wrap(
                    children:[
                      widget.shopDetails.instant ?Div(
                          colS: 6,
                          colM: 6,
                          colL: 6,
                          child: Row(
                            children:[
                              Container(
                                padding:const EdgeInsets.only(right:10),
                                child:Icon(Icons.check_circle_outline,size:20,color: Theme.of(context).primaryColorDark,
                                )
                              ),
                              Expanded(
                                child:Container(
                                    padding:const EdgeInsets.only(right:10),
                                    child:Text(S.of(context).instant_delivery,
                                    style: Theme.of(context).textTheme.titleSmall,
                                    )
                                )
                              ),
                            ]
                          )
                      ):Container(),
                      widget.shopDetails.takeaway ? Div(
                          colS: 6,
                          colM: 6,
                          colL: 6,
                          child: Row(
                              children:[
                                Container(
                                    padding:const EdgeInsets.only(right:10),
                                    child:Icon(Icons.check_circle_outline,size:20,color: Theme.of(context).primaryColorDark,
                                    )
                                ),
                                Expanded(
                                    child:Container(
                                        padding:const EdgeInsets.only(right:10),
                                        child:Text(S.of(context).takeaway,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        )
                                    )
                                ),
                              ]
                          )
                      ):Container(),
                      widget.shopDetails.schedule ? Div(
                          colS: 6,
                          colM: 6,
                          colL: 6,
                          child: Row(
                              children:[
                                Container(
                                    padding:const EdgeInsets.only(right:10),
                                    child:Icon(Icons.check_circle_outline,size:20,color: Theme.of(context).primaryColorDark,
                                    )
                                ),
                                Expanded(
                                    child:Container(
                                        padding:const EdgeInsets.only(right:10),
                                        child:Text(S.of(context).scheduled_delivery,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        )
                                    )
                                ),
                              ]
                          )
                      ):Container()
                    ]
                  )
                ),
                const CustomDividerView(
                  dividerHeight: 3,
                ),


                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:Text(S.of(context).popular_cuisines,
                              style: Theme.of(context).textTheme.displayMedium
                          ),
                ),
                const SizedBox(height:10),
                RestaurantProductSliderWidget(itemDetails: _con.shopInfoDetails.itemData,),

                Container(
                  color: Theme.of(context).primaryColor,
                  child:Column(
                    children:[
                      Container(
                        padding: const EdgeInsets.only(top:0,left:20,right: 10),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:[
                                  Expanded(
                                    child:Text(S.of(context).what_people_say,
                                        style: Theme.of(context).textTheme.displayMedium
                                    ),),



                                ]
                            ),
                            const SizedBox(height:4),
                            Text(S.of(context).recent_reviews,
                              style:  Theme.of(context).textTheme.bodyMedium,
                            )
                          ]
                        )
                      ),

                    /*  RatingsReviewWidget(), */
                      ShopRecentReviewBox(reviewList: _con.shopInfoDetails.recentReview),
                    ]
                  )
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:Text('${S.of(context).new_on} ${setting.value.appName}',
                              style: Theme.of(context).textTheme.displayMedium
                          ),

                ),
                const SizedBox(height:10),
                const SliderShopWidget(),



                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SizedBox(
              height: AppBar().preferredSize.height,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: AppBar().preferredSize.height,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8,left:8),
                      child: Container(
                          width: AppBar().preferredSize.height - 8,
                          height: AppBar().preferredSize.height - 8,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child:ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(24)),
                              child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                      color: Colors.black12,
                                      child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            highlightColor: Colors.transparent,
                                            splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
                                            borderRadius: const BorderRadius.all(Radius.circular(38)),
                                            onTap: () {
                                              if (scrollController.offset != 0.0) {
                                                scrollController.animateTo(0.0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutQuad);
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: Icon(Icons.arrow_back, color: Theme.of(context).primaryColorLight),
                                          )
                                      )
                                  )
                              )
                          )





                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  SizedBox(
                    height: AppBar().preferredSize.height,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: Container(
                        width: AppBar().preferredSize.height - 8,
                        height: AppBar().preferredSize.height - 8,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                          child:ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(24)),
                              child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                      color: Colors.black12,
                                      child: Material(
                                          color: Colors.transparent,
                                          child: FavoriteButton(
                                            iconSize: 40,
                                            isFavorite: _con.checkMyShopList(widget.shopDetails.shopId),
                                            valueChanged: (isFavorite) {
                                              _con.addToFavorite(widget.shopDetails.shopId);
                                            },
                                          )
                                      )
                                  )
                              )
                          )





                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),

    );
  }


  Widget getShopDetails({bool isInList = false,Vendor vendorDetails}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                vendorDetails.shopName,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: isInList ? Theme.of(context).dividerColor : Theme.of(context).colorScheme.primary,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    vendorDetails.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isInList ? Theme.of(context).dividerColor.withOpacity(0.5) : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),


                ],
              ),
              isInList
                  ? const SizedBox()
                  : Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: const <Widget>[

                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              widget.shopDetails.ratingNum,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
                color: isInList ? Colors.red : Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "${widget.shopDetails.ratingTotal} User",
              style: TextStyle(
                fontSize: 14,
                color: isInList ? Colors.red.withOpacity(0.5) : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

}



class ContestTabHeader extends SliverPersistentHeaderDelegate {
  final Widget ui;
  final VoidCallback callback;
  final Vendor shopDetails;
  final double heightValue;
  ContestTabHeader(
      this.heightValue,
      this.shopDetails,
      this.callback,
      this.ui,
      );

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    var minValue = (shrinkOffset < heightValue - heightValue / 5 ? shrinkOffset : heightValue / 5);
    return Container(
      height: heightValue - minValue,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 8,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.network(
              shopDetails.cover,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 16,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: getOpValue(minValue, heightValue / 5),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          color: Colors.black12,
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 4,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                                child: ui,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color:Theme.of(context).primaryColorDark,
                                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Theme.of(context).dividerColor,
                                        blurRadius: 8,
                                        offset: const Offset(4, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                            Navigator.pop(context);
                                      },
                                      child:  Center(
                                        child: Text(
                                          S.of(context).order_now,
                                          style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(24)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Container(
                          color: Colors.black12,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
                              borderRadius: const BorderRadius.all(Radius.circular(38)),
                              onTap: () {
                                try {
                                  callback();
                                } catch (e) {
                                  if (kDebugMode) {
                                    print(e);
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:  <Widget>[
                                    Text(
                                      S.of(context).view_more,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                   Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 24,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  double getOpValue(double minValue, double maxValue) {
    var data = (1.0 - (minValue / maxValue));
    if (data < 0.0) {
      return 0.0;
    } else if (data >= 0 && data <= 1) {
      return data;
    } else {
      return 1.0;
    }
  }

  @override
  double get maxExtent => heightValue;

  @override
  double get minExtent => heightValue / 5;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}









