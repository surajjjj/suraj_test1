import 'package:dotted_line/dotted_line.dart';

import 'flutter_wave_payment.dart';
import 'paypal_payment.dart';
import 'stripe_payment.dart';
import '../repository/settings_repository.dart';
import '../controllers/cart_controller.dart';
import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// ignore: must_be_immutable
class PaymentWalletPage extends StatefulWidget {
  String amount;
  PaymentWalletPage({Key key, this.amount}) : super(key: key);
  @override
  PaymentWalletPageState createState() => PaymentWalletPageState();
}

class PaymentWalletPageState extends StateMVC<PaymentWalletPage> {
  CartController _con;
  String paymentMethod;
  String paymentMode;

  PaymentWalletPageState() : super(CartController()) {
    _con = controller;
  }

  Razorpay _razorpay;
  // ignore: deprecated_member_use
  List<bool> paymentSelect = List(8);
  int selectedRadio;
  int checkedItem = 0;

  @override
  void initState() {

    super.initState();
    selectedRadio = 0;
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);


    for(int i=0; i<=7; i++){
      paymentSelect[i] = false;
    }

  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      if (val == 1) {
        paymentMethod= 'cash on delivery';
      } else {
        paymentMethod = 'online';
      }
    });
  }

  selectPayment(id, paymentType){
    paymentMode = paymentType;
    setState(() {
      for(int i=0; i<=7; i++){
        if(id==i) {
          paymentSelect[i] = true;
        } else {
          paymentSelect[i] = false;
        }
      }
    });


    if (paymentMethod == '' || paymentMethod == null ) {
      // ignore: deprecated_member_use
      /*_con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
                              content: Text('Please select your payment'),
                            ));*/
    } else {
      if (paymentMethod== 'online') {
        if(paymentMode == 'RayzorPay') {
          openCheckout();

        } if(paymentMode == 'Paypal'){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PayPalPaymentWidget()));
        }if(paymentMode == 'Stripe'){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StripePaymentWidget()));
        }if(paymentMode == 'Flutterwave'){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FlutterWavePaymentWidget()));
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': setting.value.razorpay_key,
      'amount': double.parse(widget.amount) * 100,
      'name': setting.value.appName,
      'description': 'Online Shopping',
      'prefill': {'contact': currentUser.value.phone, 'email': currentUser.value.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      // debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    //Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
    _con.walletTopUp(widget.amount);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    //Fluttertoast.showToast(msg: "ERROR: " + response.code.toString() + " - " + response.message, timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color:Theme.of(context).dividerColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 27.0, left: 10.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).colorScheme.background,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 20.0),
                  Text(S.of(context).payment,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height:40),


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
                                      setSelectedRadio(2);
                                      selectPayment(0,'RayzorPay');
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
                                                      setSelectedRadio(2);

                                                      selectPayment(4,'Flutterwave');
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
                                      setSelectedRadio(2);

                                      selectPayment(4,'Flutterwave');
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
                                                      setSelectedRadio(2);

                                                      selectPayment(4,'Flutterwave');
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
                                      setSelectedRadio(2);

                                      selectPayment(2,'Paypal');
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
                                      setSelectedRadio(2);
                                      selectPayment(3,'Stripe');
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


                                ]
                            ),
                          ),


                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
