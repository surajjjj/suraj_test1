import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';
import 'available_timing_model.dart';

class DifferentShopTimingModel {
  List<AvailableTimingModel> monDay = <AvailableTimingModel>[];
  List<AvailableTimingModel> tueDay = <AvailableTimingModel>[];
  List<AvailableTimingModel> wedDay = <AvailableTimingModel>[];
  List<AvailableTimingModel> thurDay = <AvailableTimingModel>[];
  List<AvailableTimingModel> friDay = <AvailableTimingModel>[];
  List<AvailableTimingModel> satDay = <AvailableTimingModel>[];
  List<AvailableTimingModel> sunDay = <AvailableTimingModel>[];

  DifferentShopTimingModel();

  DifferentShopTimingModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      monDay = jsonMap['monDay'] != null ? List.from(jsonMap['monDay']).map((element) => AvailableTimingModel.fromJSON(element)).toList() : [];
      tueDay = jsonMap['tueDay'] != null ? List.from(jsonMap['tueDay']).map((element) => AvailableTimingModel.fromJSON(element)).toList() : [];
      wedDay = jsonMap['wedDay'] != null ? List.from(jsonMap['wedDay']).map((element) => AvailableTimingModel.fromJSON(element)).toList() : [];
      thurDay = jsonMap['thurDay'] != null ? List.from(jsonMap['thurDay']).map((element) => AvailableTimingModel.fromJSON(element)).toList() : [];
      friDay = jsonMap['friDay'] != null ? List.from(jsonMap['friDay']).map((element) => AvailableTimingModel.fromJSON(element)).toList() : [];
      satDay = jsonMap['satDay'] != null ? List.from(jsonMap['satDay']).map((element) => AvailableTimingModel.fromJSON(element)).toList() : [];
      sunDay = jsonMap['sunDay'] != null ? List.from(jsonMap['sunDay']).map((element) => AvailableTimingModel.fromJSON(element)).toList() : [];

    } catch (e) {
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
