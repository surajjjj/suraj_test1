import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class ShopRatingModel {
  double rate;
  String message;
  String buyer;
  String vendor;
  String image;
  String date;

  ShopRatingModel();

  ShopRatingModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      rate = jsonMap['rate'].toDouble() ?? 0;
      message = jsonMap['message'] ?? '';
      buyer = jsonMap['buyer'] ?? '';
      vendor = jsonMap['vendor'] ?? '';
      image = jsonMap['image'] ?? '';
      date = jsonMap['date'] ?? '';
    } catch (e) {


      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["rate"] = rate;
    map["message"] = message;
    map["buyer"] = buyer;
    map["vendor"] = vendor;

    return map;
  }
}
