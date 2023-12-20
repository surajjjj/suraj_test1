import 'package:flutter/foundation.dart';

import 'product_details2.dart';
import '../helpers/custom_trace.dart';

class RestaurantProduct {
  String id;
  String image;
  // ignore: non_constant_identifier_names
  String category_name;
  // ignore: non_constant_identifier_names
  List<ProductDetails2> productdetails;

  RestaurantProduct();

  RestaurantProduct.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      image = jsonMap['image'];
      productdetails =
          jsonMap['productdetails'] != null ? List.from(jsonMap['productdetails']).map((element) => ProductDetails2.fromJSON(element)).toList() : [];
      category_name = jsonMap['category_name'];
    } catch (e) {
      id = '';
      image = '';
      category_name = '';
      productdetails = [];

      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
