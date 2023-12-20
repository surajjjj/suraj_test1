
import 'package:flutter/foundation.dart';

class RatingModel {

  String orderId;
  String rating;
  String message;
  String buyer;
  String vendor;
  List<ReviewItemModel> itemReview = <ReviewItemModel>[];
  RatingModel();

  RatingModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      orderId = jsonMap['orderId'].toString();
      rating = jsonMap['rating'];
      message = jsonMap['message'];
      buyer = jsonMap['buyer'];
      vendor = jsonMap['vendor'];
      itemReview = jsonMap['itemReview'] != null ? List.from(jsonMap['itemReview']).map((element) => ReviewItemModel.fromJSON(element)).toList() : [];

    } catch (e) {
        if (kDebugMode) {
          print(e);
        }

    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["orderId"] = orderId;
    map["rating"] = rating;
    map["message"] = message;
    map["buyer"] = buyer;
    map["vendor"] = vendor;
    map["itemReview"] = itemReview?.map((element) => element.toMap())?.toList();
    return map;
  }
}


class ReviewItemModel {

  String productId;
  String rating;
  String message;
  String image;
  String productName;


  ReviewItemModel();

  ReviewItemModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      productId = jsonMap['productId'];
      rating = jsonMap['rating'];
      message = jsonMap['message'];
      image = jsonMap['image'];
      productName = jsonMap['productName'];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["productId"] = productId;
    map["rating"] = rating;
    map["message"] = message;
    map["image"] = image;
    map["productName"] = productName;
    return map;
  }
}



