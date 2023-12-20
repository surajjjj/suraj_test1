import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../components/constants.dart';
import '../repository/order_repository.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../Widget/custom_divider_view.dart';
import '../models/cart_responce.dart';
import '../controllers/cart_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/helper.dart';
import '../models/vendor.dart';
import '../repository/product_repository.dart';
import 'addons_cart_widget.dart';


// ignore: must_be_immutable
class ProductBox3Widget extends StatefulWidget {
  ProductBox3Widget({Key key, this.con,this.productDetails,this.id, }) : super(key: key);
  CartController con;
  CartResponse productDetails;
  int id;


  @override
  ProductBox3WidgetState createState() => ProductBox3WidgetState();
}

class ProductBox3WidgetState extends StateMVC<ProductBox3Widget> {
  @override
  void initState() {
    super.initState();
   // print(widget.productDetails.image);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top:6,bottom: 0),


      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10,left:10,right:10),

                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl:   widget.productDetails.image,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fit: BoxFit.cover, height: 110, width: 110,
                      )

                  ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 2,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 6,),

                        child: Text(
                            widget.productDetails.product_name,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            softWrap: true,
                            style: Theme.of(context).textTheme.titleSmall.merge(
                                TextStyle(color: Theme.of(context).colorScheme.background.withOpacity(0.8))
                            )
                        ),
                      ),

                      const SizedBox(height: 8),
                      Wrap(alignment: WrapAlignment.spaceBetween, children: [
                        Text(Helper.pricePrint(widget.productDetails.price), style: Theme.of(context).textTheme.titleLarge),
                       /* Padding(
                          padding: const EdgeInsets.only(left: 8, ),
                          child: Text(
                            Helper.pricePrint('100'),
                            style: Theme.of(context).textTheme.subtitle2.merge(const TextStyle(decoration: TextDecoration.lineThrough)),
                          ),
                        ), */

                      ]),
                      widget.productDetails.multipleVariant? Text(widget.productDetails.variantName, style: Theme.of(context).textTheme.bodySmall):Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.productDetails.multipleVariant||widget.productDetails.addonGroup.isNotEmpty ?Container(
                              margin:const EdgeInsets.only(top:5),
                              child:Wrap(
                                  children:[
                                    InkWell(
                                      onTap: (){
                                        variantPop(widget.productDetails,currentCheckout.value.vendor,widget.con,'edit', widget.id);
                                      },
                                      child: Container(
                                        margin:const EdgeInsets.only(top:2),
                                        child:const Text('Edit',),),
                                    ),
                                    Icon(Icons.arrow_drop_down,size:10,color:Theme.of(context).primaryColorDark)
                                  ]
                              )
                          ):Container(),
                          InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Wrap(alignment: WrapAlignment.center, children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.con.removeVariant(widget.productDetails.productId,widget.productDetails.variantName,'no_variant');
                                    });
                                  },
                                  iconSize: 27,
                                  icon: const Icon(Icons.remove_circle),
                                  color: Theme.of(context).colorScheme.secondary,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 13),
                                  child: Text(widget.productDetails.qty.toString(), style: Theme.of(context).textTheme.titleSmall),
                                ),

                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if(widget.productDetails.multipleVariant== true || widget.productDetails.addonGroup.isNotEmpty) {
                                        repeatVariant(widget.productDetails, widget.con);
                                      }else {
                                        widget.con.incrementVariant(widget.productDetails.productId,widget.productDetails.product_name);
                                      }
                                    });
                                  },
                                  iconSize: 27,
                                  icon: const Icon(Icons.add_circle),
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),







                    ],
                  ),
                ),
              ),
            ],
          ),


        ],
      )
    );
  }






  void repeatVariant(CartResponse productDetails, CartController con) {
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
                                      return    cartResponse.productId==productDetails.productId?Row(
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

                                                        Text(cartResponse.variantName,
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
                                           variantPop(productDetails,currentCheckout.value.vendor,widget.con,'add',widget.id);
                                         //  widget.con.variantCalculation(productDetails,'first');
                                          },
                                          style:ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.all(15),
                                            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                                          ),
                                          child: Text(
                                            S.of(context).add_New,
                                            style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: Theme.of(context).primaryColorLight)),
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
                                            widget.con.repeatLastVariant(widget.productDetails.productId);

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
                                          style: Theme.of(context).textTheme.titleSmall,
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

 void variantPop(CartResponse product,Vendor shopDetails,CartController con, String action, int carId) {
    Future<void> future =  showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return VariantAddonsCartSheet(product: product,shopDetails: shopDetails,action: action, carId: carId,);
        });
    future.then((void value) => {
      setState((){
        widget.con.checkProductIdCartVariant(widget.productDetails.productId);
      }),

    });
  }


}


