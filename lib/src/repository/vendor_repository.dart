import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:foodzo/src/models/shop_info_model.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../models/product_details2.dart';
import '../models/user.dart';
import '../models/mastersubcategory_model.dart';
import '../models/restaurant_product.dart';
import '../models/vendor.dart';
import 'user_repository.dart';
import '../helpers/helper.dart';
import 'dart:convert';
import '../helpers/custom_trace.dart';

ValueNotifier<Vendor> currentVendor = ValueNotifier(Vendor());
ValueNotifier<Vendor> catchVendor = ValueNotifier(Vendor());
Future<Stream<Vendor>> getVendorList(type,select, limit) async {
  Uri uri = Helper.getUri('api/user/shoplist/$type/$select/$limit');
  Map<String, dynamic> queryParams = {};


  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['zone_id'] = currentUser.value.zoneId;
  uri = uri.replace(queryParameters: queryParams);
  if (kDebugMode) {
    print(uri);
  }
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Vendor.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(Vendor.fromJSON({}));
  }
}






Future<Stream<Vendor>> getVendorListOffer(shopType,  offer, offerType, shopTypeId) async {
  Uri uri = Helper.getUri('api/shoplistOffer/$shopType/$offer/$offerType/$shopTypeId');
  Map<String, dynamic> queryParams = {};


  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['zone_id'] = currentUser.value.zoneId;
  uri = uri.replace(queryParameters: queryParams);
if (kDebugMode) {
  print(uri);
}
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Vendor.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(Vendor.fromJSON({}));
  }
}

// ignore: non_constant_identifier_names
Future<Stream<RestaurantProduct>> get_restaurantProduct(id) async {
  Uri uri = Helper.getUri('api/user/category_wise_productList/$id');
   if (kDebugMode) {
     print(uri);
   }
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => RestaurantProduct.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(RestaurantProduct.fromJSON({}));
  }
}



Future<bool> addFavoriteShop() async {
  UserLocal user = currentUser.value;
  if (user.apiToken == null) {
    return false;
  }
  final String apiToken = 'api_token=${user.apiToken}';

  final String url = '${GlobalConfiguration().getValue('base_url')}api/user/favoriteShop/do_add/${currentUser.value.id}/?$apiToken';
   if (kDebugMode) {
     print(url);
   }
  try {
    final client = http.Client();
    await client.post(
      Uri.parse(url),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(user.toMap()),
    );
    return true;
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: url).toString());
    }
    return false;
  }
}

Future<Stream<Vendor>> getFavoritesShop() async {
  UserLocal user = currentUser.value;
  if (user.apiToken == null) {
    return Stream.value(null);
  }


  Uri uri = Helper.getUri('api/favoriteShop/list/${currentUser.value.id}');
  Map<String, dynamic> queryParams = {};



  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['api_token'] = user.apiToken;
  uri = uri.replace(queryParameters: queryParams);

  final client = http.Client();
  final streamedRest = await client.send(http.Request('get', uri));
  try {
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Vendor.fromJSON(data));
  } catch (e) {
    //print(CustomTrace(StackTrace.current, message: uri).toString());
    return Stream.value(Vendor.fromJSON({}));
  }
}



Future<Stream<ProductDetails2>> getShopProductSlide(id) async {


  final String apiToken = 'api_token=${currentUser.value.apiToken}&';
  final String url = '${GlobalConfiguration().getValue('api_base_url')}api/shopSetting/productList/$id/${currentUser.value.id}?$apiToken';

  final client = http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  try {
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => ProductDetails2.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: url).toString());
    }
    return Stream.value(ProductDetails2.fromJSON({}));
  }
}

// ignore: missing_return
Future<Stream<MasterSubCategoryModel>> getMasterSubCategory(type) async {




  Uri uri = Helper.getUri('api/user/mastersubcategory/$type');
  Map<String, dynamic> queryParams = {};


  queryParams['zone_id'] = currentUser.value.zoneId;
  uri = uri.replace(queryParameters: queryParams);
  if (kDebugMode) {
    print(uri);
  }
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return MasterSubCategoryModel.fromJSON(data);
    });
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
  }
}

// ignore: missing_return
Future<ShopInfoModel> getShopInfo(id) async {

  // ignore: deprecated_member_use
  Uri uri = Helper.getUri('api/user/shopFullDetail/$id');
  Map<String, dynamic> queryParams = {};
  ShopInfoModel res;
  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['zone_id'] = currentUser.value.zoneId;
  uri = uri.replace(queryParameters: queryParams);
   if (kDebugMode) {
     print(uri);
   }
  try {
    final client = http.Client();
    final response = await client.post(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(''),
    );
    if (response.statusCode == 200) {
      res = ShopInfoModel.fromJSON(json.decode(response.body)['data']);
      return res;
    } else {
      throw Exception(response.body);
    }
  } catch(e){
    if (kDebugMode) {
      print(e);
    }
  }
}