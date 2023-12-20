import 'package:flutter/foundation.dart';

import 'mastercategory_model.dart';

import '../helpers/custom_trace.dart';

class Explore {
  String id;
  String title;
  // ignore: non_constant_identifier_names
  // ignore: deprecated_member_use
  List<MasterCategoryModel> focusType = <MasterCategoryModel>[];

  Explore.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'];
      title = jsonMap['title'];
      focusType = jsonMap['focusType']
          != null ? List.from(jsonMap['focusType']).map((element) => MasterCategoryModel.fromJSON(element)).toList() : [];
    } catch (e) {
      id = '';
      title = '';
      focusType = [];
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
