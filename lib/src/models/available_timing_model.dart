import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class AvailableTimingModel {
  String fromAvailableTime;
  String toAvailableTime;


  AvailableTimingModel();

  AvailableTimingModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      fromAvailableTime = jsonMap['fromAvailableTime'];
      toAvailableTime = jsonMap['toAvailableTime'];
    } catch (e) {
      fromAvailableTime = '';
      toAvailableTime = '';
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
