import 'package:flutter/foundation.dart';

import 'address.dart';

class UserLocal {
  String id;
  String name;
  String email;
  String apiToken;
  String phone;
  String about;
  String image;
  String password;
  Address myAddress =  Address();
  // ignore: deprecated_member_use
  List<Address> address = <Address>[];
  // ignore: non_constant_identifier_names
  String selected_address;
  double latitude;
  double longitude;
  bool firstLoad = false;
  int popupLocker = 0;
  List favoriteShop = [];
  String walletAmount;
  String loginVia;
  String zoneId;
  String description;
  String paymentType = 'COD';
  String paymentImage = 'assets/img/cod.png';
  String locationType;
  String filterId;


  // used for indicate if client logged in or not
  bool auth;

//  String role;

  UserLocal();

  UserLocal.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] ?? '';
      email = jsonMap['email'] ?? '';
      phone = jsonMap['phone'];
      auth = jsonMap['auth'];
      apiToken = jsonMap['api_token'];
      password = jsonMap['password'];
      selected_address = jsonMap['selected_address'];
      address = jsonMap['address']
          != null ? List.from(jsonMap['address']).map((element) => Address.fromJSON(element)).toList() : [];

      image = jsonMap['image'];
      latitude = jsonMap['latitude'].toDouble() ?? 0.0;
      longitude = jsonMap['longitude'].toDouble() ?? 0.0;
      favoriteShop = jsonMap['favoriteShop'];
      walletAmount = jsonMap['walletAmount'] ?? '';
      loginVia = jsonMap['loginVia'];
      zoneId = jsonMap['zoneId'];
      description = jsonMap['description'] ?? '';
      myAddress = jsonMap['myAddress'] != null ? Address.fromJSON(jsonMap['myAddress']) : Address.fromJSON({});
    } catch (e) {
      favoriteShop =[];
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["locationType"] = locationType;
    map["api_token"] = apiToken;
    map["favoriteShop"] = favoriteShop;
    map["password"] = password;
    map["selected_address"] = selected_address;
    map["address"] = address.map((element) => element.toMap()).toList();
    map["phone"] = phone;
    map["auth"] = auth;
    map["media"] = image;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["walletAmount"] = walletAmount;
    map["firstLoad"] = firstLoad;
    map["loginVia"] = loginVia;
    map["zoneId"] = zoneId;
    map["paymentType"] = paymentType;
    map["paymentImage"] = paymentImage;
    map["filterId"] = filterId;
    map["myAddress"] = myAddress.toMap();
    return map;
  }

  @override
  String toString() {
    var map = toMap();
    map["auth"] = auth;
    return map.toString();
  }
}
