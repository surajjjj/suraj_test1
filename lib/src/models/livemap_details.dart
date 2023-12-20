import 'package:flutter/foundation.dart';

class LiveMapDetailModel {
  String vendorName;
  String vendorId;
  String vendorPhone;
  String driverId;
  String driverName;
  String driverPhone;
  String vendorLogo;
  String driverImage;
  bool deliveryAssigned;
  String deliveryInstruction;


  LiveMapDetailModel();

  LiveMapDetailModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      vendorName = jsonMap['vendorName'].toString()??'';
      vendorId = jsonMap['vendorId'];
      vendorPhone = jsonMap['vendorPhone'];
      driverId = jsonMap['driverId'];
      driverName = jsonMap['driverName']??'';
      driverPhone = jsonMap['driverPhone']??'';
      vendorLogo = jsonMap['vendorLogo']??'';
      driverImage = jsonMap['driverImage']??'';
      deliveryAssigned = jsonMap['deliveryAssigned']??false;
      deliveryInstruction = jsonMap['deliveryInstruction']??'';

    } catch (e) {

      if (kDebugMode) {
        print(e);
      }
    }
  }

  Map<String, dynamic> toJson() => {
    "vendorName": vendorName,
    "vendorId": vendorId,
    "vendorPhone": vendorPhone,
    "driverId": driverId,
    "driverName": driverName,
    "driverPhone": driverPhone,
    "vendorLogo": vendorLogo,
    "driverImage": driverImage,
    "deliveryAssigned": deliveryAssigned,
    "deliveryInstruction": deliveryInstruction,

  };

  Map toMap() {
    var map = <String, dynamic>{};
    map["vendorId"] = vendorId;
    map["vendorName"] = vendorName;
    map["vendorPhone"] = vendorPhone;
    map["driverId"] = driverId;
    map["driverName"] = driverName;
    map["driverPhone"] = driverPhone;
    map["deliveryAssigned"] = deliveryAssigned;
    map["deliveryInstruction"] = deliveryInstruction;

    return map;
  }
}
