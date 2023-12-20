import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/address.dart';
import '../models/coupon.dart';
import '../models/explore_search.dart';
import '../models/searchisresult.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auto_suggestion.dart';
import 'user_repository.dart';
import '../models/vendor.dart';
import '../models/trending.dart';
import '../helpers/helper.dart';
import '../models/slide.dart';
import '../models/category.dart';

import '../models/mastercategory_model.dart';
ValueNotifier<List<AutoSuggestion>> recentSearch = ValueNotifier<List<AutoSuggestion>>(<AutoSuggestion>[]);
ValueNotifier<List<Address>> catchLocationList = ValueNotifier<List<Address>>(<Address>[]);


Future<Stream<Slide>> getVendorSlides(id) async {
  Uri uri = Helper.getUri('api/shopSetting/banner/$id');

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Slide.fromJSON(data));
  } catch (e) {
    return Stream.value(Slide.fromJSON({}));
  }
}

Future<Stream<Slide>> getSlides(id) async {
  Uri uri = Helper.getUri('api/user/slider/$id');

  Map<String, dynamic> queryParams = {};



  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['zone_id'] = currentUser.value.zoneId;
  uri = uri.replace(queryParameters: queryParams);
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Slide.fromJSON(data));
  } catch (e) {
    return Stream.value(Slide.fromJSON({}));
  }
}

// ignore: missing_return
Future<Stream<Category>> getCategories(shopId) async {
  Uri uri = Helper.getUri('api/categories/$shopId');


  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Category.fromJSON(data));
    // ignore: empty_catches
  } catch (e) {
  }
}

// ignore: missing_return
Future<Stream<CouponModel>> getCoupons(shopId) async {
  Uri uri = Helper.getUri('api/coupons/$shopId');

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => CouponModel.fromJSON(data));
  // ignore: empty_catches
  } catch (e) {
  }
}




// ignore: missing_return
Future<Stream<MasterCategoryModel>> getMasterCategory(type) async {


  DateTime now = DateTime.now();

  Uri uri = Helper.getUri('api/user/mastercategory/$type/${now.hour}');
  Map<String, dynamic> queryParams = {};


  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['zone_id'] = currentUser.value.zoneId;
  uri = uri.replace(queryParameters: queryParams);
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) {
      return MasterCategoryModel.fromJSON(data);
    });
    // ignore: empty_catches
  } catch (e) {
  }
}
// ignore: missing_return
Future<Stream<Trending>> getTrending() async {
  Uri uri = Helper.getUri('api/trends');
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Trending.fromJSON(data));
    // ignore: empty_catches
  } catch (e) {
  }
}





// ignore: missing_return
Future<Stream<Explore>> getExplore() async {
  Uri uri = Helper.getUri('api/explore');

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Explore.fromJSON(data));
    // ignore: empty_catches
  } catch (e) {
  }
}





Future<String> getZoneId() async {
  // ignore: deprecated_member_use
  Uri uri = Helper.getUri('api/user/getZone/');
  Map<String, dynamic> queryParams = {};
  String zone;
  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  uri = uri.replace(queryParameters: queryParams);
  final client = http.Client();
  final response = await client.post(
    uri,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: '',
  );

  //print(json.decode(response.body)['data']);
  if (response.statusCode == 200) {
    zone = json.decode(response.body)['data'];
  } else {
    throw Exception(response.body);
  }

  return zone;
  // return currentUser.value;
}





Future<Stream<Vendor>>getTopVendorList() async {
  Uri uri = Helper.getUri('api/home_settings/topvendor');
  Map<String, dynamic> queryParams = {};



  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['zone_id'] = currentUser.value.zoneId;
  uri = uri.replace(queryParameters: queryParams);

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

    return Stream.value(Vendor.fromJSON({}));
  }
}




Future<Stream<Vendor>>getTopVendorListSearch(searchTxt) async {
  Uri uri = Helper.getUri('api/shopSearch');
  Map<String, dynamic> queryParams = {};



  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['search'] = searchTxt;
  uri = uri.replace(queryParameters: queryParams);

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

    return Stream.value(Vendor.fromJSON({}));
  }
}

// ignore: missing_return
Future<SearchISLResult> getTopVendorItemListSearch(searchTxt) async {

  // ignore: deprecated_member_use
  Uri uri = Helper.getUri('api/user/shopSearch/');
  Map<String, dynamic> queryParams = {};



  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['zone_id'] = currentUser.value.zoneId;
  queryParams['search'] = searchTxt;
  uri = uri.replace(queryParameters: queryParams);
  SearchISLResult res;
  try {
    final client = http.Client();
    final response = await client.post(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(''),
    );
    if (response.statusCode == 200) {

      res = SearchISLResult.fromJSON(json.decode(response.body)['data']);

      // print(res.payment.toMap());
      return res;
    } else {
      throw Exception(response.body);
    }
    // ignore: empty_catches
  } catch(e){
  }
}








void setCatchLocationList() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'catchLocationList', json.encode(catchLocationList.value));
    // ignore: empty_catches
  } catch(e){
  }
}

Future<List<Address>> getCatchLocationList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  catchLocationList.value = List.from(json.decode(prefs.get('catchLocationList'))).map((element) => Address.fromJSON(element)).toList();

  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  catchLocationList.notifyListeners();
  return catchLocationList.value;
}

Future<Stream<ItemDetails>> getSlidingProduct(type) async {

  // ignore: deprecated_member_use
  Uri uri = Helper.getUri('api/user/slidingProducts/$type');
  Map<String, dynamic> queryParams = {};



  queryParams['myLat'] = currentUser.value.latitude.toString();
  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['zone_id'] = currentUser.value.zoneId;
  uri = uri.replace(queryParameters: queryParams);

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => ItemDetails.fromJSON(data));
  } catch (e) {

    return Stream.value(ItemDetails.fromJSON({}));
  }}




void setRecentSearch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('recentSearch', json.encode(recentSearch.value));

}
Future<List<AutoSuggestion>> getRecentSearch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  recentSearch.value = List.from(json.decode(prefs.get('recentSearch'))).map((element) => AutoSuggestion.fromJSON(element)).toList();

  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  recentSearch.notifyListeners();
  return recentSearch.value;
}

