import 'flutter_wave_payment.dart';
import 'paypal_payment.dart';
import 'stripe_payment.dart';
import '../repository/settings_repository.dart';
import '../controllers/cart_controller.dart';
import '../helpers/helper.dart';
import '../repository/order_repository.dart';
import '../../generated/l10n.dart';
import 'package:flutter/material.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key key}) : super(key: key);

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends StateMVC<PaymentPage> {
  CartController _con;

  PaymentPageState() : super(CartController()) {
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
    currentCheckout.value.payment.packingCharge = currentCheckout.value.packingCharge;
    currentCheckout.value.payment.delivery_tips = currentCheckout.value.delivery_tips;
    currentCheckout.value.payment.delivery_fees = currentCheckout.value.delivery_fees;
    currentCheckout.value.payment.sub_total     = currentCheckout.value.sub_total;
    currentCheckout.value.payment.discount      = currentCheckout.value.discount;
    currentCheckout.value.payment.grand_total   = currentCheckout.value.grand_total;



    for(int i=0; i<=7; i++){
      paymentSelect[i] = false;
    }

  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
      if (val == 1) {
        currentCheckout.value.payment.method = 'cash on delivery';
      } else {
        currentCheckout.value.payment.method = 'online';
      }
    });
  }

  selectPayment(id, paymentType){
    currentCheckout.value.payment.paymentType = paymentType;
    setState(() {
      for(int i=0; i<=7; i++){
        if(id==i) {
          paymentSelect[i] = true;
        } else {
          paymentSelect[i] = false;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': setting.value.razorpay_key,
      'amount': currentCheckout.value.grand_total * 100,
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
    _con.bookOrder(currentCheckout.value);
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
                          const SizedBox(height:20),
                          setting.value.rayzorPay?Container(
                            padding: const EdgeInsets.only(left:20,right:20,bottom:10),
                            child:InkWell(
                              onTap: (){
                                setSelectedRadio(2);
                                selectPayment(0,'RayzorPay');

                              },
                              child: Container(
                                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom:10),
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.1),
                                          blurRadius: 1.5,
                                          spreadRadius: 1.5,
                                        ),
                                      ]),
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     const SizedBox(
                                        width:50,height:50,
                                        child: Image(image:AssetImage('assets/img/razorpay.png'),
                                        ),
                                      ),
                                      const SizedBox(width:20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('RayzorPay',style: Theme.of(context).textTheme.titleLarge),

                                          ],
                                        ),
                                      ),
                                      paymentSelect[0]==true?Align(
                                        child: Container(
                                            padding: const EdgeInsets.only(left:10),
                                            child: IconButton(
                                              onPressed: (){},
                                              icon:const Icon(Icons.check_circle,color:Colors.green),
                                            )
                                        ),
                                      ):Container()
                                    ],
                                  )
                              ),
                            ),
                          ):Container(),
                          setting.value.upi? Container(
                            padding: const EdgeInsets.only(left:20,right:20,bottom:10),
                            child:InkWell(
                              onTap: (){
                                setSelectedRadio(2);
                                selectPayment(1,'UPI');

                              },
                              child: Container(
                                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom:10),
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.1),
                                          blurRadius: 1.5,
                                          spreadRadius: 1.5,
                                        ),
                                      ]),
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     const SizedBox(
                                        width:50,height:50,
                                        child: Image(image:AssetImage('assets/img/upi.png'),
                                        ),
                                      ),
                                      const SizedBox(width:20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('UPI',style: Theme.of(context).textTheme.titleLarge),
                                            Text(S.of(context).coming_soon,style: const TextStyle(color: Colors.red),)
                                          ],
                                        ),
                                      ),
                                      paymentSelect[1]==true?Align(
                                        child: Container(
                                            padding: const EdgeInsets.only(left:10),
                                            child: IconButton(
                                              onPressed: (){},
                                              icon:const Icon(Icons.check_circle,color:Colors.green),
                                            )
                                        ),
                                      ):Container()
                                    ],
                                  )
                              ),
                            ),
                          ):Container(),
                          setting.value.paypal? Container(
                            padding: const EdgeInsets.only(left:20,right:20,bottom:10),
                            child:InkWell(
                              onTap: (){
                                setSelectedRadio(2);

                                selectPayment(2,'Paypal');
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom:10),
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.1),
                                          blurRadius: 1.5,
                                          spreadRadius: 1.5,
                                        ),
                                      ]),
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width:50,height:50,
                                        child: Image(image:AssetImage('assets/img/paypal.png'),
                                        ),
                                      ),
                                      const SizedBox(width:20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(S.of(context).paypal,style: Theme.of(context).textTheme.titleLarge),

                                          ],
                                        ),
                                      ),
                                      paymentSelect[2]==true?Align(
                                        child: Container(
                                            padding: const EdgeInsets.only(left:10),
                                            child: IconButton(
                                              onPressed: (){},
                                              icon:const Icon(Icons.check_circle,color:Colors.green),
                                            )
                                        ),
                                      ):Container()
                                    ],
                                  )
                              ),
                            ),
                          ):Container(),
                          setting.value.stripe? Container(
                            padding: const EdgeInsets.only(left:20,right:20,bottom:10),
                            child:InkWell(
                              onTap: (){
                                setSelectedRadio(2);
                                selectPayment(3,'Stripe');

                              },
                              child: Container(
                                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom:10),
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.1),
                                          blurRadius: 1.5,
                                          spreadRadius: 1.5,
                                        ),
                                      ]),
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width:50,height:50,
                                        child: Image(image:AssetImage('assets/img/stripe.png'),
                                        ),
                                      ),
                                      const SizedBox(width:20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(S.of(context).stripe,style: Theme.of(context).textTheme.titleLarge),

                                          ],
                                        ),
                                      ),
                                      paymentSelect[3]==true?Align(
                                        child: Container(
                                            padding: const EdgeInsets.only(left:10),
                                            child: IconButton(
                                              onPressed: (){},
                                              icon:const Icon(Icons.check_circle,color:Colors.green),
                                            )
                                        ),
                                      ):Container()
                                    ],
                                  )
                              ),
                            ),
                          ):Container(),
                          setting.value.flutterWave?      Container(
                            padding: const EdgeInsets.only(left:20,right:20,bottom:10),
                            child:InkWell(
                              onTap: (){
                                setSelectedRadio(2);

                                selectPayment(4,'Flutterwave');
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom:10),
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.1),
                                          blurRadius: 1.5,
                                          spreadRadius: 1.5,
                                        ),
                                      ]),
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     const SizedBox(
                                        width:50,height:50,
                                        child: Image(image:AssetImage('assets/img/flutterwave.png'),
                                        ),
                                      ),
                                      const SizedBox(width:20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(S.of(context).flutterwave,style: Theme.of(context).textTheme.titleLarge),

                                          ],
                                        ),
                                      ),
                                      paymentSelect[4]==true? Align(
                                        child: Container(
                                            padding: const EdgeInsets.only(left:10),
                                            child: IconButton(
                                              onPressed: (){},
                                              icon:const Icon(Icons.check_circle,color:Colors.green),
                                            )
                                        ),
                                      ):Container()
                                    ],
                                  )
                              ),
                            ),
                          ):Container(),
                          Container(
                            padding: const EdgeInsets.only(left:20,right:20,bottom:10),
                            child:InkWell(
                              onTap: (){
                                setSelectedRadio(1);
                                selectPayment(5,'COD');
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom:10),
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.1),
                                          blurRadius: 1.5,
                                          spreadRadius: 1.5,
                                        ),
                                      ]),
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width:50,height:50,
                                        child: Image(image:AssetImage('assets/img/cod.png'),
                                        ),
                                      ),
                                      const SizedBox(width:20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('COD',style: Theme.of(context).textTheme.titleLarge),

                                          ],
                                        ),
                                      ),
                                      paymentSelect[5]==true?Align(
                                        child: Container(
                                            padding: const EdgeInsets.only(left:10),
                                            child: IconButton(
                                              onPressed: (){},
                                              icon:const Icon(Icons.check_circle,color:Colors.green),
                                            )
                                        ),
                                      ):Container()
                                    ],
                                  )
                              ),
                            ),
                          ),



                          Container(
                            padding: const EdgeInsets.only(left:20,right:20,bottom:10),
                            child:InkWell(
                              onTap: (){
                                if(currentUser.value.walletAmount!='0') {

                                  if(int.parse(currentUser.value.walletAmount)>currentCheckout.value.grand_total) {

                                    setSelectedRadio(1);
                                    selectPayment(6, 'wallet');
                                  } else{
                               //     _con.toaster('Oops !','Low balance Please recharge','error');

                                  }
                                } else{
                                //  _con.toaster('Oops !','Your wallet balance is 0 Please recharge','error');

                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10,bottom:10),
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.1),
                                          blurRadius: 1.5,
                                          spreadRadius: 1.5,
                                        ),
                                      ]),
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        width:50,height:50,
                                        child: Image(image:AssetImage('assets/img/wallet.png'),
                                        ),
                                      ),
                                      const SizedBox(width:20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${S.of(context).wallet}   (${S.of(context).balance} ${Helper.pricePrint(currentUser.value.walletAmount)}) ',style: Theme.of(context).textTheme.titleLarge),

                                          ],
                                        ),
                                      ),
                                      paymentSelect[6]==true?Align(
                                        child: Container(
                                            padding: const EdgeInsets.only(left:10),
                                            child: IconButton(
                                              onPressed: (){},
                                              icon:const Icon(Icons.check_circle,color:Colors.green),
                                            )
                                        ),
                                      ):Container()
                                    ],
                                  )
                              ),
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


            Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      width: double.infinity,
                      height: 160.0,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Column(
                          children: [
                            Text(
                              '${S.of(context).you_save} ${Helper.pricePrint(currentCheckout.value.discount.toString())} ${S.of(context).on_this_order}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(
                                color: Theme.of(context).primaryColorDark.withOpacity(0.7),
                              )),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).item_total, style: Theme.of(context).textTheme.titleSmall),
                                Text('${Helper.pricePrint(currentCheckout.value.sub_total.toString())}', style: Theme.of(context).textTheme.titleSmall)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).delivery_fee, style: Theme.of(context).textTheme.titleSmall),
                                Text('${Helper.pricePrint(currentCheckout.value.delivery_fees.toString())}', style: Theme.of(context).textTheme.titleSmall)

                              ],
                            ),
                            currentCheckout.value.shopTypeID==2? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Packaging charges', style: Theme.of(context).textTheme.titleSmall),
                                Text('${Helper.pricePrint(currentCheckout.value.packingCharge.toString())}', style: Theme.of(context).textTheme.titleSmall)
                              ],
                            ):Container(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).delivery_tip, style: Theme.of(context).textTheme.titleSmall),
                                Text('${Helper.pricePrint(currentCheckout.value.delivery_tips.toString())}', style: Theme.of(context).textTheme.titleSmall)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).discount, style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color: Colors.green))),
                                Text('${Helper.pricePrint(currentCheckout.value.discount.toString())}', style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color: Colors.green)))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).tax, style: Theme.of(context).textTheme.titleSmall),
                                Text('${Helper.pricePrint(currentCheckout.value.tax.toString())}', style: Theme.of(context).textTheme.titleSmall)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(S.of(context).to_pay, style: Theme.of(context).textTheme.titleSmall),
                                Text('${Helper.pricePrint(currentCheckout.value.grand_total.toString())}', style: Theme.of(context).textTheme.titleSmall)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Container(
                      width: double.infinity,
                      height: 60.0,
                      decoration: BoxDecoration(
                          color:Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40))),
                      // ignore: deprecated_member_use
                      child: ElevatedButton(
                        onPressed: () {

                          if (currentCheckout.value.payment.method == '' || currentCheckout.value.payment.method == null ) {
                            // ignore: deprecated_member_use
                           /* _con.scaffoldKey?.currentState?.showSnackBar(SnackBar(
                              content: Text('Please select your payment'),
                            ));*/
                          } else {
                            if (currentCheckout.value.payment.method == 'online') {
                              if(currentCheckout.value.payment.paymentType == 'RayzorPay') {
                                openCheckout();
                              } if(currentCheckout.value.payment.paymentType == 'Paypal'){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PayPalPaymentWidget()));
                              }if(currentCheckout.value.payment.paymentType == 'Stripe'){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StripePaymentWidget()));
                              }if(currentCheckout.value.payment.paymentType == 'Flutterwave'){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FlutterWavePaymentWidget()));
                              }if(currentCheckout.value.payment.paymentType == 'wallet'){
                                _con.bookOrder(currentCheckout.value);
                              }
                            } else {

                              _con.bookOrder(currentCheckout.value);
                            }
                          }
                        },
                        child: Center(
                            child: Text(
                              S.of(context).done,
                              style: Theme.of(context).textTheme.displayMedium.merge(TextStyle(color: Theme.of(context).primaryColorLight)),
                            )),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
