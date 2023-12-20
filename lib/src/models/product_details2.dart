import 'package:flutter/foundation.dart';
import 'combination_variant.dart';
import 'shop_timing_model.dart';
import 'variant_group.dart';
import 'addongroup_model.dart';


class ProductDetails2 {
  String id;
  // ignore: non_constant_identifier_names
  String product_name;
  String rating;
  String ratingTotal;
  bool multipleVariant;
  String image;
  List<variantGroupModel> variantGroup =  <variantGroupModel>[];
  List<CombinationVariantModel> combinationVariant =  <CombinationVariantModel>[];
  List<AddonGroupModel> addonGroup =  <AddonGroupModel>[];
  String foodType;
  String description;
  String price;
  String strike;
  String discount;
  String packingCharge;
  String tax;
  int qty = 1;
  String availableType;
  int totalSteps;
  String defaultVariant;
  bool outOfStock;
  ShopTimingModel itemTiming =  ShopTimingModel();
  ProductDetails2();

  ProductDetails2.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      product_name = jsonMap['product_name'];
      image = jsonMap['image'];
      rating = jsonMap['rating']??'0';
      multipleVariant = jsonMap['multipleVariant'] ?? false;
      outOfStock = jsonMap['outOfStock'] ?? false;
      ratingTotal = jsonMap['ratingTotal']??'0';
      variantGroup = jsonMap['variantGroup'] != null ? List.from(jsonMap['variantGroup']).map((element) => variantGroupModel.fromJSON(element)).toList() : [];
      addonGroup = jsonMap['addonGroup'] != null ? List.from(jsonMap['addonGroup']).map((element) => AddonGroupModel.fromJSON(element)).toList() : [];
      combinationVariant = jsonMap['combinationVariant'] != null ? List.from(jsonMap['combinationVariant']).map((element) => CombinationVariantModel.fromJSON(element)).toList() : [];
      foodType = jsonMap['foodType']??'Veg';
      description = jsonMap['description'] ?? '';
      price = jsonMap['price'] ?? '';
      strike = jsonMap['strike'] ?? '';
      discount = jsonMap['discount'] ?? '';
      packingCharge = jsonMap['packingCharge'] ?? '';
      tax = jsonMap['tax'] ?? '';
      availableType = jsonMap['availableType']??'0';
      totalSteps = jsonMap['totalSteps']??'0';
      defaultVariant = jsonMap['defaultVariant']??'';
      itemTiming = jsonMap['itemTiming'] != null ? ShopTimingModel.fromJSON(jsonMap['itemTiming']) : ShopTimingModel.fromJSON({});
    } catch (e) {
      id = '';
      product_name = '';

      rating = '';
      image = '';

      //addon = [];

      if (kDebugMode) {
        print('error on product');
        print(e.obs);
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["product_name"] = product_name;
    map["rating"] = rating;
    map["image"] = image;


    return map;
  }
}
