// ignore: must_be_immutable

import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import 'terms_popup_widget.dart';
import '../models/coupon.dart';
import '../repository/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/settings_repository.dart';


// ignore: must_be_immutable
class OfferDetailsPart extends StatefulWidget {
  String pageType;
  List<CouponModel> couponList;
  OfferDetailsPart({Key key, this.pageType, this.couponList}) : super(key: key);
  @override
  OfferDetailsPartState createState() => OfferDetailsPartState();
}

class OfferDetailsPartState extends StateMVC<OfferDetailsPart> {

  CartController _con;

  OfferDetailsPartState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  Column(children: [
      Container(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: const EdgeInsets.only(top:18,),
              child:Text(S.of(context).available_coupons,
                  style: Theme.of(context).textTheme.titleMedium
              ),
            ),
            ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount:  widget.couponList.length,
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.only(top: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) {
                CouponModel coupon = widget.couponList.elementAt(index);

                return Container(
                    padding:const EdgeInsets.only(left:0,right:0,top:10,bottom:10),
                    child:Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage('assets/img/coupon_card7.png'),
                                fit: BoxFit.fill
                            ),

                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 15.0,
                                spreadRadius: 1.0,
                              ),
                            ]),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:[

                           Container(
                             padding:const EdgeInsets.only(top:18,bottom:18,left:15,right:15),
                             child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.start,
                               children:[
                                 Container(
                                   padding:const EdgeInsets.only(left: 10),
                                     child:Column(
                                      children: [
                                        Image.network(coupon.image,
                                        width: 70,height: 70,
                                        ),
                                         (widget.pageType!='vendor' && double.parse(coupon.minimumPurchasedAmount) <= currentCheckout.value.sub_total)?InkWell(
                                           onTap: (){

                                             _con.applyCoupon(coupon, 'direct');
                                           },
                                          child: Container(
                                            padding: const EdgeInsets.only(top:7),
                                            child:Text('APPLY',
                                            style: Theme.of(context).textTheme.titleSmall.merge( TextStyle(color:Theme.of(context).primaryColorDark,fontWeight:FontWeight.w700)),
                                            )
                                          ),
                                        ) : Container(
                                            padding: const EdgeInsets.only(top:7),
                                            child:Text('APPLY',
                                              style: Theme.of(context).textTheme.titleSmall.merge( TextStyle(color:Colors.grey.withOpacity(0.5),fontWeight:FontWeight.w700)),
                                            )
                                        ),

                                      ]
                                     )
                                 ),
                                 Expanded(
                                   child: Container(
                                     padding: const EdgeInsets.only(top:5,left: 40),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Text(coupon.title,
                                           style: Theme.of(context).textTheme.titleMedium,
                                         ),
                                       Container(
                                         padding: const EdgeInsets.only(top:3),
                                         child:Wrap(
                                           children: [
                                             coupon.couponType!='4'? Container(
                                                 padding: const EdgeInsets.only(top:8,right:5),
                                                 child:Text( coupon.discountType=='%'?'%':'${setting.value.defaultCurrency} OFF',
                                                   style: Theme.of(context).textTheme.bodySmall
                                                 )
                                             ):Container(
                                                 padding: const EdgeInsets.only(top:8,right:5),
                                                 child:Text(S.of(context).free_delivery,
                                                     style: Theme.of(context).textTheme.bodySmall
                                                 )
                                             ),
                                             Text(coupon.discount,
                                               style: Theme.of(context).textTheme.headlineLarge,
                                             ),
                                             Container(
                                                 padding: const EdgeInsets.only(top:10,left:5),
                                                 child:Text('COUPON',
                                                   style: Theme.of(context).textTheme.bodySmall
                                                 )
                                             ),
                                           ],
                                         ),
                                        ),
                                   Container(
                                     padding: const EdgeInsets.only(top:3),
                                     child: Text(coupon.terms,
                                     style: Theme.of(context).textTheme.bodySmall,
                                     ),
                                   ),
                                       ],
                                     ),
                                   )
                                 )

                               ]
                             ),
                           )





                            ]
                        )
                    )
                );

              }, separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 5);
            },),


          ])),

    ]);
  }
}



class TermsPopupHelper {

  static exit(context,content ) => showDialog(context: context, builder: (context) =>  TermsPopup(content: content,));
}
