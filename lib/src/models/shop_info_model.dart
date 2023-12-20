import 'package:flutter/foundation.dart';
import 'searchisresult.dart';
import 'shop_rating.dart';



class ShopInfoModel {

  List<ShopRatingModel> recentReview =  <ShopRatingModel>[];
  List<ItemDetails> itemData =  <ItemDetails>[];


  ShopInfoModel();

  ShopInfoModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {

      recentReview = jsonMap['recentReview'] != null ? List.from(jsonMap['recentReview']).map((element) => ShopRatingModel.fromJSON(element)).toList() : [];
      itemData = jsonMap['itemData'] != null ? List.from(jsonMap['itemData']).map((element) => ItemDetails.fromJSON(element)).toList() : [];


    } catch (e) {


      //addon = [];

      if (kDebugMode) {
        print('error on product');
        print(e.obs);
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};



    return map;
  }
}
