import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class AISearch {
  String searchTxt;
  String aiTxt;
  // ignore: non_constant_identifier_names
  String spell_checker;

  AISearch();

  AISearch.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      searchTxt = jsonMap['searchTxt'];
      aiTxt = jsonMap['aiTxt'];
      spell_checker = jsonMap['spell_checker'];
    } catch (e) {
      searchTxt = '';
      aiTxt = '';
      spell_checker = '';
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
