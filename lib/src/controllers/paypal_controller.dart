import 'dart:io';
import 'package:http/http.dart' as http;
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

class PayPalController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  WebViewController webView;
  String url = "";
  double progress = 0;
  Address deliveryAddress;
  OverlayEntry loader;
  PayPalController() {

    loader = Helper.overlayLoader(context);
    scaffoldKey = GlobalKey<ScaffoldState>();
  }
  @override
  void initState() {
    final String apiToken = 'api_token=${user_repo.currentUser.value.apiToken}';
// ignore: deprecated_member_use
    url = '${GlobalConfiguration().getString('base_url')}payment/Paypal/index/${user_repo.currentUser.value.id}/${currentCheckout.value.grand_total}?$apiToken';
    //   url = 'http://192.168.1.4/map/index.html';

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


  void sendImage(File image, saleCode) async {


    final String apiToken = 'api_token=${currentUser.value.apiToken}';
    // ignore: deprecated_member_use
    final uri = Uri.parse("${GlobalConfiguration().getString('base_url')}Api/sendimage/${currentUser.value.id}/$saleCode?$apiToken");
    var request = http.MultipartRequest('POST', uri);
    var pic = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(pic);
    var response = await request.send();
    if (response.statusCode == 200) {
      // Navigator.of(context).pushReplacementNamed('/Success');

    } else {}
  }





}
