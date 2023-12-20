
import 'package:flutter/foundation.dart';

import 'addongroup_model.dart';
import 'combination_variant.dart';
import 'shop_timing_model.dart';
import '../helpers/custom_trace.dart';
import 'variant_group.dart';


class CartResponse {

  String productId;
  // ignore: non_constant_identifier_names
  String product_name;
  String price;
  String strike;
  String shopId;
  String image;
  double tax;
  String discount;
  double packingCharge = 0;
  bool multipleVariant;
  int qty;
  int variantId;
  String variantName;
  List<variantGroupModel> variantGroup =  <variantGroupModel>[];
  List<CombinationVariantModel> combinationVariant =  <CombinationVariantModel>[];
  List<CombinationVariantModel> combinationAllVariant =  <CombinationVariantModel>[];
  List<AddonGroupModel> addonGroup =  <AddonGroupModel>[];
  String foodType;
  String userId;
  String cartId;
  int totalSteps;
  String defaultVariant;
  String availableType;
  ShopTimingModel itemTiming =  ShopTimingModel();
  CartResponse();

  CartResponse.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      productId = jsonMap['productId'].toString();
      product_name = jsonMap['product_name'] ?? '';
      price = jsonMap['price'] ?? '';
      strike = jsonMap['strike'] ?? 0;
      qty = jsonMap['qty'] ?? 0;
      variantName =   jsonMap['variantName'] ?? '';
      variantGroup = jsonMap['variantGroup'] != null ? List.from(jsonMap['variantGroup']).map((element) => variantGroupModel.fromJSON(element)).toList() : [];
      addonGroup = jsonMap['addonGroup'] != null ? List.from(jsonMap['addonGroup']).map((element) => AddonGroupModel.fromJSON(element)).toList() : [];
      combinationVariant = jsonMap['combinationVariant'] != null ? List.from(jsonMap['combinationVariant']).map((element) => CombinationVariantModel.fromJSON(element)).toList() : [];
      combinationAllVariant = jsonMap['combinationAllVariant'] != null ? List.from(jsonMap['combinationAllVariant']).map((element) => CombinationVariantModel.fromJSON(element)).toList() : [];
      userId = jsonMap['userId'] ?? '';
      cartId = jsonMap['cartId'] ?? '';
      shopId = jsonMap['shopId'] ?? '';
      image = jsonMap['image'] ?? '';
      tax =  jsonMap['tax'].toDouble() ?? 0.0;
      discount = jsonMap['discount'] ?? '';
      foodType = jsonMap['foodType']??'Veg';
      packingCharge= jsonMap['packingCharge'].toDouble() ?? 0;
      multipleVariant = jsonMap['multipleVariant'] ?? false;
      totalSteps = jsonMap['totalSteps'] ?? '';
      availableType = jsonMap['availableType'] ?? '';
    } catch (e) {
      productId = '';
      product_name = '';
      price = '';
      strike = '';
      qty = 1;
      userId = '';
      cartId = '';
      shopId = '';
      image = '';
      discount = '';
      tax = 1;
      packingCharge = 0;


      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "product_name": product_name,
    "price": price,
    "strike": strike,
    "qty": qty,
    "userId": userId,
    "cartId": cartId,
    "shopId": shopId,
    "image": image,
    "tax": tax,
    "discount": discount,
    "packingCharge": packingCharge,
    "variantName": variantName,
    "multipleVariant": multipleVariant,
    "variantId": variantId,
    "foodType": foodType,
    "totalSteps": totalSteps,
    "variantGroup": variantGroup?.map((element) => element.toMap())?.toList(),
    "addonGroup": addonGroup?.map((element) => element.toMap())?.toList(),
    'combinationVariant': combinationVariant?.map((element) => element.toMap())?.toList(),
    'combinationAllVariant': combinationAllVariant?.map((element) => element.toMap())?.toList(),
  };

  Map toMap() {
    var map = <String, dynamic>{};
    map["productId"] = productId;
    map["product_name"] = product_name;
    map["price"] = price;
    map["strike"] = strike;
    map["qty"] = qty;
    map["userId"] = userId;
    map["cartId"] = cartId;
    map["shopId"] = shopId;
    map["image"] = image;
    map["tax"] = tax;
    map["discount"] = discount;
    map["packingCharge"] = packingCharge;
    map["totalSteps"] = totalSteps;
    map["multipleVariant"] = multipleVariant;
    map["variantId"] = variantId;
    map["variantName"] = variantName;
    map["foodType"] = foodType;
    map["addonGroup"] = addonGroup?.map((element) => element.toMap())?.toList();
    map["variantGroup"] = variantGroup?.map((element) => element.toMap())?.toList();
    map["combinationVariant"] = combinationVariant?.map((element) => element.toMap())?.toList();
    map["combinationAllVariant"] = combinationAllVariant?.map((element) => element.toMap())?.toList();
    return map;
  }
}
