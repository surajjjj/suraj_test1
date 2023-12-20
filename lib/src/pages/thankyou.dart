import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/checkout.dart';
import '../models/coupon.dart';
import '../repository/order_repository.dart';
import '../repository/product_repository.dart';
import 'dart:async';
import '../../generated/l10n.dart';
import '../repository/settings_repository.dart';

// ignore: must_be_immutable
class Thankyou extends StatefulWidget {
  Thankyou({Key key, this.orderId}) : super(key: key);
  String orderId;
  @override
  ThankyouState createState() => ThankyouState();
}

class ThankyouState extends State<Thankyou> with SingleTickerProviderStateMixin {
  // AudioPlayer advancedPlayer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
    //loadMusic();

  }



  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {

   if(currentCheckout.value.deliverType==2) {
      clearData();
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    }else if( currentCheckout.value.deliverType==3) {
     clearData();
     Navigator.of(context).pushReplacementNamed('/Takeaway', arguments: widget.orderId);
   }else {
      clearData();
      Navigator.of(context).pushReplacementNamed('/Map', arguments: widget.orderId);
    }
  }
  clearData(){
    currentCheckout.value.payment.method = '';
    currentCheckout.value.shopId = null;
    currentCheckout.value.cart.clear();
    currentCheckout.value.couponCode = '';
    currentCheckout.value.couponStatus = false;
    currentCheckout.value.couponData =  CouponModel();
    currentCart.value.clear();
    setCurrentCartItem();

    currentCheckout.value = Checkout();
    setCurrentCheckout(currentCheckout.value);


  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.only(top: 30,bottom:30),
              child: Text(
                S.of(context).thank_you,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SizedBox(
                width: size.width * 0.6,height:230,
                child:const ThankYouAnimation()
            ),

            Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
              ),
              margin: const EdgeInsets.only(top: 30),
              child: Text(
                '${S.of(context).your_order_will_be_delivered_shortly_keep} ${setting.value.appName}!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}


class ThankYouAnimation extends StatefulWidget {
  const ThankYouAnimation({Key key}) : super(key: key);


  @override
  State<ThankYouAnimation> createState() => _ThankYouAnimationState();
}

class _ThankYouAnimationState extends State<ThankYouAnimation>  with SingleTickerProviderStateMixin {

  AnimationController _controller2;
  @override
  void initState() {
    super.initState();

    _controller2 = AnimationController(vsync: this,);
  }

  @override
  void dispose() {
    _controller2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/img/thankyou.json',
      controller: _controller2,
      animate: true,
      onLoaded: (composition) {
        // Configure the AnimationController with the duration of the
        // Lottie file and start the animation.
        _controller2
          ..duration = composition.duration
          ..forward();
      },
    );
  }
}
