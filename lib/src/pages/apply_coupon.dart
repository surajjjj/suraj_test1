
import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import '../elements/offer_details_widget.dart';
import '../repository/order_repository.dart';
import '../repository/user_repository.dart';
import '../controllers/cart_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';

class ApplyCoupon extends StatefulWidget {
  const ApplyCoupon({Key key}) : super(key: key);

  @override
  ApplyCouponState createState() => ApplyCouponState();
}

class ApplyCouponState extends StateMVC<ApplyCoupon> {
  CartController _con;

  ApplyCouponState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
   _con.listenForCoupons('all',currentCheckout.value.shopId,currentUser.value.id);
    super.initState();
  }

  int dropDownValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(
              color:Theme.of(context).colorScheme.background,
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(
              S.of(context).apply_coupons,
              style: Theme.of(context).textTheme.displaySmall,
            )),
        body: AnimationList(
            duration: 2000,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )
                  ),
                  child:Column(
                      children:[
                        Container(
                          padding: const EdgeInsets.only(left:10,right: 10),
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:BorderRadius.circular(15),
                                border: Border.all(
                                    width: 1,color: Theme.of(context).disabledColor.withOpacity(0.4)
                                )
                            ),
                            child: TextField(
                              cursorColor: Colors.black,
                              onChanged: (e){

                                if(e!='') {
                                  setState(() {
                                    _con.tempCouponList = _con.couponSearch(_con.couponList, e);
                                  });
                                } else {
                                  setState(() {
                                    _con.tempCouponList = _con.couponList;
                                  });
                                }
                              },

                              style: Theme.of(context).textTheme.titleSmall,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(12),
                                hintText: S.of(context).enter_coupon_code,
                                hintStyle: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(fontSize: 14)),



                                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                              ),
                            ),
                          ),
                        ),
                      ]
                  )
              ),
              OfferDetailsPart(couponList:  _con.tempCouponList,pageType: 'all')

            ])
    );
  }
}
