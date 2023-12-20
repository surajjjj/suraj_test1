
import 'package:flutter/foundation.dart';

class DropDownModel {
  String id;
  String name;
  bool isSelected;




  // used for indicate if client logged in or not
  bool auth;

//  String role;

  DropDownModel();

  DropDownModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] ?? '';
      name = jsonMap['name'] ?? '';
      isSelected = jsonMap['isSelected'];

    } catch (e) {

      if (kDebugMode) {
        print(e);
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["name"] = name;
    map["isSelected"] = isSelected;




    return map;
  }

  @override
  String toString() {
    var map = toMap();
    map["auth"] = auth;
    return map.toString();
  }
}
