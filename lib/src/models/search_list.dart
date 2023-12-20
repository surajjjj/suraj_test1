import 'package:flutter/foundation.dart';

import 'product_details2.dart';

import '../helpers/custom_trace.dart';

class SearchList {
  String shopName;
  String distance;
  String delivery;
  String shopId;
  String shopImage;
  List<ProductDetails2> productDetail = <ProductDetails2>[];



  SearchList();

  SearchList.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      shopName = jsonMap['shopName'];
      distance = jsonMap['distance'];
      delivery = jsonMap['delivery'];
      shopId = jsonMap['shopId'];
      shopImage = jsonMap['shopImage'];
      productDetail = jsonMap['productDetail'] != null ? List.from(jsonMap['productDetail']).map((element) => ProductDetails2.fromJSON(element)).toList() : [];
    } catch (e) {
      shopName = '';
      distance = '';
      delivery = '';
      shopId = '';
      shopImage = '';
      productDetail = [];
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
