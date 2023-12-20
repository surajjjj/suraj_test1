import 'package:flutter/foundation.dart';

import 'addon.dart';

import '../helpers/custom_trace.dart';

class AddonGroupCartModel {
  String addonGroupId;
  String groupName;
  List<AddonModel> addonDetails = <AddonModel>[];
  String vendor;
  AddonGroupCartModel();

  AddonGroupCartModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      addonGroupId      = jsonMap['addonGroupId'];
      groupName    = jsonMap['groupName'];
      addonDetails = jsonMap['addonDetails'] != null ? List.from(jsonMap['addonDetails']).map((element) => AddonModel.fromJSON(element)).toList() : [];
      vendor       = jsonMap['vendor'];
    } catch (e) {

      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["addonGroupId"] = addonGroupId;
    map["groupName"] = groupName;
    map["addonDetails"] = addonDetails?.map((element) => element.toMap())?.toList();
    map["vendor"] = vendor;
    return map;
  }


}
