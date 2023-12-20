import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

// ignore: camel_case_types
class variantModel {

  String variantId;
  String variantName;
  int step;
  String subtype;
  bool selected = false;
  String productId;



  variantModel();

  variantModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      variantId = jsonMap['variantId']?? '';
      variantName = jsonMap['variantName']?? '';
      subtype = jsonMap['subtype']?? '';
      step = jsonMap['step']?? 0;
      selected = jsonMap['selected']?? false;
      productId = jsonMap['productId']?? '';





    } catch (e) {

      if (kDebugMode) {
        print('error variant');
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["variantId"] = variantId;
    map["variantName"] = variantName;
    map["step"] = step;
    map["subtype"] = subtype;
    map["selected"] = selected;
    map["productId"] = productId;
    return map;
  }

}
