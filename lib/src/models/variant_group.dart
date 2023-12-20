import 'package:flutter/foundation.dart';
import 'variant.dart';

// ignore: camel_case_types
class variantGroupModel {
  String groupName;
  int step;
  String boxType;
  String relation;
  List<variantModel> variant =  <variantModel>[];


  variantGroupModel();

  variantGroupModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      groupName = jsonMap['groupName'] ?? '';
      boxType = jsonMap['boxType'] ?? '';
      step = jsonMap['step'] ?? '';
      relation = jsonMap['relation'] ?? '';
      variant =
      jsonMap['variant'] != null ? List.from(jsonMap['variant']).map((element) => variantModel.fromJSON(element)).toList() : [];
    } catch (e) {
      groupName = '';
      boxType = '';
      step = 0;
      variant = [];
      if (kDebugMode) {
        print(e);
        print('show error1');
      }

    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["groupName"] = groupName;
    map["boxType"] = boxType;
    map["step"] = step;
    map["relation"] = relation;
    map["variant"] = variant?.map((element) => element.toMap())?.toList();
    return map;
  }

}
