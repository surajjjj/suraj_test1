
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../generated/l10n.dart';
import '../Animation/fade_animation.dart';
import '../helpers/helper.dart';
import '../models/cart_responce.dart';
import '../models/order_list.dart';



// ignore: must_be_immutable
class OrderItemWidget extends StatefulWidget {
  final bool expanded;
  OrderList orderDetails;
  OrderItemWidget({Key key, this.expanded,this.orderDetails }) : super(key: key);

  @override
  OrderItemWidgetState createState() => OrderItemWidgetState();
}

class OrderItemWidgetState extends StateMVC<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd-M-yyyy hh:mm a');
    int timeInMillis = int.parse(widget.orderDetails.sale_datetime);

    return  FadeAnimation(
        1.4,
        InkWell(
          onTap: (){
            Navigator.of(context).pushNamed('/orderDetails', arguments: widget.orderDetails.sale_code);
          },
          child: Container(
      margin: const EdgeInsets.only(left:10,right:10),
      padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.2),
                  blurRadius: 1,
                  spreadRadius: 0.3,
                ),
              ],
              color: Theme.of(context).primaryColor),
      child: Column(
          children: [

            Container(
              margin: const EdgeInsets.only(left:0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                Container(
                    margin: const EdgeInsets.only(top:0),
                    child:ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:Image.network(widget.orderDetails.vendorLogo,
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,


                        )
                    ),),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin:const EdgeInsets.only(top:0),
                                  child:Text(widget.orderDetails.vendorName,
                                    style: Theme.of(context).textTheme.titleSmall,
                                  )
                              ),
                              Text(widget.orderDetails.vendorLandmark,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 2,
                                softWrap: true,
                              ),
                              Text('',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),

                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              margin:const EdgeInsets.only(bottom:10),
                              height:30,
                              child:  ElevatedButton(
                                  onPressed: (){

                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(5),
                                    backgroundColor: widget.orderDetails.status=='Completed'?Colors.green:  widget.orderDetails.status=='Cancelled'?Colors.red:Colors.blue
                                  ),
                                  child: Text(
                                    widget.orderDetails.status,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        .merge( TextStyle(color: Theme.of(context).colorScheme.primary))
                                  )),
                            ),
                            Wrap(
                                children:[
                                  Container(
                                    margin:const EdgeInsets.only(top:2),
                                    child:InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed('/orderDetails', arguments: widget.orderDetails.sale_code);
                                      },

                                      child: Text(
                                        S.of(context).view_more,
                                        style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: Theme.of(context).primaryColorDark)),
                                      ),
                                    ),),
                                  Icon(Icons.arrow_right,color:Theme.of(context).primaryColorDark)
                                ]
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: widget.orderDetails.product_details.length,
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.only(top: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, int index) {

                CartResponse productDetails = widget.orderDetails.product_details.elementAt(index);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[

                    Container(
                      margin: const EdgeInsets.only(top:10,left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top:3),
                            child:ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:Image.network(productDetails.image,
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
                                        child:RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines:2,
                                          text: TextSpan(text: '${productDetails.qty} x ',
                                              style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(height:1.4)),

                                              children: [
                                                TextSpan(
                                                  text:  productDetails.product_name,

                                                  style: Theme.of(context).textTheme.titleSmall,

                                                )
                                              ]),
                                        ),),
                                  )
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    //  Helper.getPrice(Helper.getOrderPrice(productOrder), context, style: Theme.of(context).textTheme.subtitle1),
                                    Container(
                                        margin:const EdgeInsets.only(top:5,right:5,bottom:5),
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
                                      Helper.pricePrint(productDetails.price),
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ]
                );
              },

              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
            ),


            Container(
              margin: const EdgeInsets.only(top:20),
              child:DottedLine(
                dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top:10,),
              child:Row(
                children: [
                    Expanded(
                      child:Text(
                              f.format(DateTime.fromMillisecondsSinceEpoch(timeInMillis * 1000)),
                        style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(height:1.2)),
                      )
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      children: [
                        Text(
                          Helper.pricePrint(widget.orderDetails.grand_total.toString()),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top:3,left:3),
                          child:InkWell(
                          child: Icon(Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: Theme.of(context).disabledColor,
                          )
                        ),),
                      ],
                    )
                  )
                ],
              )
            ),
            Container(
              margin: const EdgeInsets.only(top:10,),
              child:DottedLine(
                dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
              ),
            ),
            widget.orderDetails.status=='Completed' &&  widget.orderDetails.rating!='0'? Container(
                margin: const EdgeInsets.only(top:20),
                child:InkWell(
                  child: Row(
                    children: [
                      Text(
                        S.of(context).rating,
                        style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).primaryColorDark)),
                      ),
                      Expanded(
                          child:Container(
                            padding: const EdgeInsets.only(top:2,left:10),
                            child:SmoothStarRating(
                                allowHalfRating: false,
                                starCount: 5,
                                rating: double.parse(widget.orderDetails.rating),
                                size: 23.0,
                                color: const Color(0xFFFEBF00),
                                borderColor: const Color(0xFFFEBF00),
                                spacing: 0.0),
                          )
                      ),
                     1==2? Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(22),
                              ),
                              child:MaterialButton(
                                height: 35,
                                elevation: 0,
                                color: Theme.of(context).primaryColorDark,
                                shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
                                child: Center(
                                  child:   Wrap(
                                      children:[
                                        Icon(
                                            Icons.replay_rounded,size:18,
                                            color: Theme.of(context).colorScheme.primary
                                        ),
                                        Container(
                                            padding: const EdgeInsets.only(top:0,left:5,right:5),
                                            child:Text('Reorder',
                                                textAlign: TextAlign.center,
                                                style:TextStyle(
                                                    color: Theme.of(context).colorScheme.primary
                                                )
                                            )
                                        ),

                                      ]
                                  ),
                                ),
                                onPressed: () {
                                },
                              ),
                          ),
                      ):Container()
                    ],
                  ),
                )
            ):Container(),
          ],
      )
    ),
        ));
  }
}
