// ignore: must_be_immutable

import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/vendor.dart';
import '../repository/order_repository.dart';
import 'package:responsive_ui/responsive_ui.dart';



// ignore: must_be_immutable
class DeliveryMode extends StatefulWidget {
   Vendor shopDetails;
   DeliveryMode({Key key, this.shopDetails,}) : super(key: key);
  @override
  State<DeliveryMode> createState() => _DeliveryModeState();
}

class _DeliveryModeState extends State<DeliveryMode> {
  int selectedRadio;

  @override
  void initState() {
    super.initState();

    if(currentCheckout.value.deliverType!=0){
      selectedRadio = currentCheckout.value.deliverType;
    } else{
      selectedRadio = 1;
    }

  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      currentCheckout.value.deliverType = val;
    });
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [

      const SizedBox(height: 10),
      Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

           Container(
                  padding: const EdgeInsets.only(left:15,right:15),
                  child: Column(
                    children: [
                      widget.shopDetails.instant? Div(
                        colS:12,
                        colM:12,
                        colL:12,
                        child:Column(
                          children: [
                            InkWell(
                          onTap: () {
                            setSelectedRadio(1);
                          },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(
                                      decoration:const BoxDecoration(
                                          shape:BoxShape.circle
                                      ),
                                      child:ClipRRect(
                                          borderRadius:BorderRadius.circular(100),
                                          child:Image.asset('assets/img/instant_icon.png',
                                              fit: BoxFit.fill,
                                              width:60,height:60
                                          )
                                      )

                                  ),
                                  Expanded(
                                      child:Container(
                                        padding: const EdgeInsets.only(left:10),
                                        child:Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              Wrap(
                                                  children:[
                                                    Container(
                                                      padding: const EdgeInsets.only(top:0,),
                                                      child: Text(S.of(context).instant_delivery,style: Theme.of(context).textTheme.titleSmall,),
                                                    ),
    currentCheckout.value.deliverType==1?   Container(
                                                        margin: const EdgeInsets.only(left:8,right:15),
                                                        height:25,
                                                        width:100,
                                                        padding: const EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                            color: Colors.greenAccent.withOpacity(0.3),
                                                            borderRadius: const BorderRadius.all(Radius.circular(50.0))
                                                        ),

                                                        child:  const Center(
                                                          child:Text(
                                                              'Active',
                                                              style: TextStyle(color:Colors.green,height:1.1,fontSize:9,fontWeight: FontWeight.w600)
                                                          ),
                                                        ),

                                                    ):Container(),
                                                  ]
                                              ),

                                              Container(
                                                padding: const EdgeInsets.only(top:0,),
                                                child: Text(S.of(context).the_order_will_be_delivered_to_you_at_your_shared_address_delivery_charges_will_apply,
                                                  overflow: TextOverflow.ellipsis,maxLines: 4,
                                                  style: Theme.of(context).textTheme.bodySmall,),
                                              ),



                                            ]
                                        ),
                                      )
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(left:10),
                                      child:Text('${Helper.calculateTime(double.parse(widget.shopDetails.distance.replaceAll(',','')),int.parse(widget.shopDetails.handoverTime),false)}',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      )
                                  )



                                ],
                              ),
                            )
                          ],
                        ),
                      ):Container(),
                      const SizedBox(height: 20,),
                    widget.shopDetails.schedule? Div(
                        colS:12,
                        colM:12,
                        colL:12,
                        child:Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setSelectedRadio(2);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(
                                      decoration:const BoxDecoration(
                                          shape:BoxShape.circle
                                      ),
                                      child:ClipRRect(
                                          borderRadius:BorderRadius.circular(100),
                                          child:Image.asset('assets/img/clock.png',
                                              fit: BoxFit.fill,
                                              width:60,height:60
                                          )
                                      )

                                  ),
                                  Expanded(
                                      child:Container(
                                        padding: const EdgeInsets.only(left:10),
                                        child:Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                      Wrap(
                                                  children:[
                                                    Container(
                                                      padding: const EdgeInsets.only(top:0,),
                                                      child: Text(S.of(context).scheduled_delivery,style: Theme.of(context).textTheme.titleSmall,),
                                                    ),
                                                    currentCheckout.value.deliverType==2?   Container(
                                                        margin: const EdgeInsets.only(left:8,right:15),
                                                        height:25,
                                                        width:100,
                                                        padding: const EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                            color: Colors.greenAccent.withOpacity(0.3),
                                                            borderRadius: const BorderRadius.all(Radius.circular(50.0))
                                                        ),

                                                        child:  const Center(
                                                          child:Text(
                                                              'Active',
                                                              style: TextStyle(color:Colors.green,height:1.1,fontSize:9,fontWeight: FontWeight.w600)
                                                          ),
                                                        ),

                                                    ):Container(),
                                                  ]
                                              ),

                                              Container(
                                                padding: const EdgeInsets.only(top:0,),
                                                child: Text(S.of(context).the_order_will_be_delivered_to_you_at_your_shared_address_at_scheduled_time,
                                                  overflow: TextOverflow.ellipsis,maxLines: 4,
                                                  style: Theme.of(context).textTheme.bodySmall,),
                                              ),



                                            ]
                                        ),
                                      )
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(left:10),
                                      child:Text(Helper.priceDistance(widget.shopDetails.distance),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      )
                                  )



                                ],
                              ),
                            )
                          ],
                        ),
                      ):Container(),
                      const SizedBox(height: 20,),
                      widget.shopDetails.takeaway?Div(
                        colS:12,
                        colM:12,
                        colL:12,
                        child:Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setSelectedRadio(3);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  Container(
                                      decoration:const BoxDecoration(
                                          shape:BoxShape.circle
                                      ),
                                      child:ClipRRect(
                                          borderRadius:BorderRadius.circular(100),
                                          child:Image.asset('assets/img/takeaway.png',
                                              fit: BoxFit.fill,
                                              width:60,height:60
                                          )
                                      )

                                  ),
                                  Expanded(
                                      child:Container(
                                        padding: const EdgeInsets.only(left:10),
                                        child:Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
 Wrap(
                                                  children:[
                                                    Container(
                                                      padding: const EdgeInsets.only(top:0,),
                                                      child: Text(S.of(context).takeaway,style: Theme.of(context).textTheme.titleSmall,),
                                                    ),
                                                    currentCheckout.value.deliverType==3?   Container(
                                                        margin: const EdgeInsets.only(left:8,right:15),
                                                        height:25,
                                                        width:100,
                                                        padding: const EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                            color: Colors.greenAccent.withOpacity(0.3),
                                                            borderRadius: const BorderRadius.all(Radius.circular(50.0))
                                                        ),

                                                        child: const Center(
                                                          child:Text(
                                                              'Active',
                                                              style: TextStyle(color:Colors.green,height:1.1,fontSize:9,fontWeight: FontWeight.w600)
                                                          ),
                                                        ),

                                                    ):Container(),
                                                  ]
                                              ),

                                              Container(
                                                padding: const EdgeInsets.only(top:0,),
                                                child: Text(S.of(context).you_will_have_to_pick_up_the_order_yourself_from_the_restaurant_the_order_wont_be_delivered_to_your_location,
                                                  overflow: TextOverflow.ellipsis,maxLines: 4,
                                                  style: Theme.of(context).textTheme.bodySmall,),
                                              ),



                                            ]
                                        ),
                                      )
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(left:10),
                                      child:Text(Helper.calculateTime(double.parse(widget.shopDetails.distance.replaceAll(',','')),int.parse(widget.shopDetails.handoverTime),false),
                                        style: Theme.of(context).textTheme.bodySmall,
                                      )
                                  )



                                ],
                              ),
                            )
                          ],
                        ),
                      ):Container(),
                    ],
                  ),
                ),





          ])),

    ]);
  }
}