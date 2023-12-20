import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class VariantData {
  String id;
  // ignore: non_constant_identifier_names
  String variant_name;
  bool selected;

  VariantData();

  VariantData.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      variant_name = jsonMap['variant_name'];
      selected = jsonMap['selected'];
    } catch (e) {
      id = '';
      variant_name = '';
      selected = false;
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
