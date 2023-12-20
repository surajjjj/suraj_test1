import 'package:animation_list/animation_list.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../controllers/cart_controller.dart';
import '../repository/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';



class PaymentPages extends StatefulWidget {
  const PaymentPages({Key key}) : super(key: key);

  @override
  State createState() => _PaymentPagesState();
}

class _PaymentPagesState extends StateMVC<PaymentPages> {

  CartController _con;

  _PaymentPagesState() : super(CartController()) {
    _con = controller;
  }

  // ignore: deprecated_member_use
  int selectedRadio;
  @override
  void initState() {

    _con.loader = Helper.overlayLoader(context);
    _con.listenForWallet();
    super.initState();
    selectedRadio = 0;

  }

  setSelectedRadio(int val, type, url) {
    setState(() {
      if (val == 1) {
        currentCheckout.value.payment.method = 'cash on delivery';
      } else {
        currentCheckout.value.payment.method = 'online';
      }
    });
    currentCheckout.value.payment.paymentType = type;
    currentUser.value.paymentType = type;
    currentUser.value.paymentImage = url;
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
    Navigator.pop(context);

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.background
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.5,
        title:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).more_payment_options,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text('${S.of(context).bill_total}  ${Helper.pricePrint(currentCheckout.value.grand_total.toString())}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        )

      ),
        body:AnimationList(

                                duration: 2100,

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
                                                padding: const EdgeInsets.only(top:18,left:18,),
                                                child:Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children:[
                                                          Container(
                                                            height: 12,width: 12,
                                                            margin: const EdgeInsets.only(top:2),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border:Border.all(
                                                                color: Colors.deepPurple,
                                                                width: 2,
                                                              ),
                                                            ),

                                                          ),
                                                          SizedBox(
                                                              height: 20,
                                                              child:Text('|',
                                                                style: Theme.of(context).textTheme.headlineSmall.merge(const TextStyle(color: Colors.deepPurple,
                                                                    height: 1
                                                                )),
                                                              )
                                                          ),


                                                        ]
                                                    ),
                                                    Container(
                                                        padding: const EdgeInsets.only(left:20),
                                                        child: const Text('User | ')
                                                    ),

                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.only(left:5),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('${currentUser.value.myAddress.addressSelect} : ${currentCheckout.value.km} Km',style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(height:1.3))),

                                                          ],
                                                        ),
                                                      ),
                                                    ),


                                                  ],
                                                )),
                                            Container(
                                                padding: const EdgeInsets.only(left:18,bottom:18,right:10),
                                                child:Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children:[


                                                          Container(
                                                            height: 12,width: 12,
                                                            margin: const EdgeInsets.only(top:2),
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border:Border.all(
                                                                color: Colors.deepPurple,
                                                                width: 2,
                                                              ),
                                                            ),

                                                          ),

                                                        ]
                                                    ),
                                                    Container(
                                                        padding: const EdgeInsets.only(left:20),
                                                        child: const Text('Shop | ')
                                                    ),

                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.only(left:5),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [

                                                            Text(currentCheckout.value.vendor.locationMark,
                                                                overflow: TextOverflow.ellipsis,maxLines: 1,
                                                                style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(height:1.3))),
                                                          ],
                                                        ),
                                                      ),
                                                    ),


                                                  ],
                                                )),
                                          ]
                                      )

                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(top:20,left:20,right: 20),
                                      height: 120,
                                      width:double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child:ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child:Image.network(setting.value.paymentBanner,
                                            fit: BoxFit.fill,
                                          )
                                      )

                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top:20,left:15,bottom:15),
                                    child:Text('Preferred payment',
                                        style: Theme.of(context).textTheme.titleMedium
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left:15,right:15),

                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),

                                    child:Column(
                                          children:[
                                            Container(
                                                padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                child:InkWell(
                                                  onTap: (){
                                                    setSelectedRadio(2,'RayzorPay','assets/img/razorpay.png');
                                                  },
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: const Image(image:AssetImage('assets/img/razorpay.png',
                                                        ),
                                                          width:40,height:40,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),

                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.only(left:15),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('RayzorPay',style: Theme.of(context).textTheme.titleSmall),

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        child: Container(
                                                            padding: const EdgeInsets.only(left:15),
                                                            child: InkWell(
                                                              onTap: (){},
                                                              child: Icon(Icons.arrow_forward_ios,size: 17,
                                                                color: Theme.of(context).disabledColor,
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )),
                                            DottedLine(
                                              dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
                                            ),
                                            setting.value.codMode?  InkWell(
                                              onTap: (){
                                                setSelectedRadio(1,'COD','assets/img/cod.png');
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                  child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: const Image(image:AssetImage('assets/img/cod.png',
                                                        ),
                                                          width:40,height:28,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),

                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.only(left:15),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('COD',style: Theme.of(context).textTheme.titleSmall),

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        child: Container(
                                                            padding: const EdgeInsets.only(left:15),
                                                            child: InkWell(
                                                              onTap: (){},
                                                              child: Icon(Icons.arrow_forward_ios,size: 17,
                                                                color: Theme.of(context).disabledColor,
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            ):Container(),
                                          ]

                                    ),
                                  ),
                                /*  Container(
                                    padding: const EdgeInsets.only(top:20,left:15,bottom:15),
                                    child:Text('Credit & Debit Cards',
                                        style: Theme.of(context).textTheme.subtitle1
                                    ),
                                  ),
                               Container(
                                    margin: const EdgeInsets.only(left:15,right:15),

                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),

                                    child:InkWell(
                                      onTap: (){

                                      },
                                      child: Column(
                                          children:[
                                            Container(
                                                padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                child:Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width:40,height:40,
                                                      padding: const EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                          border:Border.all(
                                                              width: 1,color:Theme.of(context).dividerColor
                                                          ),
                                                          borderRadius: BorderRadius.circular(4)
                                                      ),
                                                      child: const Image(image:AssetImage('assets/img/visacard.png',
                                                      ),
                                                        width:40,height:40,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),

                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.only(left:15),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('.....9807',style: Theme.of(context).textTheme.subtitle2),

                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      child: Container(
                                                        padding: const EdgeInsets.only(left:15),
                                                        child: Radio(
                                                            value: 3,
                                                            groupValue: selectedRadio,
                                                            activeColor: Colors.blue,
                                                            onChanged: (val) {

                                                              setSelectedRadio(val);

                                                            }),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                            DottedLine(
                                              dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
                                            ),
                                            Container(
                                                padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                child:Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: Icon(Icons.add,
                                                            color: Theme.of(context).primaryColorDark
                                                        )
                                                    ),

                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.only(left:15),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('Add New Cards',style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(color: Theme.of(context).primaryColorDark))),
                                                            Text('Save and pay via Cards',
                                                              style: Theme.of(context).textTheme.caption,
                                                            )

                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                )
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top:20,left:15,bottom:15),
                                    child:Text('UPI',
                                        style: Theme.of(context).textTheme.subtitle1
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left:15,right:15),

                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),

                                    child:InkWell(
                                      onTap: (){

                                      },
                                      child: Column(
                                          children:[

                                            Container(
                                                padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                child:Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: Icon(Icons.add,
                                                            color: Theme.of(context).primaryColorDark
                                                        )
                                                    ),

                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.only(left:15),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('Add New UPI ID',style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(color: Theme.of(context).primaryColorDark))),
                                                            Text('You need to have a registered UPI ID',
                                                              style: Theme.of(context).textTheme.caption,
                                                            )

                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                )
                                            ),
                                          ]
                                      ),
                                    ),
                                  ),*/
                                  Container(
                                    padding: const EdgeInsets.only(top:20,left:15,bottom:15),
                                    child:Text('More Payment Options',
                                        style: Theme.of(context).textTheme.titleMedium
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left:15,right:15),

                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),

                                    child: Column(
                                          children:[
                                            DottedLine(
                                              dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
                                            ),
                                            setting.value.rayzorPay? InkWell(
                                              onTap: (){
                                                setSelectedRadio(2,'RayzorPay','assets/img/razorpay.png');
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                  child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: const Image(image:AssetImage('assets/img/razorpay.png',
                                                        ),
                                                          width:40,height:40,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),

                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.only(left:15),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('RayzorPay',style: Theme.of(context).textTheme.titleSmall),
                                                              Text('Accept all restaurant',
                                                                style: Theme.of(context).textTheme.bodySmall,
                                                              )

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        child: Container(
                                                            padding: const EdgeInsets.only(left:15),
                                                            child: InkWell(
                                                              onTap: (){
                                                                setSelectedRadio(2,'flutterwave','assets/img/flutterwave.png');
                                                              },
                                                              child: Icon(Icons.arrow_forward_ios,size: 17,
                                                                color: Theme.of(context).disabledColor,
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            ):Container(),
                                            DottedLine(
                                              dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
                                            ),
                                            setting.value.flutterWave?InkWell(
                                              onTap: (){
                                                setSelectedRadio(2,'flutterwave','assets/img/flutterwave.png');
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                  child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: const Image(image:AssetImage('assets/img/flutterwave.png',
                                                        ),
                                                          width:40,height:40,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),

                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.only(left:15),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(S.of(context).flutterwave,style: Theme.of(context).textTheme.titleSmall),
                                                              Text('Accept all restaurant',
                                                                style: Theme.of(context).textTheme.bodySmall,
                                                              )

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        child: Container(
                                                            padding: const EdgeInsets.only(left:15),
                                                            child: InkWell(
                                                              onTap: (){
                                                                setSelectedRadio(2,'flutterwave','assets/img/flutterwave.png');
                                                              },
                                                              child: Icon(Icons.arrow_forward_ios,size: 17,
                                                                color: Theme.of(context).disabledColor,
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            ):Container(),

                                            DottedLine(
                                              dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
                                            ),
                                            setting.value.paypal? InkWell(
                                              onTap: (){
                                                setSelectedRadio(2,'Paypal','assets/img/paypal.png');
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                  child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: const Image(image:AssetImage('assets/img/paypal.png',
                                                        ),
                                                          width:40,height:40,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),

                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.only(left:15),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('Paypal',style: Theme.of(context).textTheme.titleSmall),
                                                              Text('Accept all restaurant',
                                                                style: Theme.of(context).textTheme.bodySmall,
                                                              )

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        child: Container(
                                                            padding: const EdgeInsets.only(left:15),
                                                            child: InkWell(
                                                              onTap: (){},
                                                              child: Icon(Icons.arrow_forward_ios,size: 17,
                                                                color: Theme.of(context).disabledColor,
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            ):Container(),
                                            DottedLine(
                                              dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
                                            ),
                                            setting.value.stripe? InkWell(
                                              onTap: (){
                                                setSelectedRadio(2,'Stripe','assets/img/stripe.png');
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                  child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: const Image(image:AssetImage('assets/img/stripe.png',
                                                        ),
                                                          width:40,height:40,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),

                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.only(left:15),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(S.of(context).stripe,style: Theme.of(context).textTheme.titleSmall),
                                                              Text('Accept all restaurant',
                                                                style: Theme.of(context).textTheme.bodySmall,
                                                              )

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        child: Container(
                                                            padding: const EdgeInsets.only(left:15),
                                                            child: InkWell(
                                                              onTap: (){},
                                                              child: Icon(Icons.arrow_forward_ios,size: 17,
                                                                color: Theme.of(context).disabledColor,
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            ):Container(),
                                            DottedLine(
                                              dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
                                            ),
                                            InkWell(
                                              onTap: (){
                                                if(currentUser.value.walletAmount!='0') {

                                                  if(int.parse(currentUser.value.walletAmount)>currentCheckout.value.grand_total) {

                                                    setSelectedRadio(1,'wallet','assets/img/wallet.png');

                                                  } else{
                                                    _con.toaster(S.of(context).low_balance_please_recharge, S.of(context).low_balance_please_recharge,'error');
                                                  }
                                                } else{
                                                  _con.toaster(S.of(context).your_wallet_balance_is_0_please_recharge,S.of(context).your_wallet_balance_is_0_please_recharge, 'error');
                                                }
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                  child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: const Image(image:AssetImage('assets/img/wallet.png',
                                                        ),
                                                          width:40,height:40,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),

                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.only(left:15),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('Wallet',style: Theme.of(context).textTheme.titleSmall),
                                                              Text('Paytm, PhonePe, Amazon Pay & more ',
                                                                style: Theme.of(context).textTheme.bodySmall,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        child: Container(
                                                            padding: const EdgeInsets.only(left:15),
                                                            child: InkWell(
                                                              onTap: (){},
                                                              child: Icon(Icons.arrow_forward_ios,size: 17,
                                                                color: Theme.of(context).disabledColor,
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                            DottedLine(
                                              dashColor: Theme.of(context).disabledColor.withOpacity(0.5),
                                            ),
                                            setting.value.codMode?   InkWell(
                                              onTap: (){
                                                setSelectedRadio(1,'COD','assets/img/cod.png');
                                              },
                                              child: Container(
                                                  padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                                  child:Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        width:40,height:40,
                                                        padding: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            border:Border.all(
                                                                width: 1,color:Theme.of(context).dividerColor
                                                            ),
                                                            borderRadius: BorderRadius.circular(4)
                                                        ),
                                                        child: const Image(image:AssetImage('assets/img/cod.png',
                                                        ),
                                                          width:40,height:40,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),

                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.only(left:15),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text('Pay On Delivery',style: Theme.of(context).textTheme.titleSmall),
                                                              Text('Pay with cash',
                                                                style: Theme.of(context).textTheme.bodySmall,
                                                              )

                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        child: Container(
                                                            padding: const EdgeInsets.only(left:15),
                                                            child: InkWell(
                                                              onTap: (){},
                                                              child: Icon(Icons.arrow_forward_ios,size: 17,
                                                                color: Theme.of(context).disabledColor,
                                                              ),
                                                            )
                                                        ),
                                                      )
                                                    ],
                                                  )
                                              ),
                                            ):Container(),
                                          ]
                                      ),
                                  ),

                                  const SizedBox(height:20),

                                ],
                              ),












    );
  }
}
