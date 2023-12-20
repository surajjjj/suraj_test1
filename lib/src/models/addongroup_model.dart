import 'package:flutter/foundation.dart';
import 'addon.dart';

import '../helpers/custom_trace.dart';

class AddonGroupModel {

  String name;

  List<AddonModel> addon = <AddonModel>[];
  String vendor;
  AddonGroupModel();

  AddonGroupModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      name    = jsonMap['name']??'';
      addon = jsonMap['addon'] != null ? List.from(jsonMap['addon']).map((element) => AddonModel.fromJSON(element)).toList() : [];

      vendor       = jsonMap['vendor']??'';
    } catch (e) {

      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["addon"] = addon?.map((element) => element.toMap())?.toList();

    map["vendor"] = vendor;
    return map;
  }

}
