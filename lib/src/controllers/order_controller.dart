import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../helpers/helper.dart';
import '../models/cancelled.dart';
import '../models/order_details.dart';
import '../repository/user_repository.dart';
import '../models/driver_rating.dart';
import '../models/payment.dart';
import '../models/rating.dart';
import '../repository/order_repository.dart';
import '../repository/order_repository.dart' as repository;
import '../models/order_list.dart';
import 'package:mvc_pattern/mvc_pattern.dart';


class OrderController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<OrderList> orders = <OrderList>[];
  List<OrderList> tempOrders = <OrderList>[];
  RatingModel ratingData = RatingModel();
  DriverRatingModel ratingDriverDate = DriverRatingModel();
  Payment paymentData =  Payment();
  CancelledModel cancelledData = CancelledModel();
  OverlayEntry loader;
  bool notFound = false;
  OrderDetailsModel invoiceDetailsData = OrderDetailsModel();
  OrderController() {
    loader = Helper.overlayLoader(context);

    scaffoldKey = GlobalKey<ScaffoldState>();
  }


  Future<void> listenForOrders({String message}) async {
    setState(() => notFound = false);
      final Stream<OrderList> stream = await getOrders();
    stream.listen((OrderList order) {
      setState(() {
        orders.add(order);
        tempOrders.add(order);
      });
    }, onError: (a) {
    }, onDone: () {
      setState(() {
        if(orders.isEmpty ){
          notFound = true;
        }
      });
    });
  }

  ordersToRatingModel(OrderDetailsModel invoiceDetailsData){
    ratingData.orderId = invoiceDetailsData.id;
    ratingData.vendor  = invoiceDetailsData.addressShop.id;
    ratingData.rating  = '4';

    for (var element in invoiceDetailsData.productDetails) {
      ReviewItemModel itemReview = ReviewItemModel();
      itemReview.productId = element.productId;
      itemReview.productName = element.product_name;
      itemReview.image = element.image;
      ratingData.itemReview.add(itemReview);
    }
  }

  listenForInvoiceDetails(id){
    repository.getInvoiceDetails(id).then((value) {
      setState(() => invoiceDetailsData = value);
    }).whenComplete(() {

    });
  }

  submitRating(RatingModel ratingData){
        ratingData.buyer = currentUser.value.id;
        Overlay.of(context).insert(loader);
        repository.updateRating(ratingData).then((value) {
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
         toaster('Great !','Your rating  is update successfully','success');
        }).catchError((e) {
          loader.remove();
          // ignore: deprecated_member_use
         /* scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S
                .of(context)
                .this_email_account_exists),
          ));*/
        }).whenComplete(() {
          Helper.hideLoader(loader);
        });

  }

  submitDriverRating(DriverRatingModel ratingData){
    ratingData.buyer = currentUser.value.id;
    Overlay.of(context).insert(loader);
    repository.updateDriverRating(ratingData).then((value) {
     Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
      toaster('Great !','Your rating  is update successfully','success');
    }).catchError((e) {
      loader.remove();
      // ignore: deprecated_member_use
      /* scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S
                .of(context)
                .this_email_account_exists),
          ));*/
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });

  }



  void listenForPaymentDetails(id) async {

      repository.PaymentDetails(id).then((value) {

        setState(() { paymentData = value; });
      }).catchError((e) {

      }).whenComplete(() {

      });
    }


  void cancelOrder() async {


      Overlay.of(context).insert(loader);
      repository.cancelledOrder(cancelledData).then((value) {
        toaster('Cancelled !','Your cancelled reason is update successfully','success');
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);

      }).catchError((e) {
        loader.remove();
        // ignore: deprecated_member_use
       /* scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_email_account_exists),
        ));*/
      }).whenComplete(() {
        updateOrderStatus(cancelledData.orderId, true);
        Helper.hideLoader(loader);
      });
    }





  updateOrderStatus(id, status) {
    FirebaseFirestore.instance.collection('orderDetails').doc(id).update({'grandState': status}).catchError((e) {

    });
  }

searchOrders(text){
    
    
}


  toaster(title, message, type){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: type=='success'?Colors.green:
        type=='error'?Colors.red:Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }



  Future<void> refreshOrders() async {
    setState(() {
      orders.clear();
    });
    await   listenForOrders();
  }
  }

