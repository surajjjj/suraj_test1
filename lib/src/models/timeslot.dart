import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class TimeSlot {
  int timeid;
  String fromTime;
  String toTime;
  bool selected;

  TimeSlot();

  TimeSlot.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      timeid = jsonMap['timeid'];
      fromTime = jsonMap['fromTime'];
      toTime = jsonMap['toTime'];
      selected = jsonMap['selected'];
    } catch (e) {
      timeid = 0;
      fromTime = '';
      toTime = '';
      selected = false;
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
