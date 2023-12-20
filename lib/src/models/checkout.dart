import 'package:flutter/foundation.dart';

import 'coupon.dart';
import 'vendor.dart';

import 'address.dart';
import 'payment.dart';
import '../helpers/custom_trace.dart';
import 'cart_responce.dart';

class Checkout {
  String id;

  // ignore: non_constant_identifier_names
  double grand_total = 0.0;
  double discount = 0.0;
  // ignore: non_constant_identifier_names
  double sub_total = 0.0;
  double tax = 0.0;
  String userId;
  String saleCode;

  String deliveryTimeSlot;
  String deliveryTime;
  String shopId;
  String shopName;
  String shopAddress;
  String shopImage;
  String subtitle;
  int shopTypeID = 0;
  double km = 0.0;
  // ignore: non_constant_identifier_names
  double delivery_fees = 0;
  // ignore: non_constant_identifier_names
  double delivery_tips =0;
  String shopLatitude;
  String shopLongitude;
  int deliverType;
  int focusId;
  bool deliveryPossible = false;
  String zoneId;
  double packingCharge = 0.0;
  int handoverTime = 0;
  String couponCode;
  CouponModel couponData = CouponModel();
  bool couponStatus = false;
  Vendor vendor = Vendor();
  String instructionNote;
  String deliveryInstruction;

  List<CartResponse> cart = <CartResponse>[];
  Address address = Address();
  Payment payment = Payment();



  Checkout();

  Checkout.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      grand_total = jsonMap['grand_total'] != null ? jsonMap['grand_total'].toDouble() : 0;
      tax = jsonMap['tax'] != null ? jsonMap['tax'].toDouble() : 0;
      discount = jsonMap['discount'] ?? '';
      sub_total = jsonMap['sub_total'] ?? '';
      userId = jsonMap['userID'] ?? '';
      saleCode = jsonMap['saleCode'] ?? '';
      deliveryTimeSlot = jsonMap['deliveryTimeSlot'] ?? '';
      deliveryTime = jsonMap['deliveryTime'] ?? '';
      shopId = jsonMap['shopId'] ?? '';
      shopName = jsonMap['shopName'] ?? '';
      shopAddress = jsonMap['shopAddress'] ?? '';
      subtitle = jsonMap['subtitle'] ?? '';
      shopImage = jsonMap['shopImage'] ?? '';
      shopTypeID = jsonMap['shopTypeID'] ?? 0;
      km = jsonMap['km']!= null ? jsonMap['km'].toDouble() : 0;
      delivery_fees = jsonMap['delivery_fees']!= null ? jsonMap['delivery_fees'].toDouble() : 0;
      delivery_tips = jsonMap['delivery_tips']!= null ? jsonMap['delivery_tips'].toDouble() : 0;
      shopLatitude = jsonMap['shopLatitude'] ?? '';
      shopLongitude = jsonMap['shopLongitude'] ?? '';
      deliverType = jsonMap['deliverType'] ?? 0;
      focusId = jsonMap['focusId'] ?? 0;
      deliveryPossible = jsonMap['deliveryPossible'] ?? false;
      zoneId = jsonMap['zoneId'] ?? '';
      handoverTime = jsonMap['handoverTime'] ?? 0;
      packingCharge = jsonMap['packingCharge']!= null ? jsonMap['packingCharge'].toDouble() : 0;
      couponData = jsonMap['couponData'] != null ? CouponModel.fromJSON(jsonMap['couponData']) : CouponModel.fromJSON({});
      couponCode = jsonMap['couponCode'] ?? '';
      couponStatus = jsonMap['couponStatus'] ?? false;
      instructionNote = jsonMap['cookingInstruction'] ?? '';
      deliveryInstruction = jsonMap['deliveryInstruction'] ?? '';
      vendor = jsonMap['vendor'] != null ? Vendor.fromJSON(jsonMap['vendor']) : Vendor.fromJSON({});
      cart = jsonMap['cart'] != null ? List.from(jsonMap['cart']).map((element) => CartResponse.fromJSON(element)).toList() : [];
      address = jsonMap['address'] != null ? Address.fromJSON(jsonMap['address']) : Address.fromJSON({});
      payment = jsonMap['payment'] != null ? Payment.fromJSON(jsonMap['payment']) : Payment.fromJSON({});

    } catch (e) {
      id = '';
      grand_total = 0;
      tax = 0;
      cart = [];
      address = Address.fromJSON({});
      payment = Payment.fromJSON({});
      userId = '';
      saleCode = '';
      couponCode = '';
      couponStatus = false;
      couponData = CouponModel.fromJSON({});
      deliveryTimeSlot = '';
      deliveryTime = '';
      shopId = null;
      shopImage = '';
      subtitle = '';
      km =0.0;
      delivery_fees = 0;
      delivery_tips = 0;
      shopLatitude = '';
      shopLongitude = '';
      deliverType = 0;
      focusId = 0;
      instructionNote = '';
      deliveryPossible = false;
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "tax": tax,

    "grand_total": grand_total,
    "sub_total": sub_total,
    "discount": discount,
    "userId": userId,
    "saleCode": saleCode,
    "couponCode": couponCode,
    "couponStatus": couponStatus,
    "deliveryTimeSlot": deliveryTimeSlot,
    "deliveryTime": deliveryTime,
    "shopId": shopId,
    "shopName": shopName,
    "shopImage": shopImage,
    "km": km,
    "subtitle": subtitle,
    "delivery_fees": delivery_fees,
    "delivery_tips": delivery_tips,
    "deliverType": deliverType,
    "focusId": focusId,
    "deliveryPossible" : deliveryPossible,
    "shopAddress": shopAddress,
    'packingCharge': packingCharge,
    "handoverTime": handoverTime,
    "instructionNote": instructionNote,
    'deliveryInstruction': deliveryInstruction,
    "vendor": vendor.toMap(),
    "cart": cart?.map((element) => element.toMap())?.toList(),
    "address": address.toMap(),
    "payment": payment.toMap(),
    'couponData': couponData?.toMap(),
  };


  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["tax"] = tax;

    map["grand_total"] = grand_total;
    map["sub_total"] = sub_total;
    map["discount"] = discount;
    map["userId"] = userId;
    map["saleCode"] = saleCode;
    map["couponCode"] = couponCode;
    map["couponStatus"] = couponStatus;
    map["deliveryTimeSlot"] = deliveryTimeSlot;
    map["deliveryTime"] = deliveryTime;
    map["shopId"] = shopId;
    map["shopName"] = shopName;
    map["shopImage"] = shopImage;
    map["shopTypeID"] = shopTypeID;
    map["km"] = km;
    map["subtitle"] = subtitle;
    map["delivery_fees"] = delivery_fees;
    map["delivery_tips"] = delivery_tips;
    map["shopLatitude"] = shopLatitude;
    map["shopLongitude"] = shopLongitude;
    map["deliverType"] = deliverType;
    map["focusId"] = focusId;
    map["shopAddress"] = shopAddress;
    map["deliveryPossible"] = deliveryPossible;
    map["zoneId"] = zoneId;
    map["packingCharge"] = packingCharge;
    map["handoverTime"] = handoverTime;
    map["instructionNote"] = instructionNote;
    map["deliveryInstruction"] = deliveryInstruction;
    map["vendor"] = vendor.toMap();
    map["cart"] = cart?.map((element) => element.toMap())?.toList();
    map["address"] = address.toMap();
    map["payment"] = payment.toMap();
    map["couponData"] = couponData?.toMap();


    return map;
  }

  @override
  bool operator ==(dynamic other) {
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
