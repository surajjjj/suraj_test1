import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/policy.dart';
import '../models/slide.dart';
import 'user_repository.dart';
import '../helpers/helper.dart';
import '../models/logistics_pricing.dart';
import '../helpers/custom_trace.dart';
import '../models/setting.dart';
import '../models/tips.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';

ValueNotifier<Setting> setting = ValueNotifier(Setting());
ValueNotifier<List<Tips>> currentTips = ValueNotifier<List<Tips>>(<Tips>[]);
ValueNotifier<List<LogisticsPricing>> currentLogisticsPricing = ValueNotifier<List<LogisticsPricing>>(<LogisticsPricing>[]);
final navigatorKey = GlobalKey<NavigatorState>();
Future<Stream<PolicyModel>> getPolicydata(id) async {
  Uri uri = Helper.getUri('api/user/policy/$id');
  Map<String, dynamic> queryParams = {};

  queryParams['api_token'] = currentUser.value.apiToken;
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
        .map((data) => PolicyModel.fromJson(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(PolicyModel.fromJson({}));
  }
}
Future<Setting> initSettings() async {
  Setting settingKey;
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/setting';

  try {
    final response = await http.get(Uri.parse(url), headers: {HttpHeaders.contentTypeHeader: 'application/json'});

    if (response.statusCode == 200 ) {
      if (json.decode(response.body)['data'] != null) {
        if (kDebugMode) {
          print(json.decode(response.body)['data']);
        }
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('settings', json.encode(json.decode(response.body)['data']));
        settingKey = Setting.fromJSON(json.decode(response.body)['data']);


        settingKey.brightness.value = prefs.getBool('isDark') ?? false ? Brightness.dark : Brightness.light;
        setting.value = settingKey;
        if (prefs.containsKey('language')) {
          settingKey.mobileLanguage.value = Locale(prefs.get('language'), '');
        }

        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        setting.notifyListeners();
      }
    } else {
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: response.body).toString());
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: url).toString());
    }
    return Setting.fromJSON({});
  }
  return setting.value;
}

Future<void> setDefaultLanguage(String language) async {
  if (language != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}


Future<String> getDefaultLanguage(String defaultLanguage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('language')) {
    defaultLanguage = prefs.get('language');
  }
  return defaultLanguage;
}

// ignore: missing_return
Future<Stream<Tips>> getTips() async {
  Uri uri = Helper.getUri('api/user/tips');

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Tips.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
  }
}



// ignore: missing_return
Future<Stream<LogisticsPricing>> getLogisticsPricing() async {
  Uri uri = Helper.getUri('api/user/logistics_pricing/get');
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
        .map((data) => LogisticsPricing.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
  }


}

Future<Stream<Slide>> getSlides(id) async {
  Uri uri = Helper.getUri('api/slider/$id');

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
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(Slide.fromJSON({}));
  }
}