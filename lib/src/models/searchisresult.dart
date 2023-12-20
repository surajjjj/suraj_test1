import 'package:flutter/foundation.dart';
import 'vendor.dart';
import 'product_details2.dart';
import '../helpers/custom_trace.dart';

class SearchISResult {
  List<ItemDetails> item;
  List<Vendor> vendor;

  SearchISResult();

  SearchISResult.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      item = jsonMap['item']  != null ? List.from(jsonMap['item']).map((element) => ItemDetails.fromJSON(element)).toList() : [];
      vendor = jsonMap['vendor']  != null ? List.from(jsonMap['vendor']).map((element) => Vendor.fromJSON(element)).toList() : [];

    } catch (e) {

      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}




class ItemDetails {
   ProductDetails2 productList;
   Vendor vendor;
   ItemDetails();

   ItemDetails.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      vendor = jsonMap['vendor'] != null ? Vendor.fromJSON(jsonMap['vendor']) : Vendor.fromJSON({});
      productList =  jsonMap['productList'] != null ? ProductDetails2.fromJSON(jsonMap['productList']) : ProductDetails2.fromJSON({});

    } catch (e) {
      if (kDebugMode) {
        print('page_error$e');
        print(e);
      }
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}


class SearchISLResult {
  List<ItemSearchDetails> item;
  List<Vendor> vendor;

  SearchISLResult();

  SearchISLResult.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      item = jsonMap['item']  != null ? List.from(jsonMap['item']).map((element) => ItemSearchDetails.fromJSON(element)).toList() : [];
      vendor = jsonMap['vendor']  != null ? List.from(jsonMap['vendor']).map((element) => Vendor.fromJSON(element)).toList() : [];

    } catch (e) {

      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}


class ItemSearchDetails {
  Vendor vendor;
  List<ProductDetails2> productAarList;
  ItemSearchDetails();

  ItemSearchDetails.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      vendor = jsonMap['vendor'] != null ? Vendor.fromJSON(jsonMap['vendor']) : Vendor.fromJSON({});
      productAarList =  jsonMap['productAarList'] != null ?  List.from(jsonMap['productAarList']).map((element) => ProductDetails2.fromJSON(element)).toList() : [];

    } catch (e) {
      if (kDebugMode) {
        print('page_error$e');
        print(e);
      }
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}

