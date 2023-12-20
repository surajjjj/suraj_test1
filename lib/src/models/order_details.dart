import 'package:flutter/foundation.dart';

import 'address.dart';
import 'payment.dart';
import '../helpers/custom_trace.dart';
import 'cart_responce.dart';

class OrderDetailsModel {
  String id;
  List<CartResponse> productDetails = <CartResponse>[];
  Address addressUser = Address();
  Address addressShop = Address();
  Payment payment = Payment();
  String orderDate;
  String orderType;
  String userId;
  String saleCode;
  String status;
  bool instanceDelivery;
  String shopTypeId;
  String rating;
  String deliveryTime;
  String driverName;
  String driverRating;
  String driverId;
  String deliverySlot;
  String vendorLogo;


  OrderDetailsModel();

  OrderDetailsModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      productDetails = jsonMap['productDetails'] != null ? List.from(jsonMap['productDetails']).map((element) => CartResponse.fromJSON(element)).toList() : [];

      addressUser = jsonMap['addressUser'] != null ? Address.fromJSON(jsonMap['addressUser']) : Address.fromJSON({});
      addressShop = jsonMap['addressShop'] != null ? Address.fromJSON(jsonMap['addressShop']) : Address.fromJSON({});
      payment = jsonMap['payment'] != null ? Payment.fromJSON(jsonMap['payment']) : Payment.fromJSON({});
      userId = jsonMap['userID'] ?? '';
      saleCode = jsonMap['saleCode'] ?? '';
      orderDate = jsonMap['orderDate'] ?? '';
      status = jsonMap['status'] ?? '';
      orderType = jsonMap['orderType'] ?? '';
      shopTypeId = jsonMap['shopTypeId'] ?? '';
      deliveryTime = jsonMap['deliveryTime'] ?? '';
      driverName = jsonMap['driverName'] ?? '';
      rating = jsonMap['rating'] ?? '';
      driverRating = jsonMap['driverRating'] ?? '';
      instanceDelivery = jsonMap['instanceDelivery'];
      driverId = jsonMap['driverId'] ?? '';
      deliverySlot = jsonMap['deliverySlot'] ?? '';
      vendorLogo = jsonMap['vendorLogo'] ?? '';

    } catch (e) {
      id = '';
      productDetails = [];
      addressUser = Address.fromJSON({});
      addressShop = Address.fromJSON({});
      payment = Payment.fromJSON({});
      userId = '';
      orderDate = '';
      orderType = '';
      saleCode = '';
      status = '';
      vendorLogo = '';
      instanceDelivery = false;
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }



  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["cart"] = productDetails?.map((element) => element.toMap())?.toList();
    map["addressUser"] = addressUser.toMap();
    map["addressShop"] = addressShop.toMap();
    map["payment"] = payment.toMap();
    map["userId"] = userId;
    map["saleCode"] = saleCode;
    map["orderType"] = orderType;
    map["instanceDelivery"] = instanceDelivery;
    map["shopTypeId"] = shopTypeId;
    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
