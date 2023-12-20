import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/helper.dart';
import '../models/vendor.dart';
import '../pages/store_detail.dart';
import '../repository/settings_repository.dart';


// ignore: must_be_immutable
class FeatureRestaurantsWidget extends StatefulWidget {
  List<Vendor> vendorList;
  FeatureRestaurantsWidget({Key key, this.vendorList}) : super(key: key);


  @override
  FeatureRestaurantsWidgetState createState() => FeatureRestaurantsWidgetState();
}

class FeatureRestaurantsWidgetState extends StateMVC<FeatureRestaurantsWidget> with TickerProviderStateMixin{
  AnimationController _controller;
  Animation<Offset> _animation;


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
        height:290,
      child:ListView.builder(

          itemCount: widget.vendorList.length,
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            Vendor vendorDetails = widget.vendorList.elementAt(index);
            return InkWell(
              child: SizedBox(
                width:200,
                  child: SlideTransition(
                      position: _animation,
                      transformHitTests: true,
                      textDirection: TextDirection.ltr,
                      child:Column(
                    children: [
                      SizedBox(
                          height:210,
                          child:Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding:const EdgeInsets.only(bottom:0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            foregroundDecoration:  BoxDecoration(
                                color:!Helper.shopOpenStatus(vendorDetails)? Colors.grey :Colors.transparent,
                                backgroundBlendMode:!Helper.shopOpenStatus(vendorDetails)? BlendMode.saturation:null
                            ),
                            margin: const EdgeInsets.only(left:15,right:5, top: 10.0,),
                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          StoreViewDetails(shopDetails: vendorDetails,
                                            shopTypeID: 2,
                                          )));
                                },
                                child: vendorDetails.cover!=''?Image.network(vendorDetails.cover, height:230,
                                  fit: BoxFit.cover,
                                  width: 280,
                                ):Image.asset('assets/img/loginbg1.jpg', height:230,
                                  fit: BoxFit.cover,
                                  width: 280,
                                ),
                              ),
                            ),
                          ),

                          vendorDetails.displayCoupon.discountType!=''?  Positioned(
                             top: 20,left:10,
                                  child:Stack(
                                      children:[
                                        SizedBox(
                                            width:120,height:45,
                                        child:ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(3),
                                            bottomLeft: Radius.circular(3),
                                            topRight:Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                            child:Image.asset('assets/img/sellerlable.png',
                                        height: 40,fit: BoxFit.fitHeight,
                                        ))
                                        ),

                                        Align(
                                          alignment: Alignment.center,
                                          child:Container(
                                              margin: const EdgeInsets.only(top:0,left:5),
                                              width:120,height:45,
                                              alignment: Alignment.center,
                                              child:Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text('one',
                                                  style: Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w800)),
                                                  ),
                                                  Expanded(
                                                    child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children:[
                                                          Container(
                                                            padding:const EdgeInsets.only(left:10),
                                                            child: Text(vendorDetails.displayCoupon.discountType=='amount'?
                                                            '${Helper.pricePrint(vendorDetails.displayCoupon.discount)} OFF':
                                                            '${vendorDetails.displayCoupon.discount}% OFF',
                                                              style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary,)),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:const EdgeInsets.only(left:10),
                                                            child: Text('Upto',
                                                              style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                                            ),
                                                          ),
                                                        ]
                                                    )
                                                  )
                                                ],
                                              )
                                          ),)


                                      ])
                          ):Container(),

                        ],


                      )),
                      InkWell(
                        onTap: (){


                        },
                        child: Container(
                            padding:const EdgeInsets.only(top:15,left:15,right:3),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text(vendorDetails.shopName,
                                      overflow: TextOverflow.ellipsis,maxLines: 1,
                                      style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Helper.getColorFromHex(setting.value.featuredTextColor)))
                                  ),

                                  Container(
                                      padding:const EdgeInsets.only(top:5,right:15,),
                                      child:Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding:const EdgeInsets.only(top:5,bottom:5),
                                            child:Wrap(
                                              children: [
                                                Container(
                                                    height: 18,
                                                    width: 18,
                                                    alignment: Alignment.center,
                                                    padding: const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColorDark,),
                                                    child: InkWell(
                                                      onTap: (){},
                                                      child: Icon(Icons.star,color:Helper.getColorFromHex(setting.value.featuredTextColor),size:15),
                                                    )
                                                ),


                                                Container(
                                                    padding:const EdgeInsets.only(left:5,right:10),
                                                    child:Text('${vendorDetails.ratingNum} - ${Helper.calculateTime(double.parse(vendorDetails.distance.replaceAll(',','')),int.parse(vendorDetails.handoverTime),false)}',
                                                        style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Helper.getColorFromHex(setting.value.featuredTextColor)))
                                                    )
                                                ),

                                              ],
                                            ),),


                                        ],
                                      )
                                  ),



                                ]
                            )
                        ),
                      ),
                    ],
                  ))

              ),
            );

          }
          )
    );
  }

}


