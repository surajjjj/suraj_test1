import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class Address {
  String id;
  String addressSelect;
  double latitude= 0.0;
  double longitude = 0.0;
  String isDefault;
  String username;
  String phone;
  String userId;
  String flatNo;
  String area;
  String directionsToReach;
  String addressType;
  bool selected;

  Address();

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      addressSelect = jsonMap['addressSelect'] ?? '';
      latitude = jsonMap['latitude'].toDouble() ?? 0.0;
      longitude = jsonMap['longitude'].toDouble() ?? 0.0;
      isDefault = jsonMap['is_default']!= null ? jsonMap['isDefault'] : '';
      username = jsonMap['username'] ?? '';
      phone = jsonMap['phone'] ?? '';
      userId = jsonMap['userId'] ?? '';
      flatNo = jsonMap['flatNo'] ?? '';
      area = jsonMap['area'] ?? '';
      directionsToReach = jsonMap['directionsToReach'] ?? '';
      addressType = jsonMap['addressType'] ?? '';
      selected = jsonMap['selected'] ?? false;
    } catch (e) {
      id = '';
      addressSelect = '';
      latitude = 0.0;
      longitude = 0.0;
      isDefault = '';
      username = '';
      phone = '';
      userId = '';
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "addressSelect": addressSelect,
    "latitude": latitude,
    "longitude": longitude,
    "isDefault": isDefault,
    "username": username,
    "phone": phone,
    "userId": userId,
    "flatNo": flatNo,
    "directionsToReach": directionsToReach,
    "addressType": addressType,
    "selected": selected,
  };

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["addressSelect"] = addressSelect;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["isDefault"] = isDefault;
    map["username"] = username;
    map["phone"] = phone;
    map["userId"] = userId;
    map["flatNo"] = flatNo;
    map["addressType"] = addressType;
    map["directionsToReach"] = directionsToReach;
    map["selected"] = selected;
    return map;
  }
}
