import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/vendor_controller.dart';
import '../helpers/helper.dart';
import '../models/vendor.dart';
import '../pages/store_detail.dart';


// ignore: must_be_immutable
class SliderShopWidget extends StatefulWidget {
  const SliderShopWidget({Key key}) : super(key: key);


  @override
  SliderShopWidgetState createState() => SliderShopWidgetState();
}

class SliderShopWidgetState extends StateMVC<SliderShopWidget> with TickerProviderStateMixin{

  AnimationController _controller;
  Animation<Offset> _animation;
  VendorController _con;

  SliderShopWidgetState() : super(VendorController()) {
    _con = controller;
  }


  int intState = 7;
  bool openState =false;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(
          milliseconds: 720
      ),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));

    _con.listenForVendorList('new_vendors','no', 5);
    super.initState();
  }
  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height:320,
      child:ListView.builder(

          itemCount: _con.vendorList.length,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            Vendor vendorDetails = _con.vendorList.elementAt(index);
            return InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        StoreViewDetails(shopDetails: vendorDetails,
                          shopTypeID: 2,
                          )));
              },
              child: SizedBox(
                width:240,
                  child: Column(
                    children: [
                      SlideTransition(
                        position: _animation,
                        transformHitTests: true,
                        textDirection: TextDirection.ltr,
                      child:SizedBox(
                          height:310,
                          child:Stack(

                        children: [
                          Container(
                            padding:const EdgeInsets.only(bottom:0),
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            foregroundDecoration:  BoxDecoration(
                                color:!Helper.shopOpenStatus(vendorDetails)? Colors.grey :Colors.transparent,
                                backgroundBlendMode:!Helper.shopOpenStatus(vendorDetails)? BlendMode.saturation:null
                            ),
                            margin: const EdgeInsets.only(left:15,right:5, top: 10.0,),
                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: InkWell(
                                onTap: () {},
                                child:  vendorDetails.cover!='no_image'?Image.network(vendorDetails.cover, height:310,
                                  fit: BoxFit.cover,
                                  width: 240,
                                ):Image.asset('assets/img/cover1.jpg', height:310,
                                  fit: BoxFit.cover,
                                  width: 240,
                                ),
                              ),
                            ),
                          ),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),

                            child:Container(
                              alignment: Alignment.bottomCenter,
                              margin: const EdgeInsets.only(left:15,right:5),
                              /* background black light to dark gradient color */

                              child: Stack(
                                children: [

                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 210,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      gradient: LinearGradient(
                                        begin: const Alignment(0.0, -1.0),
                                        end: const Alignment(0.0, 0.6),
                                        colors: <Color>[
                                          const Color(0x8A000000).withOpacity(0.0),

                                          const Color(0x8A000000).withOpacity(0.9),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),



                          Positioned(
                              bottom: 8.0,
                              left: 8.0,
                              right: 8.0,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Container(
                                      padding:const EdgeInsets.only(left:15,right:15),
                                      child:Text(vendorDetails.shopName,
                                          overflow: TextOverflow.ellipsis,maxLines: 1,
                                          style: Theme.of(context).textTheme.displayMedium.merge(TextStyle(color:Theme.of(context).primaryColorLight),)
                                      ),
                                    ),
                                    Container(
                                      padding:const EdgeInsets.only(left:15,right:15),
                                      child:Text(vendorDetails.locationMark,overflow: TextOverflow.ellipsis,maxLines: 1,
                                          style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).primaryColorLight),)
                                      ),
                                    ),
                                    Container(
                                        padding:const EdgeInsets.only(top:5,left:15,right:15,bottom:10),
                                        child:Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:const EdgeInsets.only(top:5,bottom:5),
                                              child:Wrap(
                                                children: [
                                                  Icon(Icons.star,size:18,
                                                    color:Theme.of(context).primaryColorLight,
                                                  ),
                                                  Container(
                                                      padding:const EdgeInsets.only(left:2,right:5),
                                                      child:Text(vendorDetails.ratingNum,
                                                        style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).primaryColorLight)),
                                                      )
                                                  ),
                                                  Icon(Icons.timer,size:18,
                                                    color:Theme.of(context).primaryColorLight.withOpacity(0.5),
                                                  ),
                                                  Container(
                                                      padding:const EdgeInsets.only(left:2,right:2),
                                                      child:Text('${Helper.calculateTime(double.parse(vendorDetails.distance.replaceAll(',','')),int.parse(vendorDetails.handoverTime),false)}',
                                                        style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).primaryColorLight)),
                                                      )
                                                  ),
                                                  Container(
                                                      padding:const EdgeInsets.only(left:2,right:2),
                                                      child:Text('${Helper.priceDistance(vendorDetails.distance)}',
                                                        style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).primaryColorLight)),
                                                      )
                                                  ),
                                                ],
                                              ),),
                                            Container(
                                                padding:const EdgeInsets.only(left:10,right:10),
                                                child:const Icon(Icons.star,color:Colors.orange)
                                            ),

                                          ],
                                        )
                                    ),



                                  ]
                              )
                          ),
                        ],


                      )),)
                    ],
                  )

              ),
            );

          }
          )
    );
  }

}


