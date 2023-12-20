import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class MasterSubCategoryModel {
  String title;
  String previewImage;
  String id;
  bool subCategoryView;

  MasterSubCategoryModel();

  MasterSubCategoryModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] ?? '';
      title = jsonMap['title'] ?? '';
      previewImage = jsonMap['previewImage'] ?? '';
      subCategoryView = jsonMap['subCategoryView'] ?? false;
    } catch (e) {
      id ='';
      previewImage = '';
      title = '';
      subCategoryView = false;

      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }

    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["title"] = title;
    map["previewImage"] = previewImage;
    map["subCategoryView"] = subCategoryView;
    return map;
  }
}
