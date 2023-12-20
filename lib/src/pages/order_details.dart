import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodzo/src/models/addongroup_model.dart';
import '../../generated/l10n.dart';
import '../components/points_clipper.dart';
import '../controllers/order_controller.dart';
import '../elements/checkout_list_widget.dart';
import '../helpers/helper.dart';
import '../models/cart_responce.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'map3.dart';

// ignore: must_be_immutable
class OrderDetails extends StatefulWidget {
  String orderId;
  OrderDetails({Key key, this.orderId}) : super(key: key);
  @override
  OrderDetailsState createState() => OrderDetailsState();
}

class OrderDetailsState extends StateMVC<OrderDetails> {

  OrderController _con;

  OrderDetailsState() : super(OrderController()) {
    _con = controller;
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _con.listenForInvoiceDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    var greyColor =  Colors.grey[200];
    var amberColor = Colors.amber;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
          children:[
            Container(
              width: double.infinity,
              height: 160,
              decoration: const BoxDecoration(
                  image:DecorationImage(
                      image:AssetImage('assets/img/cover1.jpg',
                      ),
                      fit: BoxFit.fill
                  )
              ),
              child:Container(
                padding: const EdgeInsets.only(top:35,left: 10.0),
                child:  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(left: 10,top:10,right:10),
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
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            margin:const EdgeInsets.only(top:13),
                            child:Text(
                            '${S.of(context).order_ID} #${widget.orderId}',
                            style: Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary,
                            )),
                            textAlign: TextAlign.left,
                          ),),
                          _con.invoiceDetailsData.status!=null? Text(
                            '${_con.invoiceDetailsData.status} | ${S.of(context).items} ${Helper.pricePrint(_con.invoiceDetailsData.payment.grand_total.toString())}',
                            style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary,)),
                            textAlign: TextAlign.left,
                          ):const Text(''),

                        ]),
                      ),

                    ],
                  ),

                ])
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
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight:Radius.circular(30) )),

                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Column(children: [
                              const SizedBox(height: 10),
                              Container(
                                  width:double.infinity,
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).dividerColor
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Text(S.of(context).items)
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: _con.invoiceDetailsData.productDetails.length,
                                      shrinkWrap: true,
                                      primary: false,
                                      padding: const EdgeInsets.only(top: 10),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, int index) {
                                        CartResponse orderDetails = _con.invoiceDetailsData.productDetails.elementAt(index);


                                        return Container(
                                          margin: const EdgeInsets.only(left: 10,right: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                margin: const EdgeInsets.only(top:3),
                                                child:ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child:Image.network(orderDetails.image,
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.cover,


                                                    )
                                                ),),
                                              const SizedBox(width: 15),
                                              Flexible(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: <Widget>[

                                                    Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.only(top:2),
                                                          child:Container(
                                                            padding: const EdgeInsets.only(left:2),
                                                            child:Column(
                                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                              mainAxisAlignment:MainAxisAlignment.start,
                                                              children:[
                                                                RichText(
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines:2,
                                                                  text: TextSpan(text: '${orderDetails.qty} x ',
                                                                      style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(height:1.4)),

                                                                      children: [
                                                                        TextSpan(
                                                                          text:  orderDetails.product_name,

                                                                          style: Theme.of(context).textTheme.titleSmall,

                                                                        ),

                                                                      ]),
                                                                ),
                                                                orderDetails.multipleVariant?Text(orderDetails.variantName??''):Container(),
                                                                Container(
                                                                  margin:const EdgeInsets.only(top:5),
                                                                  child:Column(
                                                                    crossAxisAlignment:CrossAxisAlignment.start,
                                                                      mainAxisAlignment:MainAxisAlignment.start,
                                                                    children:List.generate(orderDetails.addonGroup.length, (index) {
                                                                      AddonGroupModel  addonGroupData = orderDetails.addonGroup.elementAt(index);
                                                                      return Container(
                                                                          margin:const EdgeInsets.only(bottom:5),
                                                                          child: Column(
                                                                            children:
                                                                                <Widget>[
                                                                                  Text(addonGroupData.name),
                                                                                  Row(
                                                                            children: List.generate(addonGroupData.addon.length, (index) {
                                                                                                return Text('${addonGroupData.addon[index].name}  x ${Helper.pricePrint(addonGroupData.addon[index].price)}'); })),
                                                                            ],
                                                                          ),


                                                                      );
                                                                    })
                                                                  )
                                                                )
                                                              ]
                                                            )
                                                          ),
                                                        )
                                                    ),


                                                    const SizedBox(width: 8),
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: <Widget>[
                                                        //  Helper.getPrice(Helper.getOrderPrice(productOrder), context, style: Theme.of(context).textTheme.subtitle1),
                                                        Container(
                                                            margin:const EdgeInsets.only(bottom:5,top:5,right:5),
                                                            decoration:BoxDecoration(
                                                              borderRadius:BorderRadius.circular(3),
                                                              color: Theme.of(context).primaryColor,
                                                              border:Border.all(
                                                                  width: 1,
                                                                  color: 1==1?Colors.green:Colors.brown
                                                              ),

                                                            ),
                                                            child:const Icon(Icons.circle,size:11,color:1==1 ?Colors.green:Colors.brown)
                                                        ),
                                                        Text(
                                                          Helper.pricePrint(orderDetails.price),
                                                          style: Theme.of(context).textTheme.titleSmall,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5,)
                                            ],
                                          ),
                                        );
                                      }),
                                ]),),
                              Container(
                                  padding: const EdgeInsets.only(top:20),
                                  width: double.infinity,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 10,),
                                        Expanded(
                                          child:Padding(
                                            padding: const EdgeInsets.only(top:3,left:8,right:20),
                                            child: Text(_con.invoiceDetailsData.orderType=='1'?
                                            S.of(context).your_order_type_is_instant_delivery:_con.invoiceDetailsData.orderType=='2'?
                                            'Your Order type is Scheduled Delivery (${_con.invoiceDetailsData.deliverySlot})':'Your Order type is Takeaway',
                                              style: Theme.of(context).textTheme.bodyMedium,
                                              textAlign: TextAlign.left,
                                            ),
                                          ),

                                        ),


                                      ],
                                    ),

                                  ])
                              ),
                              const SizedBox(height: 10),
                              Container(
                                  width:double.infinity,
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).dividerColor
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child:Text(S.of(context).bill_details)
                              ),
                              Container(
                                  padding: const EdgeInsets.only(left: 0, right: 0),
                                  width: double.infinity,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                    Container(
                                        margin: const EdgeInsets.only(top:18,bottom:5),
                                        decoration:const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15),
                                              topLeft:  Radius.circular(15)
                                          ),

                                        ),
                                        child:ClipPath(

                                            clipper: PointsClipper(

                                            ),
                                            child:Container(

                                                decoration:BoxDecoration(
                                                  color: Theme.of(context).primaryColor,
                                                  borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(15),
                                                      topLeft:  Radius.circular(15)
                                                  ),

                                                ),
                                                child:Container(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[

                                                      const SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Text(S.of(context).item_total, style: Theme.of(context).textTheme.titleSmall),
                                                          Text((Helper.pricePrint(_con.invoiceDetailsData.payment.sub_total.toString())), style: Theme.of(context).textTheme.titleSmall),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: <Widget>[


                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: <Widget>[
                                                                     Text('${S.of(context).delivery_partner_fee} ' , style: const TextStyle(color: Colors.blue)),
                                                                    _con.invoiceDetailsData.payment.delivery_fees  != 0
                                                                        ? Text('${Helper.pricePrint(_con.invoiceDetailsData.payment.delivery_fees.toString())}',
                                                                        style: Theme.of(context).textTheme.titleSmall)
                                                                        : Text(S.of(context).free, style: Theme.of(context).textTheme.titleSmall),
                                                                  ],
                                                                ),

                                                                
                                                                const SizedBox(height: 10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: <Widget>[
                                                                    Text(S.of(context).discount, style: const TextStyle(color: Colors.green)),
                                                                    Text('${Helper.pricePrint(_con.invoiceDetailsData.payment.discount.toString())}',
                                                                        style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color: Colors.green))),
                                                                  ],
                                                                ),
                                                                DottedLine(
                                                                  dashColor: Theme.of(context).disabledColor,
                                                                ),
                                                                const SizedBox(height: 20),

                                                                _con.invoiceDetailsData.payment.delivery_tips!=0?const SizedBox(height: 10):Container(),


                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: <Widget>[
                                                                    Text(S.of(context).delivery_tip, style: Theme.of(context).textTheme.titleSmall),
                                                                    InkWell(
                                                                      onTap: (){},
                                                                      child: Text(Helper.pricePrint(_con.invoiceDetailsData.payment.delivery_tips.toString()),
                                                                          style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).primaryColorDark,

                                                                          ))
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height:10),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: <Widget>[
                                                                    InkWell(
                                                                      onTap: (){
                                                                       TaxPopupHelper.exit(context,_con.invoiceDetailsData.payment.tax,_con.invoiceDetailsData.payment.packingCharge);
                                                                      },
                                                                      child:Wrap(
                                                                          children:[
                                                                            Text(S.of(context).taxes_and_charges, style: Theme.of(context).textTheme.titleSmall),
                                                                            const SizedBox(width:5),
                                                                            const Icon(Icons.arrow_drop_down_outlined)
                                                                          ]
                                                                      ),
                                                                    ),
                                                                    Text(Helper.pricePrint((_con.invoiceDetailsData.payment.tax+_con.invoiceDetailsData.payment.packingCharge).toString()),
                                                                        style: Theme.of(context).textTheme.titleSmall
                                                                    ),

                                                                  ],
                                                                ),




                                                                const SizedBox(height: 10),

                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 7),

                                                      DottedLine(
                                                        dashColor: Theme.of(context).disabledColor,
                                                      ),
                                                      const SizedBox(height: 15),
                                                      Container(
                                                        alignment: Alignment.center,
                                                        margin:const EdgeInsets.only(bottom:25),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              '${S.of(context).to_pay} ${_con.invoiceDetailsData.payment.method}',
                                                              style: Theme.of(context).textTheme.titleSmall,
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              '${Helper.pricePrint(_con.invoiceDetailsData.payment.grand_total.toString())}',
                                                              style: Theme.of(context).textTheme.titleSmall,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            ))
                                    ),

                                    _con.invoiceDetailsData.status=='Completed'? InkWell(
                                        onTap: (){
                                          if( _con.invoiceDetailsData.rating=='0'){
                                            Navigator.of(context).pushNamed('/shop_rating', arguments: _con.invoiceDetailsData);
                                          }

                                        },
                                        child: Column(
                                            children:[
                                              ListTile(
                                                contentPadding: const EdgeInsets.all(0),
                                                leading: CircleAvatar(
                                                  // ignore: deprecated_member_use
                                                  backgroundImage: NetworkImage(_con.invoiceDetailsData.vendorLogo),
                                                  maxRadius: 23,

                                                ),
                                                title:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children:[
                                                      Text(_con.invoiceDetailsData.addressShop.username,
                                                        style: Theme.of(context).textTheme.titleMedium,
                                                      ),
                                                      Text( _con.invoiceDetailsData.rating=='0'?S.of(context).give_your_rating:S.of(context).rating,
                                                        style: Theme.of(context).textTheme.bodySmall,
                                                      ),

                                                    ]
                                                ),
                                              ),




                                              RatingBar.builder(
                                                initialRating: double.parse(_con.invoiceDetailsData.rating),
                                                minRating: 1,
                                                ignoreGestures: true,
                                                tapOnlyMode: true,
                                                direction: Axis.horizontal,
                                                allowHalfRating: false,
                                                itemCount: 5,
                                                itemSize: 25,
                                                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                itemBuilder: (context, _) => Icon(
                                                  Icons.star,
                                                  color:amberColor,
                                                ),
                                                onRatingUpdate: (rating) {
                                                 /* print(rating);*/
                                                },

                                              ),
                                            ]
                                        )

                                    ):Container(),
                                    Container(
                                      padding: const EdgeInsets.only(top:20),
                                      child:Column(
                                        children: [



                                          const SizedBox(height:25),
                                          _con.invoiceDetailsData.status=='Completed'? InkWell(
                                              onTap: (){
                                                if( _con.invoiceDetailsData.driverRating=='0'){

                                                    Navigator.of(context).pushNamed('/driver_rating', arguments: _con.invoiceDetailsData);

                                                }

                                              },
                                              child: Column(
                                                children:[
                                                  ListTile(
                                                    contentPadding: const EdgeInsets.all(0),
                                                    leading: const CircleAvatar(
                                                      // ignore: deprecated_member_use
                                                      backgroundImage: AssetImage("assets/img/delivery_boy.png"),
                                                      maxRadius: 26,

                                                    ),
                                                    title:Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Text('im ${_con.invoiceDetailsData.driverName}, your delivery partner',
                                                            style: Theme.of(context).textTheme.titleMedium,
                                                          ),
                                                          Text(_con.invoiceDetailsData.rating=='0'?S.of(context).give_your_rating:S.of(context).rating,
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),

                                                        ]
                                                    ),
                                                  ),

                                                  RatingBar.builder(
                                                    initialRating: double.parse(_con.invoiceDetailsData.driverRating),
                                                    minRating: 1,
                                                    ignoreGestures: true,
                                                    tapOnlyMode: true,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: false,
                                                    itemCount: 5,
                                                    itemSize: 25,
                                                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                                    itemBuilder: (context, _) => Icon(
                                                      Icons.star,
                                                      color: amberColor,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                     /* print(rating);*/
                                                    },

                                                  ),],)):Container(),

                                        ],
                                      ),
                                    ),
                                    const SizedBox(height:20),
                                  ])
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: 1,
                                      shrinkWrap: true,
                                      primary: false,
                                      padding: const EdgeInsets.only(top: 10),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, int index) {
                                        return Column(children: [


                                          const SizedBox(height:20),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(bottom: 20),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                    color: Theme.of(context).dividerColor,
                                                    width: 1,
                                                  )),
                                            ),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                              const Padding(
                                                padding:EdgeInsets.only(top:6),
                                                child:  CircleAvatar(
                                                  // ignore: deprecated_member_use
                                                  backgroundImage: AssetImage("assets/img/location_mark.png"),
                                                  maxRadius: 23,

                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                  Text(currentUser.value.name, style: Theme.of(context).textTheme.titleSmall),
                                                  Text(
                                                    _con.invoiceDetailsData.addressUser.addressSelect??'',
                                                    style: Theme.of(context).textTheme.bodySmall,
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ]),
                                              ),
                                            ]),
                                          ),
                                        ]);
                                      }),




                                  _con.invoiceDetailsData.status=='Completed'?   Container(
                                      padding: const EdgeInsets.only(top:20),
                                      width: double.infinity,
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:const EdgeInsets.only(top:6),
                                              child: Icon(Icons.check, color: Theme.of(context).colorScheme.secondary),
                                            ),
                                            Expanded(
                                              child:Padding(
                                                padding: const EdgeInsets.only(top:3,left:8,right:20),
                                                child: Text(
                                                  'Order delivered on  ${timeago.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_con.invoiceDetailsData.deliveryTime)*1000))} by ${_con.invoiceDetailsData.driverName}',
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),

                                            ),


                                          ],
                                        ),

                                      ])
                                  ):Container(),





                                ]),
                              ),
                            ]),

                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.only(left:0),
                        child: _con.invoiceDetailsData.status!='Completed'?Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width:1,color:greyColor,
                                ),
                              )
                          ),
                          // ignore: deprecated_member_use
                          child: ElevatedButton(
                              onPressed: () {
                                if(  _con.invoiceDetailsData.status=='Completed') {


                                  Navigator.of(context).pushNamed('/rating1',);
                                }else if( _con.invoiceDetailsData.status=='Placed' || _con.invoiceDetailsData.status=='Accepted'  ||        _con.invoiceDetailsData.status=='Processing'  ||        _con.invoiceDetailsData.status=='Ready' ||        _con.invoiceDetailsData.status=='Shipped'){
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          MapLiveTrack(orderId: widget.orderId,
                                            pageType: 'viewDetails',)));
                                }
                              },
                              style:ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15),
                                backgroundColor: greyColor,
                              ),

                              child: Text(
                                _con.invoiceDetailsData.status??'',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    .merge(const TextStyle(color: Colors.deepOrange)),
                              )),
                        ): _con.invoiceDetailsData.status=='Completed' ?
                        SizedBox(
                            width:double.infinity,
                            child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Image.asset('assets/img/complete.png',
                                    height: 60,width:60,
                                  ),

                                  Text(
                                      _con.invoiceDetailsData.status,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium

                                  )

                                ]
                            )
                        )
                        /*FlatButton(
                    onPressed: () {

                    },
                    padding: EdgeInsets.all(15),
                    color: Colors.grey[200],
                    child: Text(
                      _con.invoiceDetailsData.status,
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          .merge(TextStyle(color: Colors.deepOrange)),
                    ))*/
                            :Container()
                    ),
                  ),
                ],
              ),
            )


          ]
      ),

    );




  }

}















