import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

// ignore: camel_case_types
class CombinationVariantModel {

  String cname;
  String variantPrice;
  String salesPrice;
  bool selected = false;
  String variantId;
  String variantName;
  String matchKey;



  CombinationVariantModel();

  CombinationVariantModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      variantId = jsonMap['variantId']?? '';
      cname = jsonMap['cname']?? '';
      variantPrice = jsonMap['variantPrice']?? '';
      salesPrice = jsonMap['salesPrice']?? '';
      selected = jsonMap['selected']?? false;
      variantName = jsonMap['variantName']?? '';
      matchKey = jsonMap['matchKey']?? '';





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
    map["cname"] = cname;
    map["variantPrice"] = variantPrice;
    map["salesPrice"] = salesPrice;
    map["selected"] = selected;
    map["variantName"] = variantName;
    map["matchKey"] = matchKey;
    return map;
  }

}
