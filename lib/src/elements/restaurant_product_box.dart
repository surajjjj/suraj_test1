import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../repository/product_repository.dart';
import '../repository/vendor_repository.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../Widget/custom_divider_view.dart';
import '../components/constants.dart';
import '../models/cart_responce.dart';
import '../models/vendor.dart';
import '../repository/order_repository.dart';
import '../models/product_details2.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/helper.dart';
import '../controllers/product_controller.dart';
import 'addons_widget.dart';


// ignore: must_be_immutable
class RestaurantProductBox extends StatefulWidget {
  RestaurantProductBox({Key key,this.popperShow, this.choice, this.con,  this.km, this.shopTypeID, this.shopDetails}) : super(key: key);
  final ProductDetails2 choice;
  final ProductController con;
  Vendor shopDetails;
  final String km;
  final int shopTypeID;
  bool popperShow;


  @override
  RestaurantProductBoxState createState() => RestaurantProductBoxState();
}

class RestaurantProductBoxState extends StateMVC<RestaurantProductBox> {


   bool shopState;
  @override
  void initState() {
    super.initState();
    shopState = Helper.shopOpenStatus(widget.shopDetails);
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.only(bottom:10),
      padding: const EdgeInsets.only(
        left: 10,
        top: 5,
        right: 10,
        bottom:10
      ),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,


        children:  [
          Stack(
            children: [
              Row(
                  children: [


                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2, right: 5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Container(
                                      padding: const EdgeInsets.only(top: 6,bottom:10),
                                      child: Text(widget.choice.product_name,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style:Theme.of(context).textTheme.titleLarge.merge(const TextStyle(fontWeight: FontWeight.bold))
                                      ),
                                    ),


                                    Wrap(alignment: WrapAlignment.start,
                                        children: [
                                          Container(
                                              margin:const EdgeInsets.only(top:5,right:5),
                                              decoration:BoxDecoration(
                                                color: Theme.of(context).primaryColor,
                                                borderRadius:BorderRadius.circular(3),
                                                border:Border.all(
                                                    width: 1,
                                                    color: widget.choice.foodType=='Veg'?customeColor1:nonVegColor
                                                ),

                                              ),
                                              child:Icon(Icons.circle,size:11,color: widget.choice.foodType=='Veg'?customeColor1:nonVegColor)
                                          ),
                                          Text(Helper.pricePrint(widget.choice.price), style: Theme
                                              .of(context)
                                              .textTheme
                                              .displaySmall.merge(TextStyle(color: Theme.of(context).colorScheme.background,height: 1.1
                                          )
                                          )),
                                          widget.choice.discount!='0'?Container(
                                            width: 80,
                                            padding: const EdgeInsets.only(left: 8, top: 4),
                                            child: Text(
                                              Helper.pricePrint(widget.choice.strike),
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  .merge(TextStyle(color:priceColor1,decoration: TextDecoration.lineThrough)),
                                            ),
                                          ):Container(),

                                        ]),
                                    const SizedBox(height: 3),

        int.parse(widget.choice.ratingTotal)>0?Row(
                                      children:[
                                        Wrap(
                                          children:List.generate(int.parse(widget.choice.rating), (index) {
                                            return const Icon(Icons.star,color:Color(0xFFFFD700),size:15);
                                    })
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(left:15),
                                          child: Text('${widget.choice.ratingTotal} reviews')
                                        )
                                      ]
                                    ):Container(),
                                    Text( widget.choice.description??'',
                                    style:Theme.of(context).textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,maxLines: 2,
                                    ),


                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),

                            ]

                          /*       return _variantData.selected?*/

                        ),
                      ),

                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomCenter,
                      children: [
                        InkWell(
                          onTap: () {
                            // widget.con.view_product(widget.choice);
                        // ProductDescriptionBottomSheet(widget.choice, widget.con);
                          },
                          child:Container(
                            foregroundDecoration:!Helper.itemAvailableStatus(widget.choice) || widget.choice.outOfStock ||  widget.shopDetails.openStatus!='Open' || !shopState? const BoxDecoration(
                                color:Colors.grey,
                                backgroundBlendMode:  BlendMode.saturation
                            ):const BoxDecoration(
                              color:Colors.transparent,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(top: 10,),
                                child:Column(
                                  children:[
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: 'assets/img/loading_trend.gif',
                                          image:  widget.choice.image,
                                          height: 120, width: 125, fit: BoxFit.cover,
                                          imageErrorBuilder: (c, o, s) => Image.asset('assets/img/loading_trend.gif', height: 120, width: 125, fit: BoxFit.cover),
                                        )
                                    ),
                                    (widget.choice.multipleVariant== true || widget.choice.addonGroup.isNotEmpty)?Padding(
                                      padding:const EdgeInsets.only(right:0,top:15),
                                      child:Text(S.of(context).customizable,style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.end,),
                                    ):Container(),
                                  ]
                                ),

                            ),
                          ),
                        ),

                        widget.choice.discount !='0'?Positioned(
                            top:0,right:15,
                            child:Stack(
                                clipBehavior: Clip.none,

                                children:[
                                  const SizedBox(
                                      width:30,height:70,
                                      child:Image(image:AssetImage('assets/img/toplable.png'))
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child:Container(
                                          margin: const EdgeInsets.only(top:18,left:3),
                                          alignment: Alignment.center,
                                          child:Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children:[
                                                Text('${widget.choice.discount}%',
                                                  style: TextStyle(color:Theme.of(context).primaryColorLight,fontSize: 10,fontWeight: FontWeight.w700
                                                  ),
                                                ),
                                                Text('OFF',
                                                  style: TextStyle(color:Theme.of(context).primaryColorLight,fontSize: 10,fontWeight: FontWeight.w700
                                                  ),
                                                )
                                              ]
                                          )
                                      )
                                  ),


                                ])
                        ):Container(),





                        Positioned(
                            bottom: 20,
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:[
                                  if ( Helper.shopOpenStatus(widget.shopDetails) == true ) ...[

                                    if(Helper.itemAvailableStatus(widget.choice) && !widget.choice.outOfStock && widget.shopDetails.openStatus=='Open')...[

                                      0==widget.con.checkProductIdCartVariant(widget.choice.id)
                                          ?Container(
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color:Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12.withOpacity(0.2),
                                              blurRadius: 1,
                                              spreadRadius: 0.3,
                                            ),
                                          ],
                                        ),

                                        child:ElevatedButton(


                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(transparent),
                                                elevation: MaterialStateProperty.all(0),
                                                shape:MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(7)))
                                            ),
                                            onPressed:(){

                                              if(currentCheckout.value.shopId==widget.shopDetails.shopId || currentCheckout.value.shopId==null || currentCheckout.value.shopId=='') {

                                              if(widget.choice.multipleVariant== true || widget.choice.addonGroup.isNotEmpty) {
                                                variantPop(widget.choice, widget.shopDetails, widget.con,);
                                                widget.con.variantCalculation(widget.choice, 'first');
                                              }else {
                                              setState(() {
                                                widget.con.gatewayVariant(widget.choice,'',widget.shopDetails,widget.choice.product_name,widget.choice.totalSteps,'no_variant');
                                              });
                                              }


                                              }else{
                                                ClearCartShow();
                                              }


                                            },
                                            child:Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children:[
                                                  Text(
                                                     S.of(context).add,
                                                      style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:themeEvenText,height:1.1))
                                                  ),

                                                ]
                                            )
                                        ),
                                      ):

                                      Container(
                                        height: 30,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color:Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12.withOpacity(0.2),
                                              blurRadius: 1,
                                              spreadRadius: 0.3,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                          ),
                                          child: Wrap(alignment: WrapAlignment.spaceEvenly, children: [
                                          Container(
                                            margin:const EdgeInsets.only(top:1.5),
                                            child:InkWell(
                                              onTap: () {
                                                setState(() {
                                               if(widget.choice.multipleVariant== true || widget.choice.addonGroup.isNotEmpty) {
                                                 removeVariant(
                                                   widget.choice, widget.con,);
                                               }else{
                                                 widget.con.removeVariant(widget.choice.id,widget.choice.product_name,'no_variant');

                                               }


                                                });
                                              },

                                              child: Icon(Icons.remove,size:28,color:Theme.of(context).colorScheme.secondary,),

                                            ),),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 4,left:3.5,right:3.5),
                                              child: Text(widget.con.checkProductIdCartVariant(widget.choice.id).toString(), style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .titleSmall),
                                            ),

                                            Container(
                                              margin:const EdgeInsets.only(top:1.5),
                                              child:InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if(widget.choice.multipleVariant== true || widget.choice.addonGroup.isNotEmpty) {
                                                       repeatVariant(
                                                           widget.choice,
                                                           widget.con);
                                                     }else {
                                                    widget.con.incrementVariant(widget.choice.id,widget.choice.product_name);
                                                  }
                                                });

                                              },

                                              child: Icon(Icons.add,size:27,color:Theme.of(context).colorScheme.secondary,),

                                            ),),
                                          ]),
                                        ),
                                      )
                                    ]else ...[
                                      Wrap(
                                        alignment:WrapAlignment.end,
                                        children: [
                                          Container(
                                            width: 110,
                                            decoration: BoxDecoration(
                                              color:Theme.of(context).primaryColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12.withOpacity(0.2),
                                                  blurRadius: 1,
                                                  spreadRadius: 0.3,
                                                ),
                                              ],
                                            ),
                                            child:Column(
                                                children:[
                                                  Text(!widget.choice.outOfStock?S.of(context).not_available:S.of(context).out_of_stock,style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.end,),
                                                  // Text('${widget.choice.fromTime} to ${widget.choice.toTime}',style: Theme.of(context).textTheme.caption.merge(TextStyle(fontSize: 10)),textAlign: TextAlign.end,)
                                                ]
                                            ),

                                          ),

                                        ],
                                      ),
                                    ]
                                  ],



                                ]
                            )
                        )
                      ],
                    )

                  ]
              ),


            ],
          )
        ]
        ),
    );

  }

  // ignore: non_constant_identifier_names
  void ClearCartShow() {
    var size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.center,
              child:Div(
                colS:12,
                colM:8,
                colL:6,
                child:Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.only(
                    top:size.height * 0.30,
                    left:size.width * 0.09,
                    right:size.width * 0.09,
                    bottom:size.height * 0.30,
                  ),
                  child:Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color:Theme.of(context).primaryColor,
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(12))
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child:Scrollbar(
                              thumbVisibility: true,
                              child: SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children:[
                                            Container(
                                              height: 28,width: 28,

                                              margin: const EdgeInsets.only(right: 10,top: 10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context).dividerColor,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context).dividerColor,
                                                    blurRadius: 2,
                                                    spreadRadius:0.8,
                                                  ),
                                                ],
                                              ),
                                              child: InkWell(
                                                child: const Icon(Icons.close,size: 18,),
                                                onTap: (){
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            )

                                          ]
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(right: 25, left:25),
                                        child:Text(S.of(context).replace_cart_item,
                                            style: Theme.of(context).textTheme.headlineSmall
                                        ),
                                      ),

                                      Container(
                                        padding: const EdgeInsets.only(right: 25, left:25),
                                        child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              const SizedBox(height:10),

                                              Text('${S.of(context).your_cart_contains_dishes_from} ${currentVendor.value.shopName} ${S.of(context).kitchen}. ${S.of(context).do_you_want_to_discard_the_selection_and_add_dishes_form} ${currentVendor.value.shopName} ',
                                                style: Theme.of(context).textTheme.bodySmall,
                                              ),


                                              const SizedBox(height:10),
                                            ]
                                        ),

                                      ),
                                    ]
                                ),
                              ),)
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child:Container(
                              padding: const EdgeInsets.only(bottom:10,right: 20),
                              child:  Wrap(
                                children: [
                                  Div(
                                      colS: 6,
                                      colM: 6,
                                      colL: 6,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20,),
                                        // ignore: deprecated_member_use
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style:ElevatedButton.styleFrom(
                                            elevation: 2,
                                            padding: const EdgeInsets.only(top:10,bottom:10,left:10,right:10),
                                            backgroundColor: Theme.of(context).primaryColor,
                                            shape: const StadiumBorder(),
                                          ),
                                          child: Text(
                                            S.of(context).no,
                                            style: Theme.of(context).textTheme.titleLarge.merge(
                                                TextStyle(color: Theme.of(context).colorScheme.background,)
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                  Div(
                                      colS: 6,
                                      colM: 6,
                                      colL: 6,
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20,),
                                        // ignore: deprecated_member_use
                                        child: ElevatedButton(
                                          onPressed: () {
                                            widget.con.clearCart();
                                          },
                                          style:ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.only(top:10,bottom:10,left:10,right:10),
                                            backgroundColor: Theme.of(context).colorScheme.secondary,
                                            shape: const StadiumBorder(),
                                          ),

                                          child: Text(
                                            S.of(context).replace,
                                            style: Theme.of(context).textTheme.titleLarge.merge(
                                                TextStyle(color: Theme.of(context).colorScheme.primary)
                                            ),
                                          ),
                                        ),
                                      )
                                  ),
                                ],
                              )
                          ),

                        ),



                      ],
                    ),
                  ),
                ),

              )

          );
        });
  }

  void removeVariant(ProductDetails2 productDetails, ProductController con) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: const Color(0xff737373),
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
                  ),
                  child:Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        decoration: const BoxDecoration(

                          shape: BoxShape.rectangle,

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Expanded (child: Container(
                                padding: const EdgeInsets.only(left:20,top:20),
                                alignment: Alignment.topLeft,
                                child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[

                                      Text('Customizations for ${productDetails.product_name}',
                                        style: Theme.of(context).textTheme.titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),

                                    ]
                                )
                            ),),
                            Container(
                              height: 28,width: 28,

                              margin: const EdgeInsets.only(right: 20,top: 20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).disabledColor.withOpacity(0.5),
                                    blurRadius: 1.5,
                                    spreadRadius:0.1,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                child: const Icon(Icons.close,size: 18,),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                      const CustomDividerView(
                        dividerHeight: 2,
                      ),

                      Expanded(
                          child:SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left:10,bottom: 5),
                                  margin:const EdgeInsets.only(left:15,top:10,right:15),
                                  child:ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: currentCart.value.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.only(top:0),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, int index) {
                                      CartResponse cartResponse = currentCart.value.elementAt(index);
                                      return    cartResponse.productId==productDetails.id? Row(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Container(
                                            margin:const EdgeInsets.only(top:8,right:5),
                                            decoration:BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius:BorderRadius.circular(3),
                                              border:Border.all(
                                                  width: 1,
                                                  color: cartResponse.foodType=='Veg' ? Colors.green:Colors.brown
                                              ),

                                            ),
                                            child: Icon(Icons.circle,size:11,color: cartResponse.foodType=='Veg' ?Colors.green:Colors.brown)
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                              child:Container(
                                                  padding:const EdgeInsets.only(left:7,top:4.5),
                                                  child:Column(
                                                      crossAxisAlignment:CrossAxisAlignment.start,
                                                      children:[
                                                        Text(cartResponse.product_name,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: Theme.of(context).textTheme.titleSmall),
                                                        const SizedBox(height:5),
                                                        Text(cartResponse.variantName,
                                                            style:Theme.of(context).textTheme.bodyMedium
                                                        )
                                                      ]
                                                  )
                                              )
                                          ),
                                        ),
                                        Align(

                                          child:Container(
                                            width: 90,
                                            height: 37,
                                            margin: const EdgeInsets.only(right:10,top:1),
                                            decoration: BoxDecoration(
                                              color:Theme.of(context).primaryColor,
                                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black12.withOpacity(0.1),
                                                  blurRadius: 1,
                                                  spreadRadius: 0.3,
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.only(left: 5, right: 5,top:7,bottom:7
                                              ),
                                              child: Wrap(alignment: WrapAlignment.spaceEvenly, children: [
                                                Container(
                                                  margin:const EdgeInsets.only(top:0),
                                                  child:InkWell(
                                                    onTap: () {
                                                      setState(() {

                                                          widget.con.removeVariant(productDetails.id,cartResponse.variantName,'variant');


                                                      });
                                                    },

                                                    child: Icon(Icons.remove,color:Theme.of(context).colorScheme.secondary,size:25),

                                                  ),),
                                                const SizedBox(
                                                    width: 5
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 1),
                                                  child: Text(cartResponse.qty.toString(), style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                                ),
                                                const SizedBox(
                                                    width: 5
                                                ),
                                                Container(
                                                  margin:const EdgeInsets.only(top:0),
                                                  child:InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        widget.con.incrementVariant(productDetails.id,cartResponse.variantName);
                                                      });
                                                      Navigator.pop(context);
                                                    },

                                                    child: Icon(Icons.add,color:Theme.of(context).colorScheme.secondary,size:25),

                                                  ),),
                                              ]),
                                            ),
                                          ),
                                        )

                                      ]):Container();

                                    }, separatorBuilder: (BuildContext context, int index) {
                                    return const SizedBox(height: 5);
                                  },),),
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

  void repeatVariant(ProductDetails2 productDetails, ProductController con) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              color: const Color(0xff737373),
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
                  ),
                  child:Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        decoration: const BoxDecoration(

                          shape: BoxShape.rectangle,

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left:20,top:20),
                                alignment: Alignment.topLeft,
                                child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[

                                      Text(S.of(context).repeat_last_used_customization,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),

                                    ]
                                )
                            ),
                            Container(
                              height: 28,width: 28,

                              margin: const EdgeInsets.only(right: 20,top: 20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).disabledColor.withOpacity(0.5),
                                    blurRadius: 1.5,
                                    spreadRadius:0.1,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                child: const Icon(Icons.close,size: 18,),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                      const CustomDividerView(
                        dividerHeight: 2,
                      ),

                      Expanded(
                          child:SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left:10,bottom: 5),
                                  margin:const EdgeInsets.only(left:15,top:10,right:15),
                                  child:ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    itemCount: currentCart.value.length,
                                    shrinkWrap: true,
                                    primary: false,
                                    padding: const EdgeInsets.only(top:0),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, int index) {
                                      CartResponse cartResponse = currentCart.value.elementAt(index);
                                      return    cartResponse.productId==productDetails.id?Row(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Container(
                                            margin:const EdgeInsets.only(top:8,right:5),
                                            decoration:BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              borderRadius:BorderRadius.circular(3),
                                              border:Border.all(
                                                  width: 1,
                                                  color: cartResponse.foodType=='Veg' ?Colors.green:Colors.brown
                                              ),

                                            ),
                                            child: Icon(Icons.circle,size:11,color: cartResponse.foodType=='Veg'?Colors.green:Colors.brown)
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                              child:Container(
                                                  padding:const EdgeInsets.only(left:7,top:4.5),
                                                  child:Column(
                                                      crossAxisAlignment:CrossAxisAlignment.start,
                                                      children:[
                                                        Text(cartResponse.product_name, style: Theme.of(context).textTheme.titleSmall),
                                                        const SizedBox(height:5),

                                                        Text(cartResponse.variantName??'',
                                                            style:Theme.of(context).textTheme.bodyMedium
                                                        )

                                                      ]
                                                  )
                                              )
                                          ),
                                        ),


                                      ]):Container();

                                    }, separatorBuilder: (BuildContext context, int index) {
                                    return const SizedBox(height: 5);
                                  },),),
                                const SizedBox(height: 20),
                              ],
                            ),
                          )
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child:Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                            child: Wrap(
                                children:[
                                  Div(
                                    colS:6,
                                    colM:6,
                                    colL:6,
                                    child: Container(
                                      // ignore: deprecated_member_use
                                      margin: const EdgeInsets.only(right:10),
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            variantPop(widget.choice,widget.shopDetails,widget.con,);
                                            widget.con.variantCalculation(widget.choice,'first');
                                          },
                                          style:ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(15),
                                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                                          ),
                                          child: Text(
                                            S.of(context).add_New,
                                            style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color: Theme.of(context).primaryColorLight)),
                                          )
                                      ),
                                    ),
                                  ),
                                  Div(
                                    colS:6,
                                    colM:6,
                                    colL:6,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState((){
                                            widget.con.repeatLastVariant(widget.choice.id);

                                          });

                                        },
                                        style:ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.all(15),
                                          shadowColor: transparent,
                                          side: BorderSide(
                                              color:Theme.of(context).primaryColorDark,
                                              width:1
                                          ),
                                          backgroundColor: transparent,
                                        ),
                                        child: Text(
                                          S.of(context).repeat_last,
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        )
                                    ),
                                  ),

                                ]
                            )
                        ),
                      )
                    ],

                  )
              ),
            ),
          );
        });
  }

  // ignore: non_constant_identifier_names
  void ProductDescriptionBottomSheet(ProductDetails2 productDetails, ProductController con) {

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.54,
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
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
                        ),

                        child:SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[

                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color:Theme.of(context).primaryColor,
                                        ),
                                        margin: const EdgeInsets.only( left:15,right:15,top: 10.0,bottom:10),
                                        child:ClipRRect(
                                          //borderRadius: BorderRadius.all(Radius.circular(10)),
                                            borderRadius: BorderRadius.circular(18),
                                            child:Material(
                                                color: Colors.transparent,
                                                child:InkWell(
                                                    onTap: () {

                                                    },
                                                    child:Container(
                                                      padding:const EdgeInsets.only(bottom:10,),
                                                      child:Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children:[
                                                            Stack(
                                                              children:  [
                                                                ClipRRect(
                                                                  //borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                    borderRadius: const BorderRadius.only(
                                                                      topLeft: Radius.circular(10),
                                                                      topRight: Radius.circular(10),
                                                                      bottomLeft:Radius.circular(10),
                                                                      bottomRight:Radius.circular(10),
                                                                    ),
                                                                    child:Image(image:NetworkImage(productDetails.image),
                                                                        width:double.infinity,
                                                                        height:247,
                                                                        fit:BoxFit.fill
                                                                    )
                                                                ),



                                                              ],
                                                            ),


                                                            Container(
                                                                margin:const EdgeInsets.only(top:10),
                                                                child:Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children:[
                                                                      Row(
                                                                        children: [
                                                                          Wrap(
                                                                              children:[
                                                                                Container(
                                                                                    margin:const EdgeInsets.only(top:5),
                                                                                    decoration:BoxDecoration(
                                                                                      color: Colors.white,
                                                                                      border:Border.all(
                                                                                          width: 1,
                                                                                          color: productDetails.foodType=='Veg'?customeColor1:nonVegColor
                                                                                      ),

                                                                                    ),
                                                                                    child:Icon(Icons.circle,size:14,color:productDetails.foodType=='Veg'?customeColor1:nonVegColor)
                                                                                ),
                                                                                currentVendor.value.bestSeller?Container(
                                                                                    padding: const EdgeInsets.only(left:5,top:3),
                                                                                    child:const Icon(Icons.star,size:19,color:Colors.orange)
                                                                                ):Container(),
                                                                                currentVendor.value.bestSeller?Container(
                                                                                    padding: const EdgeInsets.only(left:5,top:5),
                                                                                    child:const Text('Best Seller',style: TextStyle(color:Colors.orange),)
                                                                                ):Container(),

                                                                              ]
                                                                          ),

                                                                        ],
                                                                      ),

                                                                      Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          children:[
                                                                            Expanded(
                                                                              child: Container(
                                                                                padding:const EdgeInsets.only(top:3),
                                                                                child:Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children:[
                                                                                      Text(productDetails.product_name,
                                                                                          overflow: TextOverflow.ellipsis,
                                                                                          maxLines: 2,
                                                                                          style:Theme.of(context).textTheme.titleMedium
                                                                                      ),
                                                                                      Container(
                                                                                          padding:const EdgeInsets.only(right:13),
                                                                                          child:Text(Helper.pricePrint('100'),
                                                                                            style: Theme.of(context).textTheme.titleLarge.merge(const TextStyle(fontWeight: FontWeight.w700)),
                                                                                          )
                                                                                      ),
                                                                                    ]
                                                                                ),
                                                                              ),
                                                                            ),




                                                                          ]
                                                                      ),

                                                                      const SizedBox(height:20),

                                                                      Container(
                                                                        padding:const EdgeInsets.only(top:15),
                                                                        child:Text(productDetails.description,

                                                                            style:Theme.of(context).textTheme.bodySmall
                                                                        ),
                                                                      ),




                                                                    ]
                                                                )),
                                                          ]
                                                      ),
                                                    )

                                                )
                                            )
                                        )
                                    )]),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      )
                  ),


                ],

              ),
            ),
          );
        });
  }




  void variantPop(ProductDetails2 product,Vendor shopDetails,ProductController con) {
    Future<void> future =  showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return VariantAddonsSheet(product: product,shopDetails: shopDetails,);
        });
    future.then((void value) => {
      setState((){
        widget.con.checkProductIdCartVariant(widget.choice.id);
      }),

    });
  }




}

















