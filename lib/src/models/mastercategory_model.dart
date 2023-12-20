import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class MasterCategoryModel {
  String title;
  String previewImage;
  String coverImage;
  String id;
  bool subCategoryView;

  MasterCategoryModel();

  MasterCategoryModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'] ?? 0.0;
      title = jsonMap['title'] ?? 0.0;
      previewImage = jsonMap['previewImage'] ?? '';
      coverImage = jsonMap['coverImage'] ?? '';
      subCategoryView = jsonMap['subCategoryView'] ?? false;
    } catch (e) {
      id ='';
      previewImage = '';
      coverImage = '';
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
    map["coverImage"] = coverImage;
    map["subCategoryView"] = subCategoryView;
    return map;
  }
}
