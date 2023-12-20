import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class AutoSuggestion {
  String text;

  AutoSuggestion();

  AutoSuggestion.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      text = jsonMap['text'];
    } catch (e) {
      text = '';
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
