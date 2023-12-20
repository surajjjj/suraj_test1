import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../helpers/custom_trace.dart';

class Setting {
  String appName = '';
  // ignore: non_constant_identifier_names
  int minimum_purchase;
  String defaultCurrency;
  String distanceUnit;
  bool currencyRight = false;
  int currencyDecimalDigits = 2;
  // ignore: non_constant_identifier_names
  String razorpay_key;
  String googleMapsKey;
  ValueNotifier<Locale> mobileLanguage = ValueNotifier(const Locale('en', ''));
  String appVersion;
  bool enableVersion = true;
  bool rayzorPay = true;
  bool upi = true;
  bool paypal = true;
  bool stripe = true;
  bool flutterWave = true;
  bool mpesa = false;
  bool codMode = true;
  String mpesaConsumerKey;
  String mpesaConsumerSecret;
  String mpesaPasskey;
  bool instanceDelivery;
  bool deliveryTips;
  // ignore: non_constant_identifier_names
  int cancel_timer = 6;
  double coverDistance;
  String noticeboard;
  String dailCode;
  String isoCode;
  String upiKey;
  String customerSupport;
  ValueNotifier<Brightness> brightness = ValueNotifier(Brightness.light);
  String version = '1.0.0';
  String appLink;
  bool payStack = false;
  String fixedBanner;
  String paymentBanner;
  String fbRdLink;
  String fbPara;
  String featuredText;
  String featuredBgColor;
  String featuredTextColor;
  bool scheduleCancellation;
  String scheduleCancellationTimeLimit = '0';
  bool takeawayCancellation;
  String takeawayCancellationTimeLimit = '0';
  bool customHeader = false;
  String headerColor;
  String headerBgImage;
  String loginText;
  String categoryTitle;

  Setting();

  Setting.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      appName = jsonMap['app_name'];
      googleMapsKey = jsonMap['google_maps_key'];
      mobileLanguage.value = Locale(jsonMap['mobile_language'] ?? "en", '');
      appVersion = jsonMap['app_version'] ?? '';
      noticeboard = jsonMap['noticeboard'] ?? '';
      distanceUnit = jsonMap['distance_unit'] ?? 'km';
      enableVersion = jsonMap['enable_version'] == null || jsonMap['enable_version'] == '0' ? false : true;
      coverDistance = jsonMap['coverDistance'].toDouble() ?? 0;
      instanceDelivery = jsonMap['instanceDelivery'];
      deliveryTips = jsonMap['deliveryTips'];
      minimum_purchase = int.tryParse(jsonMap['minimum_purchase'] ?? '0') ?? 0.0; //double.parse(jsonMap['default_tax'].toString());
      defaultCurrency = jsonMap['default_currency'] ?? '';
      currencyDecimalDigits = int.tryParse(jsonMap['default_currency_decimal_digits'] ?? '2') ?? 2;
      cancel_timer = int.tryParse(jsonMap['cancel_timer'] ?? '2') ?? 2;
      currencyRight = jsonMap['currency_right'] ?? false;
      customHeader = jsonMap['customHeader'] ?? false;
      fbRdLink = jsonMap['fbRdLink'] ?? '';
      fbPara = jsonMap['fbPara'] ?? '';
      headerColor = jsonMap['headerColor'] ?? '';
      headerBgImage = jsonMap['headerBgImage'] ?? '';
      featuredBgColor = jsonMap['featuredBgColor'] ?? '';
      featuredTextColor = jsonMap['featuredTextColor'] ?? '';
      rayzorPay = jsonMap['rayzorPay'] == null || jsonMap['rayzorPay'] == false ? false : true;
      upi = jsonMap['upi'] == null || jsonMap['upi'] == false ? false : true;
      paypal = jsonMap['paypal'] == null || jsonMap['paypal'] == false ? false : true;
      stripe = jsonMap['stripe'] == null || jsonMap['stripe'] == false ? false : true;
      flutterWave = jsonMap['flutterWave'] == null || jsonMap['flutterWave'] == false ? false : true;
      razorpay_key = jsonMap['razorpay_key'];
      dailCode = jsonMap['dailCode'] ?? '';
      fixedBanner = jsonMap['fixedBanner'] ?? '';
      paymentBanner = jsonMap['paymentBanner'] ?? '';
      customerSupport = jsonMap['customerSupport'] ?? '';
      isoCode = jsonMap['isoCode'] ?? '';
      upiKey = jsonMap['upiKey'] ?? '';
      appLink = jsonMap['appLink'] ?? '';
      mpesaConsumerKey = jsonMap['mpesaConsumerKey'] ?? '';
      mpesaConsumerSecret = jsonMap['mpesaConsumerSecret'] ?? '';
      mpesaPasskey = jsonMap['mpesaPasskey'] ?? '';
      mpesa = jsonMap['mpesa'] == null || jsonMap['mpesa'] == false ? false : true;
      payStack = jsonMap['payStack'] == null || jsonMap['payStack'] == false ? false : true;
      codMode = jsonMap['codMode'] == null || jsonMap['codMode'] == false ? false : true;
      featuredText = jsonMap['featuredText'] ?? '';
      loginText = jsonMap['loginText'] ?? '';
      categoryTitle = jsonMap['categoryTitle'] ?? '';
      scheduleCancellation = jsonMap['scheduleCancellation'] ?? false;
      scheduleCancellationTimeLimit = jsonMap['scheduleCancellationTimeLimit'] ?? false;
      takeawayCancellation = jsonMap['takeawayCancellation'] ?? false;
      takeawayCancellationTimeLimit = jsonMap['takeawayCancellationTimeLimit'] ?? false;
    } catch (e) {
      razorpay_key = '';

      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["app_name"] = appName;
    map["minimum_purchase"] = minimum_purchase;
    map["instanceDelivery"] = instanceDelivery;
    map["default_currency"] = defaultCurrency;
    map["default_currency_decimal_digits"] = currencyDecimalDigits;
    map["currency_right"] = currencyRight;
    map["razorpay_key"] = razorpay_key;
    map["mobile_language"] = mobileLanguage.value.languageCode;
    map["deliveryTips"] = deliveryTips;
    map["coverDistance"] = coverDistance;
    return map;
  }
}
