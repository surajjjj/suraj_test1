import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../models/mastercategory_model.dart';
import '../models/takeaway.dart';
import '../models/user.dart';
import '../models/vendor.dart';
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../repository/user_repository.dart';


Future<Stream<Vendor>> getNearMarkets(Address myLocation, Address areaLocation, id) async {
  Uri uri = Helper.getUri('api/home_settings/topvendor/$id');
  Map<String, dynamic> queryParams = {};

  queryParams['myLon'] = currentUser.value.longitude.toString();
  queryParams['myLat'] =  currentUser.value.latitude.toString();
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

    if (kDebugMode) {
      print(e);
    }

    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(Vendor.fromJSON({}));
  }
}

Future<TakeawayModel> getTakeawayDetail(String id) async {
  UserLocal user =currentUser.value;
  final String apiToken = 'api_token=${user.apiToken}';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/takeaway/list/$id?$apiToken';
  if (kDebugMode) {
    print(url);
  }
  final client = http.Client();
  final response = await client.put(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(''),
  );

  if (response.statusCode == 200) {
    return TakeawayModel.fromJSON(json.decode(response.body)['data']);
  } else {

    throw Exception(response.body);
  }
}



Future<Stream<MasterCategoryModel>> getShopType() async {

  Uri uri = Helper.getUri('api/home_settings/shoptype');


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

}


