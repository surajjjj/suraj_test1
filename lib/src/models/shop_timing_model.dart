
import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';
import 'available_timing_model.dart';
import 'different_shop_timing_model.dart';

class ShopTimingModel {
  String availableType;
  AvailableTimingModel allTimes = AvailableTimingModel();
  List<AvailableTimingModel> sameTime = <AvailableTimingModel>[];
  DifferentShopTimingModel differentTime = DifferentShopTimingModel();

  ShopTimingModel();

  ShopTimingModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      availableType = jsonMap['availableType'] ?? '';
      allTimes = jsonMap['allTimes'] != null ? AvailableTimingModel.fromJSON(jsonMap['allTimes']) : AvailableTimingModel.fromJSON({});
      sameTime = jsonMap['sameTime'] != null ? List.from(jsonMap['sameTime']).map((element) => AvailableTimingModel.fromJSON(element)).toList() : [];
      differentTime = jsonMap['differentTime'] != null ? DifferentShopTimingModel.fromJSON(jsonMap['differentTime']) : DifferentShopTimingModel.fromJSON({});
    } catch (e) {

      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
