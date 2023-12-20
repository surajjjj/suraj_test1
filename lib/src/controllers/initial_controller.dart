import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/settings_repository.dart';
import '../models/tips.dart';
import '../models/logistics_pricing.dart';

class InitialController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Tips> tipsList = <Tips>[];
  List<LogisticsPricing> logisticsPriceList = <LogisticsPricing>[];
  InitialController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
  }


  listenForTips() async {
    currentTips.value.clear();
    final Stream<Tips> stream = await getTips();
    stream.listen((Tips tips) {
      setState(() => tipsList.add(tips));
    }, onError: (a) {

    }, onDone: () {
      currentTips.value.addAll(tipsList);
    });
  }

  listenForLogisticsPricing() async {
    final Stream<LogisticsPricing> stream = await getLogisticsPricing();
    stream.listen((LogisticsPricing list) {
      setState(() => logisticsPriceList.add(list));

    }, onError: (a) {

    }, onDone: () {

      currentLogisticsPricing.value.addAll(logisticsPriceList);

    });
  }
}
