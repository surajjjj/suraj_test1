import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class Tips {
  int amount;
  bool selected = false;
  bool mostTipped = false;


  Tips();

  Tips.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      amount = jsonMap['amount'];
      selected = jsonMap['selected'];
      mostTipped = jsonMap['mostTipped'];
    } catch (e) {
      amount = 0;
      selected = false;
      mostTipped = false;
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
