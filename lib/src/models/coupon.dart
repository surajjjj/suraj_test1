

import 'package:flutter/foundation.dart';

class CouponModel{
  String title;
  String code;
  String image;
  String couponType;
  String discountType;
  String discount;
  String terms;
  String minimumPurchasedAmount;
  String limitUser;
  String zoneId;
  String shopId;



  CouponModel();
  CouponModel.fromJSON(Map<String,dynamic> jsonMap){
    try {
      title = jsonMap['title'] ?? '';
      code = jsonMap['code'] ?? '';
      image = jsonMap['image'] ?? '';
      couponType = jsonMap['couponType'] ?? '';
      limitUser = jsonMap['limitUser'] ?? '';
      discountType =
      jsonMap['discountType'] ?? '';
      discount = jsonMap['discount'] ?? '0.0';
      terms = jsonMap['terms'] ?? '';
      minimumPurchasedAmount =
      jsonMap['minimumPurchasedAmount'] ?? '0.0';
    }   catch (e) {
      if (kDebugMode) {
        print('coupon error $e');
      }
    }
    }

  Map<String, dynamic> toJson() => {
    "title": title,
    "code": code,
    "image": image,
    "couponType": couponType,
    "limitUser": limitUser,
    "discountType": discountType,
    "discount": discount,
    "terms": terms,
    "minimumPurchasedAmount": minimumPurchasedAmount,
  };


  Map toMap(){
    var map=<String,dynamic>{};
    map['title']=title;
    map['code']=code;
    map['image']=image;
    map['couponType']=couponType;
    map['limitUser']=limitUser;
    map['discountType']=discountType;
    map['discount']=discount;
    map['terms']=terms;
    map['minimumPurchasedAmount']= minimumPurchasedAmount;
    return map;
}
}