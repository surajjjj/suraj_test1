import 'package:flutter/foundation.dart';

import '../models/shop_rating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../helpers/helper.dart';
import 'dart:convert';
import '../helpers/custom_trace.dart';
import '../models/auto_suggestion.dart';

void setRecentSearch(search) async {
  if (search != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('recent_search', search);
  }
}

Future<String> getRecentSearch() async {
  String search = "";

  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('recent_search')) {
    search = prefs.get('recent_search').toString();
  }
  return search;
}
Future<Stream<ShopRatingModel>> getShopReviewlist(id) async {
  Uri uri = Helper.getUri('api/user/shopreview/list/$id');
if (kDebugMode) {
  print(uri);
}
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) =>  Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => ShopRatingModel.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(ShopRatingModel.fromJSON({}));
  }
}
Future<Stream<AutoSuggestion>> getAutosuggestion(String searchText) async {
  Uri uri = Helper.getUri('api/auto_suggestion/');
  Map<String, dynamic> queryParams = {};
  queryParams['search'] = searchText;
  uri = uri.replace(queryParameters: queryParams);
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => AutoSuggestion.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(AutoSuggestion.fromJSON({}));
  }
}
