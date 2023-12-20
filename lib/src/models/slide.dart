import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';
import 'vendor.dart';

class Slide {
  String id;
  // ignore: non_constant_identifier_names
  String slider_text;
  // ignore: non_constant_identifier_names
  String redirect_type;
  // ignore: non_constant_identifier_names
  String para;
  String image;
  Vendor  vendorDetails = Vendor();

  Slide();

  Slide.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      slider_text = jsonMap['slider_text'] ?? '';
      redirect_type = jsonMap['redirect_type'] ?? '';
      para = jsonMap['para'] ?? '';
      image = jsonMap['image'];
      vendorDetails = jsonMap['vendorDetails'] != null ? Vendor.fromJSON(jsonMap['vendorDetails']) : Vendor.fromJSON({});
    } catch (e) {
      id = '';
      slider_text = '';
      redirect_type = '';
      para = '';
      image = '';


      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
