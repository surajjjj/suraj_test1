import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodzo/src/models/livemap_details.dart';

import '../models/cancelled.dart';
import '../models/driver_rating.dart';
import '../models/order_details.dart';
import 'user_repository.dart';
import '../models/coupon.dart';
import '../models/payment.dart';
import '../models/order_list.dart';
import '../models/rating.dart';
import '../models/user.dart';
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/checkout.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../repository/user_repository.dart' as user_repo;

ValueNotifier<Checkout> currentCheckout = ValueNotifier(Checkout());



// ignore: missing_return
Future<Stream<CouponModel>> getCoupon(type,vendorId,user) async {
  Uri uri = Helper.getUri('api/user/coupons/$type/$vendorId/$user');
  if (kDebugMode) {
    print(uri);
  }
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => CouponModel.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
  }
}


// ignore: missing_return
Future<OrderDetailsModel> getInvoiceDetails(orderID) async {
  final String apiToken = 'api_token=${currentUser.value.apiToken}';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/Order/orderDetails/$orderID/${currentUser.value.id}?$apiToken';
if (kDebugMode) {
  print(url);
}
  OrderDetailsModel res;
  try {
    final client = http.Client();
    final response = await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(''),
    );


    if (response.statusCode == 200) {

      res = OrderDetailsModel.fromJSON(json.decode(response.body)['data']);
          
      // print(res.payment.toMap());
      return res;
    } else {
      throw Exception(response.body);
    }
  } catch(e){
    if (kDebugMode) {
      print(e);
    }
  }
}

Future<bool> addFavorite() async {
  UserLocal user = user_repo.currentUser.value;
  if (user.apiToken == null) {
    return false;
  }
  final String apiToken = 'api_token=${user.apiToken}';

  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('api_base_url')}api/favorite/do_add/${user_repo.currentUser.value.id}/?$apiToken';

  try {
    final client = http.Client();
    await client.post(
        Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(user.toMap()),
    );
    return true;
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: url).toString());
    }
    return false;
  }
}

Future<String> bookOrderResp() async {
  if (kDebugMode) {
    print(currentCheckout.value.toMap());
  }
  Checkout book = currentCheckout.value;
  UserLocal user = user_repo.currentUser.value;

  final String apiToken = 'api_token=${user.apiToken}';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/order/do_add/${user.id}?$apiToken';
    if (kDebugMode) {
      print(url);
    }
  final client = http.Client();
  final response = await client.put(
      Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(book.toMap()),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'].toString();
  } else {
    if (kDebugMode) {
      print('error');
    }
    throw Exception(response.body);
  }
}

Future<String> cancelledOrder(CancelledModel orderReason) async {
  UserLocal user = user_repo.currentUser.value;

  final String apiToken = 'api_token=${user.apiToken}';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/cancelOrder/cancelled/${user.id}?$apiToken';

  final client = http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(orderReason.toMap()),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'];
  } else {

    throw Exception(response.body);
  }
}


Future<String> updateRating(RatingModel data) async {
  UserLocal user = user_repo.currentUser.value;

  final String apiToken = 'api_token=${user.apiToken}';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/rating/shoprating/${user.id}?$apiToken';
  if (kDebugMode) {
    print(url);
  }
  if (kDebugMode) {
    print(data.toMap());
  }
  final client = http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(data.toMap()),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'];
  } else {

    throw Exception(response.body);
  }
}

Future<String> updateDriverRating(DriverRatingModel data) async {
  UserLocal user = user_repo.currentUser.value;

  final String apiToken = 'api_token=${user.apiToken}';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/rating/driverrating/${user.id}?$apiToken';
  final client = http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(data.toMap()),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['data'];
  } else {

    throw Exception(response.body);
  }
}





Future<Stream<OrderList>> getOrders() async {
  UserLocal user = user_repo.currentUser.value;
  if (user.apiToken == null) {
    return Stream.value(null);
  }
  final String apiToken = 'api_token=${user.apiToken}&';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/order/list/${user.id}?$apiToken';
if (kDebugMode) {
  print(url);
}
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return OrderList.fromJSON(data);
    });
  } catch (e) {
    if (kDebugMode) {
      print('error');
    }
    if (kDebugMode) {
      print(e);
    }
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: url).toString());
    }
    return Stream.value(OrderList.fromJSON({}));
  }
}


Future<bool> checkRating(id) async {
  UserLocal user = user_repo.currentUser.value;
  if (user.apiToken == null) {
    return false;
  }
  final String apiToken = 'api_token=${user.apiToken}&';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('api_base_url')}api/review/check_rating/$id/${user_repo.currentUser.value.id}?$apiToken';

  bool res;
  final client = http.Client();
  final response = await client.post(
      Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(''),
  );
  if (response.statusCode == 200) {
    if (json.decode(response.body)['data'] == 'already') {
      res = false;
    } else {
      res = true;
    }
  } else {
    throw Exception(response.body);
  }
  return res;
}



// ignore: non_constant_identifier_names
Future<Payment> PaymentDetails(id) async {
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/liveTrackDetails/payment/$id';

  Payment paymentDetails;
  final client = http.Client();
  final response = await client.post(
      Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(''),
  );
  if (response.statusCode == 200) {

    paymentDetails = Payment.fromJSON(json.decode(response.body)['data']);

  } else {
    throw Exception(response.body);
  }
  return paymentDetails;
}

// ignore: non_constant_identifier_names
Future<LiveMapDetailModel> LiveMapDetails(id) async {
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/liveTrackDetails/orderDetails/$id';
   if (kDebugMode) {
     print(url);
   }
  LiveMapDetailModel orderDetails;
  final client = http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(''),
  );
  if (response.statusCode == 200) {

    orderDetails = LiveMapDetailModel.fromJSON(json.decode(response.body)['data']);

  } else {
    throw Exception(response.body);
  }
  return orderDetails;
}

