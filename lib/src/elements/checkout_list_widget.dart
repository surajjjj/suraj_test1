import 'package:dotted_line/dotted_line.dart';
import '../components/points_clipper.dart';
import '../models/coupon.dart';
import '../components/constants.dart';
import '../models/tips.dart';
import '../pages/apply_coupon.dart';
import '../repository/settings_repository.dart';
import '../helpers/helper.dart';
import '../repository/order_repository.dart';
import '../models/cart_responce.dart';
import '../repository/product_repository.dart';
import '../repository/user_repository.dart';
import '../Widget/custom_divider_view.dart';
import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import 'delivery_mode_widget.dart';
import 'product_box3_widget.dart';
import '../repository/product_repository.dart' as cart_repo;
import '../../generated/l10n.dart';
import 'tax_popup_widget.dart';
import 'time_slot.dart';

// ignore: must_be_immutable
class CheckoutListWidget extends StatefulWidget {
  CheckoutListWidget({Key key, this.con, }) : super(key: key);
  CartController con;

  @override
  State<CheckoutListWidget> createState() => _CheckoutListWidgetState();
}

class _CheckoutListWidgetState extends State<CheckoutListWidget> {
  bool ratingOne = false;
  int selectedRadio;

  @override
  void initState() {

    widget.con.getOriginalDistance();
    widget.con.getTimeSlot();
    currentCheckout.value.deliverType = 1;

    if(currentCheckout.value.couponStatus){
      currentCheckout.value.couponStatus = false;
      currentCheckout.value.couponCode = '';
      currentCheckout.value.couponData = CouponModel();
    }
    super.initState();
    selectedRadio = 1;

  }
  setDeliveryType(int val) {
    setState(() {
      selectedRadio = val;
      currentCheckout.value.deliverType = val;
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         ValueListenableBuilder(
              valueListenable: cart_repo.currentCart,
              builder: (context, setting, _) {
                return Container(
                    margin: const EdgeInsets.only(left: 15,right: 15,),
                    decoration:BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.1),
                          blurRadius: 1,
                          spreadRadius:0.5,
                        ),
                      ],
                    ),
                    child:Column(
                      children:[
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: currentCart.value.length,
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.only(top: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, int index) {
                             CartResponse cartResponse = currentCart.value.elementAt(index);
                            return ProductBox3Widget(con: widget.con, productDetails: cartResponse,id: index,);
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 0,);
                          },
                        ),
                        const CustomDividerView(
                          dividerHeight: 1.5,
                        ),
                        currentCheckout.value.instructionNote==null ||  currentCheckout.value.instructionNote==''?Container(
                            padding: const EdgeInsets.only(left:17),
                            child:Row(
                              children: [
                                Expanded(
                                  child: Text(S.of(context).write_instructions_for_restaurant,
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                                IconButton(
                                  onPressed: (){
                                    specialCookingBottomSheet();
                                  },
                                  icon: Icon(Icons.add_circle_outline,
                                    color: priceColor1,
                                  ),
                                )
                              ],
                            )
                        ):Container(
                          margin:const EdgeInsets.only(bottom:15,top: 10),
                            child:Row(
                            children: [
                              Expanded(
                                child:Container(
                                margin:  const EdgeInsets.only(left:17),
                                child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Text(
                                      S.of(context).cooking_instruction,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                    Text(currentCheckout.value.instructionNote,
                                    style: Theme.of(context).textTheme.bodySmall
                                    )
                                  ]
                                )
                              ),),
                              Align(
                                alignment:Alignment.topRight,
                                child:InkWell(
                                  onTap: (){
                                    widget.con.clearInstructionNote();
                                  },
                                  child:const Icon(Icons.delete_outline,color:Colors.red,size:20)
                                )
                              )
                            ],
                          ))

                      ]
                    )
                );
              }),


          Container(
              padding: const EdgeInsets.only(top:20,left:17,right:17),
              child:Text(S.of(context).offers_benefits,
                style: Theme.of(context).textTheme.displayMedium,
              )
          ),
          Container(
              margin: const EdgeInsets.only(top:18,left: 17,right: 17),
              padding:const EdgeInsets.all(15),
              decoration:BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.1),
                    blurRadius: 1,
                    spreadRadius:0.5,
                  ),
                ],
              ),
              child: !widget.con.couponStatus
                  ? InkWell(
                onTap: () async {
                  var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>  const ApplyCoupon(),
                        fullscreenDialog: true,
                      ));

                  setState(() {
                    if (result != null) {
                      widget.con.couponStatus = result;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.local_offer, size: 20.0, color: Colors.grey[700]),
                      const SizedBox(width: 10),
                      Text(S.of(context).apply_coupons, style: Theme.of(context).textTheme.titleSmall),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                    ],
                  ),
                ),
              ):Column(
                  children:[
                    Row(
                        children:[
                          Expanded(
                            child: Container(
                                margin:const EdgeInsets.only(right:15),
                                child:Text('"${currentCheckout.value.couponCode}", applied',
                                  style: Theme.of(context).textTheme.titleMedium,
                                )
                            ),
                          ),
                          InkWell(
                              onTap:(){
                                widget.con.removeCoupon();
                              },
                              child:Text(S.of(context).remove,
                                style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).primaryColorDark)),
                              )
                          )


                        ]
                    ),
                    const SizedBox(height:5),
                    Row(
                        children:[
                          const Icon(Icons.check, size: 20.0, color:Colors.green),
                          Expanded(
                              child: Wrap(
                                  children:[
                                    Container(
                                        margin:const EdgeInsets.only(top:0,left:2),
                                        child:Text(Helper.pricePrint(currentCheckout.value.discount.toString()),
                                          style: Theme.of(context).textTheme.titleMedium.merge(const TextStyle(color:Colors.green)),
                                        )
                                    ),
                                    Container(
                                        margin:const EdgeInsets.only(left:2),
                                        child:Text('  coupon savings',
                                          style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(height:1.5)),

                                        )
                                    )
                                  ]
                              )
                          ),


                        ]
                    ),


                  ]
              )
          ),
          Container(
              padding: const EdgeInsets.only(top:20,left:17,right:17),
              child: Wrap(
              children: [
                Text(
                  S.of(context).thank_your_partner_with_tip,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              /*  Container(
                    padding: const EdgeInsets.only(left:5),
                    child: Icon(Icons.help_outline,color:priceColor1 ,)), */

                // Text(S.of(context).how_it_works, style: Theme.of(context).textTheme.bodyText2.merge(TextStyle(color: Colors.blue)))
              ])
          ),


          setting.value.deliveryTips &&  currentCheckout.value.deliverType!=3  ?
          Container(
              margin: const EdgeInsets.only(top:18,left: 17,right: 17),
              decoration:BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12.withOpacity(0.1),
                    blurRadius: 1,
                    spreadRadius:0.5,
                  ),
                ],
              ),
              child:Container(
                padding: const EdgeInsets.all(15),
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.of(context).the_amount_will_be_credited_to_the_partners_tip_jar,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 20),
                          Wrap(spacing: 10,runSpacing: 15,
                              children: List.generate(  currentTips.value.length, (index){
                                Tips tipsData =   currentTips.value.elementAt(index);

                                return     GestureDetector(
                                    onTap: () => {
                                      // ignore: avoid_function_literals_in_foreach_calls
                                      currentTips.value.forEach((l) {
                                        setState(() {
                                          l.selected = false;

                                        });
                                      }),


                                      if(tipsData.amount.toDouble()!=currentCheckout.value.delivery_tips){

                                        tipsData.selected = true,
                                        currentCheckout.value.delivery_tips = tipsData.amount.toDouble(),


                                      }else{

                                        tipsData.selected = false,
                                        currentCheckout.value.delivery_tips = 0,
                                      },

                                      widget.con.grandSummary(),

                                    },
                                    child:Column(
                                      children:[
                                        Container(
                                            width: 70,


                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 3), // changes position of shadow
                                                ),
                                              ],
                                              color: tipsData.selected?Colors.deepPurpleAccent:Theme.of(context).primaryColor,
                                            ),
                                            child: Center(
                                                child: Column(
                                                  children:[
                                                    Container(
                                                      padding: const EdgeInsets.only(top:5,left:10,right:10,bottom:10),
                                                      child:Text(
                                                        Helper.pricePrint(tipsData.amount.toString())
                                                      ),
                                                    ),

                                                  ]
                                                )
                                            )
                                        ),

                                      ]
                                    )
                                );


                              })





                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          )):Container(),
          Container(
              margin:const EdgeInsets.only(left:15,top:20,),
              child:Wrap(
                  children:[
                    Text(S.of(context).delivery_instruction,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                   /* Container(
                      margin:const EdgeInsets.only(left:10,top:5),
                      child:Badge(
                        toAnimate: false,
                        shape: BadgeShape.square,
                        elevation: 0,
                        padding: const EdgeInsets.all(3),
                        borderSide: BorderSide(width: 1,color:Theme.of(context).dividerColor),
                        badgeColor: Theme.of(context).primaryColorDark,
                        borderRadius: BorderRadius.circular(4),
                        badgeContent: Text('NEW', style:TextStyle(fontSize:10,color: Theme.of(context).colorScheme.primary)),
                      ),
                    ) */

                  ]
              )
          ),
          Container(
            height:97,
            margin: const EdgeInsets.only(bottom: 10,top: 10),
            child:ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: deliveryInstruction.length,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.only(right:10,left:10,),
                itemBuilder: (context, index) {
                DeliveryInstruction  deliveryInstructionData = deliveryInstruction.elementAt(index);


                  return  InkWell(
                    onTap: (){
                      for (var l in deliveryInstruction) {
                        setState(() {
                          l.selected = false;

                        });
                      }
                      if(deliveryInstructionData.name!=currentCheckout.value.deliveryInstruction){
                        deliveryInstructionData.selected = true;
                      currentCheckout.value.deliveryInstruction= deliveryInstructionData.name;

                      }else{
                        currentCheckout.value.deliveryInstruction = '';
                      deliveryInstructionData.selected = false;
                      }

                    },
                    child: Container(
                        margin:const EdgeInsets.only(left :5),
                        child:Container(
                          width:size.width * 0.27,
                          margin: const EdgeInsets.only(right:5),

                          decoration: BoxDecoration(
                            color:   deliveryInstructionData.selected?const Color(0xFFc7fae0):Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15),
                          ),


                          child:Container(

                              padding: const EdgeInsets.only(left:10,right:10,top:16,bottom:12),

                              child:Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Icon(deliveryInstructionData.id==1?Icons.gif_box:deliveryInstructionData.id==2?Icons.local_police_rounded:
                                    deliveryInstructionData.id==3?Icons.wifi_calling:Icons.notification_important_sharp,size:20,color:Theme.of(context).disabledColor),
                                    Container(
                                        margin: const EdgeInsets.only(top:10),
                                        child:Text(deliveryInstructionData.name,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        )
                                    )
                                  ]
                              )
                          ),






                        )
                    ),
                  );
                }
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top:20,left:17,right:17),
              child:Text(S.of(context).delivery_mode,
                style: Theme.of(context).textTheme.displayMedium,
              )
          ),
          InkWell(
            onTap: (){


                deliveryMode(context,currentCheckout.value.vendor);


            },
            child: Container(
                margin: const EdgeInsets.only(top:18,left: 17,right: 17),
                decoration:BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      blurRadius: 1,
                      spreadRadius:0.5,
                    ),
                  ],
                ),
            child:     currentCheckout.value.deliverType==1?Container(
                padding: const EdgeInsets.only(left:20,top:20,bottom:20, right: 20),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:const [
                            SizedBox(
                                width:60,
                                child:Image(
                                  image:AssetImage('assets/img/instant_icon.png'),
                                )
                            ),

                          ]
                      ),

                      Expanded(
                          child:Container(
                              padding: const EdgeInsets.only(left:20,right:10),
                              child:Text(S.of(context).instant_delivery,
                                  style:Theme.of(context).textTheme.titleSmall
                              )
                          )
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Theme.of(context).disabledColor),
                    ]
                )
            ):
            currentCheckout.value.deliverType==2?Container(
                padding: const EdgeInsets.only(left:20,top:20,bottom:20, right: 20),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:const [
                            SizedBox(
                                width:60,
                                child:Image(
                                  image:AssetImage('assets/img/clock.png'),
                                )
                            ),

                          ]
                      ),

                      Expanded(
                          child:Container(
                              padding: const EdgeInsets.only(left:20,right:10),
                              child:Text(S.of(context).scheduled_delivery,
                                  style:Theme.of(context).textTheme.titleSmall
                              )
                          )
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Theme.of(context).disabledColor),
                    ]
                )
            ):
            currentCheckout.value.deliverType==3?Container(
                padding: const EdgeInsets.only(left:20,top:20,bottom:20, right: 20),
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:const [
                            SizedBox(
                                width:60,
                                child:Image(
                                  image:AssetImage('assets/img/takeaway.png'),
                                )
                            ),

                          ]
                      ),

                      Expanded(
                          child:Container(
                              padding: const EdgeInsets.only(left:20,right:10),
                              child:Text(S.of(context).takeaway,
                                  style:Theme.of(context).textTheme.titleSmall
                              )
                          )
                      ),
                      Icon(Icons.keyboard_arrow_right, color: Theme.of(context).disabledColor),
                    ]
                )
            ):Container(),

            ),

          ),
          currentCheckout.value.deliverType==2?Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.lock_clock, size: 20.0, color: Colors.grey[700]),
                const SizedBox(width: 10),
                Text(S.of(context).delivery_time_slot, style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                InkWell(
                  onTap: showSlot,
                  child: currentCheckout.value.deliveryTimeSlot != null
                      ? Text(S.of(context).change,
                      style:
                      Theme.of(context).textTheme.bodySmall.merge(TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w600)))
                      : Text(S.of(context).add,
                      style:
                      Theme.of(context).textTheme.bodySmall.merge(TextStyle(color: Theme.of(context).colorScheme.background, fontWeight: FontWeight.w600))),
                )
              ],
            ),
          ):Container(),
          currentCheckout.value.deliverType==2? Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 10),
              child: currentCheckout.value.deliveryTimeSlot != null
                  ? Text(
                '${S.of(context).your_order_delivery_time_slot_is} ${currentCheckout.value.deliveryTimeSlot}',
                style: Theme.of(context).textTheme.titleSmall,
              )
                  : Text(
                S.of(context).please_select_your_delivery_slot,
                style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color: Colors.red)),
              )):Container(),
          Container(
              padding: const EdgeInsets.only(top:20,left:17,right:17),
              child:Text(S.of(context).bill_details,
                style: Theme.of(context).textTheme.displayMedium,
              )
          ),
          ValueListenableBuilder(
              valueListenable: cart_repo.currentCart,
              builder: (context, setting, _) {
                //widget.con.grandSummary();
                return  Container(
                    margin: const EdgeInsets.only(top:18,left:17,right:17,bottom:5),
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
                                      Text(Helper.pricePrint(currentCheckout.value.sub_total.toString()), style: Theme.of(context).textTheme.titleSmall),
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


                                            currentCheckout.value.deliverType!=3? Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text('${S.of(context).delivery_partner_fee} ${Helper.priceDistance(currentCheckout.value.km)}' , style: const TextStyle(color:  Color(0xFF8c0c0c))),
                                                currentCheckout.value.delivery_fees  != 0
                                                    ? Text('${Helper.pricePrint(currentCheckout.value.delivery_fees.toString())}',
                                                    style: Theme.of(context).textTheme.titleSmall)
                                                    : Text(S.of(context).free, style: Theme.of(context).textTheme.titleSmall),
                                              ],
                                            ):Container(),

                                            Text(S.of(context).your_delivery_partner_is_travelling_long_distance_to_deliver_your_order,
                                                style:Theme.of(context).textTheme.bodySmall
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(S.of(context).discount, style: const TextStyle(color: Colors.green)),
                                                Text('${Helper.pricePrint(currentCheckout.value.discount.toString())}',
                                                    style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color: Colors.green))),
                                              ],
                                            ),
                                            DottedLine(
                                              dashColor: Theme.of(context).disabledColor,
                                            ),
                                            const SizedBox(height: 20),

                                            currentCheckout.value.delivery_tips!=0?const SizedBox(height: 10):Container(),


                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(S.of(context).delivery_tip, style: Theme.of(context).textTheme.titleSmall),
                                                InkWell(
                                                  onTap: (){},
                                                  child: Text(Helper.pricePrint(currentCheckout.value.delivery_tips.toString()),
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
                                                    TaxPopupHelper.exit(context,currentCheckout.value.tax,currentCheckout.value.packingCharge);
                                                  },
                                                  child:Wrap(
                                                      children:[
                                                        Text('Taxes and charges', style: Theme.of(context).textTheme.titleSmall),
                                                        const SizedBox(width:5),
                                                        const Icon(Icons.arrow_drop_down_outlined)
                                                      ]
                                                  ),
                                                ),
                                                Text(Helper.pricePrint((currentCheckout.value.tax+currentCheckout.value.packingCharge).toString()),
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
                                          S.of(context).grand_total,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        const Spacer(),
                                        Text(
                                          '${Helper.pricePrint(currentCheckout.value.grand_total.toString())}',
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ))
                );
              }),

          Container(
              padding: const EdgeInsets.only(top:20,left:17,right:17),
              child:Text(S.of(context).review_your_order_and_address_details_to_avoid_cancellation,
                style: Theme.of(context).textTheme.titleLarge,
              )
          ),
        Container(
            margin: const EdgeInsets.only(top:18,left: 17,right: 17),
            padding: const EdgeInsets.all(20),
            decoration:BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 1,
                  spreadRadius:0.5,
                ),
              ],
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(text: '${S.of(context).note}:',
                    style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).primaryColorDark,

                    )),
                    children: [
                  TextSpan(
                    text: ' if you cancel within 60 seconds of placing your order a 100% refund will be issued. No refund for cancellation madee for 60 seconds',
                    style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(
                      color: priceColor1,
                    ))

                  )
                ]),
              ),
              Container(
                padding: const EdgeInsets.only(top:12),
                  child:Text('Avoid cancellation as it leads to food wastage',
                      style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(
                          color: priceColor1,fontWeight: FontWeight.w600
                      ))
                  )
              ),
              Container(
                  padding: const EdgeInsets.only(top:5),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/policy',arguments: 'Return Policy');
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(transparent),
                            elevation: MaterialStateProperty.all(0),
                        ),
                        child: Text(
                          S.of(context).read_cancellation_policy,
                          style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: Theme.of(context).primaryColorDark)),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.6,
                          child:DottedLine(
                        dashColor: Theme.of(context).primaryColorDark,
                      )),
                    ]
                  )
              ),


            ],
          ),
        ),





          const SizedBox(height: 50)
        ]));
  }

  void specialCookingBottomSheet() {

    showModalBottomSheet(

        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              color: const Color(0xff737373),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close),
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ]
                  ),

                  Expanded(
                      child:Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
                        ),

                        child:SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Container(
                                  margin: const EdgeInsets.only(top:20,left:15,right:15),
                                  child:Text(S.of(context).special_cooking_instructions,
                                    style: Theme.of(context).textTheme.displayMedium,
                                  )
                              ),
                              const SizedBox(height: 20),


                              Container(
                                margin: const EdgeInsets.only(left:20,right:20,top:20,bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).dividerColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                    cursorColor: Theme.of(context).focusColor,
                                    onChanged: (e){
                                      currentCheckout.value.instructionNote = e;
                                    },
                                    maxLines: 5,
                                    decoration: InputDecoration.collapsed(
                                      hintText: '',
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          .merge(const TextStyle(color: Colors.grey)),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top:10,left:20,right:20),
                                  child:Text(S.of(context).the_restart_will_follow_your_instructions_on_the_effort_basis_no_refunds_or_cancellations_will_be_processed_based_on_failure_to_comply_with_requests_for_special_instructions,
                                    style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color:Colors.red)),
                                  )
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child:  Container(
                        color:Theme.of(context).primaryColor,
                        child: Container(
                          margin: const EdgeInsets.only(left:20,right:10,bottom: 10),
                          height: 54,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color:Theme.of(context).colorScheme.secondary,
                              borderRadius: const BorderRadius.all(Radius.circular(7.0))
                          ),

                          child:ElevatedButton(

                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(transparent),
                                elevation: MaterialStateProperty.all(0),
                                shape:MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(7)))
                            ),
                            onPressed:(){
                               Navigator.pop(context);
                            },
                            child: Text(
                                S.of(context).add,
                                style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight,height:1.1))
                            ),
                          ),
                        ),
                      )
                  )

                ],

              ),
            ),
          );
        });
  }



  void showSlot() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            color: const Color(0xff737373),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12.0), topRight: Radius.circular(12.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                      ),
                      child: SingleChildScrollView(
                        child: widget.con.timeSlot.isNotEmpty
                            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[TimeSlotWidget(choice: widget.con.timeSlot)])
                            : Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: const [
                          Center(
                            child: CircularProgressIndicator(),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.con.timeSlot.isNotEmpty
                        ? Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      child: SizedBox(
                        width: double.infinity,
                        // ignore: deprecated_member_use
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() => currentUser.value);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(15),
                              backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                            ),
                            child: Text(
                              S.of(context).proceed_and_close,
                              style: Theme.of(context).textTheme.bodyMedium.merge(const TextStyle(color: Colors.white)),
                            )),
                      ),
                    )
                        : Container(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void deliveryMode(context, shopDetails) {
    Future<void> future = showModalBottomSheet(
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
                          padding: const EdgeInsets.all(15),
                          width: double.infinity,
                          decoration:  BoxDecoration(
                            color:Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
                            shape: BoxShape.rectangle,

                          ),
                          child:Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [


                              Expanded(
                                  child:Container(
                                    padding: const EdgeInsets.only(left:10),
                                    child:Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[

                                          Container(
                                            padding: const EdgeInsets.only(top:0,),
                                            child: Text(S.of(context).delivery_mode,style: Theme.of(context).textTheme.titleSmall,),
                                          ),



                                          /* Container(
                                            padding: const EdgeInsets.only(top:0,),
                                            child: Text('Served in 7 minits',
                                              overflow: TextOverflow.ellipsis,maxLines: 2,
                                              style: Theme.of(context).textTheme.caption,),
                                          ), */



                                        ]
                                    ),
                                  )
                              ),




                            ],
                          )
                      ),
                      Expanded(
                          child:SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                DeliveryMode(shopDetails: shopDetails,),
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

    future.then((void value) => {
      setState((){
    setState(() => currentUser.value);
    widget.con.grandSummary();
    if(    currentCheckout.value.deliverType!=3) {
      widget.con.calculateDeliveryFees();
    }


      }),

    });
  }
}


class DeliveryInstruction {
  DeliveryInstruction({this.id, this.name, this.selected});
  int id;
  String name;
  bool selected;
}

List<DeliveryInstruction> deliveryInstruction = <DeliveryInstruction>[
  DeliveryInstruction(id: 1, name: 'Leave a door', selected: false),
  DeliveryInstruction(id: 2,name: 'Leave with guard' ,  selected: false),
  DeliveryInstruction(id: 3, name:'Avoid calling',  selected: false),
  DeliveryInstruction(id: 4,name:'Do not ring the bell' ,  selected: false),
];

class TaxPopupHelper {
  static exit(context, tax, packing) =>
      showDialog(context: context, builder: (context) => TaxPopupWidget(tax: tax,packing: packing,));
}