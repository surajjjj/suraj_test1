import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class AddonModel {
  // ignore: non_constant_identifier_names
  String addon_id;
  // ignore: non_constant_identifier_names
  String product_id;
  String name;
  String price;
  String type;
  bool selected = false;
  bool status;
  String foodType;
  AddonModel();

  AddonModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      addon_id = jsonMap['addon_id'] ?? '';
      product_id = jsonMap['product_id'].toString() ?? '';
      name = jsonMap['name'] ?? '';
      price = jsonMap['price'] ?? '';
      type = jsonMap['type'] ?? '';
      selected = jsonMap['selected']?? false;
      status =  jsonMap['status']?? false;
      foodType = jsonMap['foodType'] ?? '';
    } catch (e) {

      addon_id = '';
      product_id = '';
      name = '';
      price = '';
      type = '';
      selected = false;
      foodType = '';
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["addon_id"] = addon_id;
    map["product_id"] = product_id;
    map["name"] = name;
    map["price"] = price;
    map["type"] = type;
    map["selected"] = selected;
    map["foodType"] = foodType;
    return map;
  }

}
