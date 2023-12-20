import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class TakeawayModel {
  String shopId;
  String shopName;
  String rating;
  double shopLatitude= 0.0;
  double shopLongitude = 0.0;
  String shopPhone;
  String shopAddress;
  String ratingNum;
  String status;
  String shopLogo;


  TakeawayModel();

  TakeawayModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      shopId = jsonMap['shopId'].toString();
      shopName = jsonMap['shopName'] ?? '';
      shopLatitude = jsonMap['shopLatitude'].toDouble() ?? 0.0;
      shopLongitude = jsonMap['shopLongitude'].toDouble() ?? 0.0;
      rating = jsonMap['rating'] ?? '';
      shopPhone = jsonMap['shopPhone'] ?? '';
      shopAddress = jsonMap['shopAddress'] ?? '';
      ratingNum = jsonMap['ratingNum'] ?? '';
      status = jsonMap['status'] ?? false;
      shopLogo = jsonMap['shopLogo'] ?? '';

    } catch (e) {
      shopId = '';
      shopName = '';
      shopLatitude = 0.0;
      shopLongitude = 0.0;
      rating = '';
      shopPhone = '';
      shopAddress = '';
      ratingNum = '';
      status = '';
      shopLogo = '';
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map<String, dynamic> toJson() => {
    "shopId": shopId,
    "shopName": shopName,
    "shopLatitude": shopLatitude,
    "shopLongitude": shopLongitude,
    "rating": rating,
    "shopPhone": shopPhone,
    "shopAddress": shopAddress,
    "ratingNum": ratingNum,
    "status": status,
    "shopLogo":shopLogo
  };

  Map toMap() {
    var map = <String, dynamic>{};
    map["shopId"] = shopId;
    map["shopName"] = shopName;
    map["shopLatitude"] = shopLatitude;
    map["shopLongitude"] = shopLongitude;
    map["rating"] = rating;
    map["shopPhone"] = shopPhone;
    map["shopAddress"] = shopAddress;
    map["ratingNum"] = ratingNum;
    map["status"] = status;
    map["shopLogo"] = shopLogo;

    return map;
  }
}
