import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class DriverRatingModel {
  double rate;
  String message;
  String buyer;
  String driver;
  String orderId;

  DriverRatingModel();

  DriverRatingModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      rate = jsonMap['rate'];
      orderId = jsonMap['orderId'] ?? false;
      message = jsonMap['message'] ?? '';
      buyer = jsonMap['buyer'] ?? '';
      driver = jsonMap['driver'] ?? '';
    } catch (e) {


      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["rate"] = rate;
    map["orderId"] = orderId;
    map["message"] = message;
    map["buyer"] = buyer;
    map["driver"] = driver;

    return map;
  }
}
