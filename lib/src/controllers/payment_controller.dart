import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import '../helpers/helper.dart';
import '../models/checkout.dart';
import '../repository/order_repository.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/address.dart';
import '../repository/user_repository.dart' as user_repo;

class PaymentController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  WebViewController webView;
  String url = "";
  String payStackUrl = "";
  double progress = 0;
  Address deliveryAddress;
  OverlayEntry loader;
  PaymentController() {

    loader = Helper.overlayLoader(context);
    scaffoldKey = GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    final String apiToken = 'api_token=${user_repo.currentUser.value.apiToken}';
// ignore: deprecated_member_use
    payStackUrl = '${GlobalConfiguration().getString('base_url')}payment/paystack_controller/index/${user_repo.currentUser.value.id}/${currentCheckout.value.grand_total}/${user_repo.currentUser.value.email}?$apiToken';

    setState(() {});
    super.initState();
  }


  void bookOrder(Checkout order) {
    order.saleCode = '${DateTime.now().millisecondsSinceEpoch}${currentUser.value.id}';




   /* FirebaseFirestore.instance
        .collection('orderDetails')
        .doc(order.saleCode)
        .set({'status': 'Placed', 'userId': currentUser.value.id, 'orderId': order.saleCode, 'shopId': order.shopId,'userName': currentUser.value.name,
      'originLatitude': currentUser.value.latitude, 'originLongitude': currentUser.value.longitude, 'shopLatitude': double.tryParse(currentCheckout.value.shopLatitude),
      'shopLongitude': double.tryParse(currentCheckout.value.shopLongitude),'shopName':currentCheckout.value.shopName}).catchError((e) {
      print(e);
    }); */
    Overlay.of(context).insert(loader);
    bookOrderResp().then((value) {

      Navigator.of(context).pushNamed('/Thankyou', arguments: value);
    }).catchError((e) {
      // ignore: deprecated_member_use
      /*scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(e),
      ));*/
    }).whenComplete(() {
      Helper.hideLoader(loader);
      //refreshOrders();
      /** scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).orderThisorderidHasBeenCanceled(order.id)),
          )); */
    });
  }




 /* toaster(title, message, type){
    var snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: type=='success'?ContentType.success:
        type=='hep'?ContentType.help:
        type=='warning'?ContentType.help:
        ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  } */


}
