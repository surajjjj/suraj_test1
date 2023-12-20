import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../helpers/helper.dart';
import '../models/registermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

ValueNotifier<UserLocal> currentUser = ValueNotifier(UserLocal());






Future<void> logout() async {
  currentUser.value = UserLocal();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_user');
}

Future<bool> register(RegisterModel user) async {

  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/registerUpdate';

  bool res;
  final client = http.Client();
  final response = await client.post(
      Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );

  if (response.statusCode == 200) {
    // setCurrentUser(response.body);
    // currentUser.value = User.fromJSON(json.decode(response.body)['data']);
    if (kDebugMode) {
      print(json.decode(response.body)['data']);
    }
    if (json.decode(response.body)['data'] == 'success') {
      res = true;
    } else {
      res = false;
    }
  } else {
    throw Exception(response.body);
  }
  return res;
}

void setCurrentUser(jsonString) async {
  if (json.decode(jsonString)['data'] != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(json.decode(jsonString)['data']));
  }
}

void setCurrentUserUpdate(UserLocal jsonString) async {

  try {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user', json.encode(jsonString.toMap()));
    update(jsonString);
  } catch (e){
     if (kDebugMode) {
       print('store error $e');
     }
  }
}

Future<UserLocal> getCurrentUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.clear();
  if (currentUser.value.auth == null && prefs.containsKey('current_user')) {
    currentUser.value = UserLocal.fromJSON(json.decode(prefs.get('current_user')));
    currentUser.value.auth = true;
  } else {
    currentUser.value.auth = false;
  }
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentUser.notifyListeners();
  return currentUser.value;
}

Future<UserLocal> update(UserLocal user) async {
  final String apiToken = 'api_token=${currentUser.value.apiToken}';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/profileupdate/${currentUser.value.id}?$apiToken';
  if (kDebugMode) {
    print(url);
  }
  final client = http.Client();
   await client.post(
      Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );
  //setCurrentUser(response.body);
  //currentUser.value = User.fromJSON(json.decode(response.body)['data']);
  return currentUser.value;
}

Future<UserLocal> smartLogin(RegisterModel user) async {
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('base_url')}api/user/smartLogin';



        if (kDebugMode) {
          print(user.toMap());
        }


  final client = http.Client();
  final response = await client.post(
    Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(user.toMap()),
  );



  if (response.statusCode == 200) {
    setCurrentUser(response.body);
    currentUser.value = UserLocal.fromJSON(json.decode(response.body)['data']);


  } else {
    throw Exception(response.body);
  }
  return  currentUser.value;
}

Future<bool> checkValue(table,col,para) async {
  // ignore: deprecated_member_use, prefer_interpolation_to_compose_strings
  Uri uri = Helper.getUri('api/checkValue/$table/'+ col);
  Map<String, dynamic> queryParams = {};
  bool  zone;
  queryParams['para'] = para;

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