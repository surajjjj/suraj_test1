import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import '../helpers/helper.dart';
import '../models/vendor.dart';
import '../pages/store_detail.dart';
import '../repository/vendor_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/vendor_controller.dart';

class ShopList extends StatefulWidget {

  final Vendor choice;
  final int shopType;
  final int focusId;
  final String previewImage;

  const ShopList({Key key, this.choice, this.shopType,this.focusId, this.previewImage}) : super(key: key);
  @override
  ShopListState createState() => ShopListState();
}

class ShopListState extends StateMVC<ShopList> {
  VendorController _con;

  ShopListState() : super(VendorController()) {
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Hero(
      tag: widget.choice.shopId,
      child: InkWell(
        onTap: (){




            currentVendor.value =  widget.choice;

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      StoreViewDetails(shopDetails: widget.choice,
                        shopTypeID: widget.shopType,
                       )));




        },
        child: Stack(
            children:[
   Container(
              margin: const EdgeInsets.only(left:15,right:15),
              height: 250,
              width: size.width,
             foregroundDecoration: BoxDecoration(
               color:!Helper.shopOpenStatus(widget.choice)? Colors.grey :Colors.transparent,
               backgroundBlendMode:!Helper.shopOpenStatus(widget.choice)? BlendMode.saturation:null
             ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: widget.choice.cover!='no_image'?NetworkImage(widget.choice.cover):const AssetImage('assets/img/chicken_category1.jpg'),
                ),

              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: 170,
                    child:  Container(
                      alignment: Alignment.bottomCenter,

                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.8, 0.9,1.5,1.9],
                          colors: [
                            Color(0x00000000),
                            Color(0xff000000),
                            Color(0xff000000),
                            Color(0xff000000),
                            Color(0xff000000),
                          ],
                        ),
                      ),
                    ),
                  ),
                /*  Positioned(
                    top:20,left:-2,
                    child: Align(
                      alignment: Alignment.topCenter,
                      // This is the ONLY required parameter
                      child: Container(
                        //width: MediaQuery.of(context).size.width * 0.20,
                          width: 102,
                          height:43,
                          decoration: const BoxDecoration(

                            image: DecorationImage(
                                image: NetworkImage('assets/img/sellerlable.png')
                            ),

                          ),

                          child:Stack(
                              alignment: Alignment.center,
                              children:[
                                Positioned(
                                    top:15,
                                    child: Text(S.of(context).best_seller,style:TextStyle(color:Theme.of(context).primaryColorLight,fontSize:10,fontWeight: FontWeight.w800))
                                )

                              ]
                          )
                      ),
                      // This is the default value


                    ),
                  ), */

                  Positioned(
                      bottom:20,left:10,right:10,
                      child: SizedBox(
                          width: size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[

                                Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children:[

                                      Expanded(
                                        child:Container(
                                          padding: const EdgeInsets.only(top:0,left: 10),

                                          child:Text( widget.choice.shopName,style: Theme.of(context).textTheme.headlineSmall.merge(TextStyle(color:Theme.of(context).primaryColorLight)), softWrap: true, maxLines: 2,),
                                        ),),
                                      Container(
                                        margin: const EdgeInsets.only(right:15),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(30),
                                        ),

                                        child:   Container(

                                            padding: const EdgeInsets.all(8),
                                            child:Wrap(
                                                children:[
                                                  Text(widget.choice.ratingNum,
                                                    style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                                  ),
                                                  Container(
                                                      margin:const EdgeInsets.only(right:5,top:3),


                                                      child:const Icon(Icons.star,size:11,color:Colors.orange)
                                                  ),
                                                  Text('(${widget.choice.ratingTotal})',
                                                    style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                                  ),


                                                ]
                                            )

                                        ),


                                      ),
                                    ]
                                ),

                                Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children:[
                                      Expanded(
                                        child:Container(
                                          padding: const EdgeInsets.only(top:10,left:10),

                                          child:Text(widget.choice.locationMark,style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary.withOpacity(0.7))), softWrap: true, maxLines: 1,),
                                        ),),
                                      Container(
                                          padding: const EdgeInsets.only(top:10,left:10),
                                          child:Text('${Helper.priceDistance(widget.choice.distance)}| ${Helper.calculateTime(double.parse(widget.choice.distance.replaceAll(',','')),int.parse(widget.choice.handoverTime),false)}',style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w700)),)
                                      )
                                    ]
                                )
                              ]
                          )
                      )
                  ),

                widget.choice.foodType=='Veg'?Positioned(
                      top:-10,right:10,
                      child: Stack(
                          children:const [
                            SizedBox(
                                width:50,height:50,
                                child:Image(image:AssetImage('assets/img/offer_badge_voilet.png'))
                            ),
                          ])

                  ):Container(),


                  Positioned(
                    top: 20,
                    left:10,
                    child:Container(
                        height: 37,
                        width: 47,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor,
                        ),
                        child:  FavoriteButton(
                          iconSize: 40,
                          isFavorite: _con.checkMyShopList(widget.choice.shopId),
                          valueChanged: (isFavorite) {
                            _con.addToFavorite(widget.choice.shopId);
                          },
                        ),
                    ),
                  ),


                ],
              )

          ),


              Helper.shopOpenStatus(widget.choice) &&   widget.choice.displayCoupon.discountType!=''?  Positioned(
                  top: 100,left:10,
                  child:Stack(
                      clipBehavior: Clip.hardEdge,
                      children:[

                        SizedBox(
                            width:100,height:45,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      margin:const EdgeInsets.only(top:10),
                                      child:Image.asset('assets/img/offer_badge_yellow.png',
                                        height: 20,width:20,fit: BoxFit.fill,
                                      )
                                  ),
                                  Expanded(
                                      child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children:[
                                            Container(
                                              padding:const EdgeInsets.only(left:10),
                                              child: Text(widget.choice.displayCoupon.discountType=='amount'?
                                                   '${Helper.pricePrint(widget.choice.displayCoupon.discount)} OFF':
                                                   '${widget.choice.displayCoupon.discount}% OFF',
                                                style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w800)),
                                              ),
                                            ),
                                            widget.choice.displayCoupon.couponType!='4'?Container(
                                              padding:const EdgeInsets.only(left:10),
                                              child: Text('Upto',
                                                style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                              ),
                                            ):Container(),

                                          ]
                                      )
                                  )
                                ],
                              )
                          ),)


                      ])
              ):Container(),


              !Helper.shopOpenStatus(widget.choice)?  Positioned(
                  top:0,right:size.width * 0.23 ,
                  child:Align(
                      alignment:Alignment.topCenter,
                      child:Container(
                          padding:const EdgeInsets.only(left:15,right:15,bottom:15),
                          height:80,width:180,
                          decoration:const BoxDecoration(
                            image:DecorationImage(
                              image:AssetImage(
                                'assets/img/closed_board.png'
                              ),
                              fit: BoxFit.fill
                            )
                          ),
                          child:Container(
                            margin: const EdgeInsets.only(top:12),
                              child:Column(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children:[
                                    Text('Closed',
                                        style:Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).colorScheme.primary))
                                    ),

                                    Text(Helper.nextOpenTime(widget.choice)??'',
                                        style:TextStyle(fontSize:10,color:Theme.of(context).colorScheme.primary)
                                    )
                                  ]
                              )
                          )
                      ))
              ):Container(),




            ]
    )
    ));
  }
}