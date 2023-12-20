
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import '../../generated/l10n.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';
import '../models/coupon.dart';
import '../repository/user_repository.dart';
import 'offer_details_widget.dart';


// ignore: must_be_immutable
class OfferSliderWidget extends StatefulWidget {
  String shopId;
  OfferSliderWidget({Key key, this.shopId}) : super(key: key);
  @override
  OfferSliderWidgetState createState() => OfferSliderWidgetState();
}

class OfferSliderWidgetState extends StateMVC<OfferSliderWidget> {


  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  CartController _con;

  OfferSliderWidgetState() : super(CartController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
    _con.listenForCoupons('vendor',widget.shopId,currentUser.value.id);
  }



  @override
  Widget build(BuildContext context) {
    return _con.couponList.isNotEmpty?Container(
      margin: const EdgeInsets.only(left:20,right:20,top:15,bottom:10),
      height:80,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).disabledColor.withOpacity(0.5),
            blurRadius: 1.5,
            spreadRadius:0.1,
          ),
        ],
      ),
      child:Row(
        children: [
          Expanded(
            child: PageView.builder(
                itemCount:   _con.couponList.length,
                controller: _pageController,
                itemBuilder: (BuildContext context, int index) {
                  return OfferSliderList(choice: _con.couponList[index]);

                },
                onPageChanged: (int index) {
                  setState(() {
                    _currentPageNotifier.value = index;
                  });

                }),
          ),
        Align(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Text('${ _currentPageNotifier.value+1} / ${_con.couponList.length}',
                    style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).primaryColorDark,fontWeight: FontWeight.bold)),
                    ),
                    CirclePageIndicator(
                      itemCount:   _con.couponList.length,
                      currentPageNotifier: _currentPageNotifier,
                      dotColor: Theme.of(context).disabledColor,
                      selectedDotColor:   Theme.of(context).primaryColorDark,
                    ),
                  ],
                )
              )
          ),

        ],
      )
    ):Container();

  }
}


// ignore: must_be_immutable
class OfferSliderList extends StatefulWidget {
  const OfferSliderList({Key key, this.choice}) : super(key: key);
  final CouponModel choice;
  @override
  State<OfferSliderList> createState() => _OfferSliderListState();
}

class _OfferSliderListState extends State<OfferSliderList> {



  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: (){

      },
      child: Container(
          padding: const EdgeInsets.only(left: 12),
          child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Image.network(widget.choice.image,
                  height: 50,width: 50,
                ),
                Expanded(
                    child:Container(
                        padding: const EdgeInsets.only(left: 12,top:15),
                        child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text(widget.choice.discountType=='%'?'${widget.choice.discount.toString()}% off | Above ${Helper.pricePrint(widget.choice.minimumPurchasedAmount)}':
                              '${Helper.pricePrint(widget.choice.discount.toString())} Off | Above ${Helper.pricePrint(widget.choice.minimumPurchasedAmount)}',
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(widget.choice.title,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ]
                        )
                    )
                ),

              ]
          )
      ),
    );
  }
}




void offerDetail(context, couponList) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            color: const Color(0xff737373),
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
                ),
                child:Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(


                          border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200],
                                width: 1,
                              ))),
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              S.of(context).offer_details,
                              style: Theme.of(context).textTheme.titleLarge,
                              textAlign: TextAlign.left,
                            ),
                          )),
                    ),
                    Expanded(
                        child:SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              OfferDetailsPart(pageType: 'vendor',couponList: couponList,),
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                    ),

                  ],

                )
            ),
          ),
        );
      });
}