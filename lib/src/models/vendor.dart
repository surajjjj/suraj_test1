import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';
import 'shop_timing_model.dart';

class Vendor {
  String shopId;
  String shopName;
  String subtitle;
  String about;
  String phone;
  String locationMark;
  String address;
  String ratingNum;
  String ratingTotal;
  String distance;
  bool bestSeller = false;
  String logo;
  String cover;
  String openStatus;
  String longitude;
  String latitude;
  String shopType;
  String focusType;
  bool takeaway;
  bool schedule;
  bool 	instant;
  String foodType;
  ShopTimingModel shopTiming =  ShopTimingModel();
  String handoverTime = '0';
  DisplayCouponModel displayCoupon = DisplayCouponModel();




  Vendor();

  Vendor.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      shopId = jsonMap['shopId'];
      shopName = jsonMap['shopName'];
      about = jsonMap['about']??'';
      phone = jsonMap['phone']??'';
      address = jsonMap['address']??'';
      subtitle = jsonMap['subtitle'];
      locationMark = jsonMap['locationMark'];
      ratingNum = jsonMap['ratingNum'];
      ratingTotal = jsonMap['ratingTotal'];
      distance = jsonMap['distance'];
      logo = jsonMap['logo'];
      cover = jsonMap['cover'];
      openStatus = jsonMap['openStatus'];
      longitude = jsonMap['longitude'];
      latitude = jsonMap['latitude'];
      shopType = jsonMap['shopType'];
      focusType = jsonMap['focusType'];
      foodType = jsonMap['foodType'] ?? '';
      handoverTime = jsonMap['handoverTime'] ?? '0';
      takeaway = jsonMap['takeaway'] ?? false;
      schedule = jsonMap['schedule'] ?? false;
      instant = jsonMap['instant'] ?? false;
      bestSeller = jsonMap['bestSeller'] ?? false;
      shopTiming = jsonMap['shopTiming'] != null ? ShopTimingModel.fromJSON(jsonMap['shopTiming']) : ShopTimingModel.fromJSON({});
      displayCoupon = jsonMap['displayCoupon'] != null ? DisplayCouponModel.fromJSON(jsonMap['displayCoupon']) : DisplayCouponModel.fromJSON({});
    } catch (e) {
      shopId = '';
      shopName = '';
      subtitle = '';
      locationMark = '';
      ratingNum = '';
      ratingTotal = '';
      distance = '';
      logo = '';
      cover = '';
      openStatus = '';
      longitude = '';
      latitude = '';
      focusType = '';
      shopType = '';
      takeaway = false;
      schedule = false;
      instant = false;
      bestSeller = false;
      handoverTime = '0';
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["shopId"] = shopId;
    map["shopName"] = shopName;
    map["subtitle"] = subtitle;
    map["locationMark"] = locationMark;
    map["ratingNum"] = ratingNum;
    map["ratingTotal"] = ratingTotal;
    map["bestSeller"] = bestSeller;
    map["distance"] = distance;
    map["logo"] = logo;
    map["cover"] = cover;
    map["openStatus"] = openStatus;
    map["longitude"] = longitude;
    map["latitude"] = latitude;
    map["focusType"] = focusType;
    map["shopType"] = shopType;
    map["instant"] = instant;
    map["schedule"] = schedule;
    map["foodType"] = foodType;
    map["takeaway"] = takeaway;
    map["bestSeller"] = bestSeller;
    map["handoverTime"] = handoverTime;


    return map;
  }
}


class DisplayCouponModel{
  String title;
  String couponType;
  String discountType;
  String discount;



  DisplayCouponModel();
  DisplayCouponModel.fromJSON(Map<String,dynamic> jsonMap){
    try {
      title = jsonMap['title'] ?? '';
      couponType = jsonMap['couponType'] ?? '';
      discountType =
          jsonMap['discountType'] ?? '';
      discount = jsonMap['discount'] ?? '';
    }   catch (e) {
      if (kDebugMode) {
        print('vendor error $e');
      }
    }
  }



}