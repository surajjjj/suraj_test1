import 'dart:async';
// ignore: library_prefixes
import 'dart:math' as Math;
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/Shimmer/circular_loading_widget.dart';
import '../models/product_details2.dart';
import '../models/vendor.dart';
import '../repository/order_repository.dart';
import '../repository/settings_repository.dart';

class Helper {
  BuildContext context1;
  DateTime currentBackPressTime;

  Helper.of(BuildContext context) {
    context1 = context;
  }

  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {

    return data['data'] ?? [];
  }



  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int) ?? 0;
  }

  static bool getBoolData(Map<String, dynamic> data) {
    return (data['data'] as bool) ?? false;
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? <String, dynamic>{};
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: const Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: const Color(0xFFFFB24D)));
    }
    list.addAll(List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: const Color(0xFFFFB24D));
    }));
    return list;
  }

  static String getDistance(double distance, String unit) {
    String unit = setting.value.distanceUnit;
    if (unit == 'km') {
      distance *= 1.60934;
    }
    return distance != null ? "${distance.toStringAsFixed(2)} $unit" : "";
  }

  static String skipHtml(String htmlString) {
    try {
      var document = parse(htmlString);
      String parsedString = parse(document.body.text).documentElement.text;
      return parsedString;
    } catch (e) {
      return '';
    }
  }

  static calculateDeliveryFees(){

    int deliveryFees =0;

    for (var item in currentLogisticsPricing.value) {
      if(item.fromRange <= currentCheckout.value.km && item.toRange >= currentCheckout.value.km){
        deliveryFees = item.amount;
      }
    }
    return deliveryFees;
  }

  static shopOpenStatus(Vendor vendorList){
    String availableType =  vendorList.shopTiming.availableType;
    bool status = false;
    if(availableType=='1'){
      status =  checkShopTimingStatus(vendorList, vendorList.shopTiming.allTimes.fromAvailableTime,  vendorList.shopTiming.allTimes.toAvailableTime);
    } else if(availableType=='2'){
      try {
        for (var element in vendorList.shopTiming.sameTime) {
          status = checkShopTimingStatus(
              vendorList, element.fromAvailableTime,
              element.toAvailableTime);
          if(status==true) throw "";
        }
      }catch (e) {
        // leave it
      }
    } else if (availableType=='3'){
      String day = DateFormat('EEEE').format(DateTime.now());
      try {
        if(day=='Monday') {
          for (var element in vendorList.shopTiming.differentTime.monDay) {
            status = checkShopTimingStatus(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        } else if (day=='Tuesday'){
          for (var element in vendorList.shopTiming.differentTime.tueDay) {
            status = checkShopTimingStatus(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Wednesday'){
          for (var element in vendorList.shopTiming.differentTime.wedDay) {
            status = checkShopTimingStatus(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Thursday'){
          for (var element in vendorList.shopTiming.differentTime.thurDay) {
            status = checkShopTimingStatus(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Friday'){
          for (var element in vendorList.shopTiming.differentTime.friDay) {
            status = checkShopTimingStatus(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Saturday'){
          for (var element in vendorList.shopTiming.differentTime.satDay) {
            status = checkShopTimingStatus(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Sunday'){
          for (var element in vendorList.shopTiming.differentTime.sunDay) {
            status = checkShopTimingStatus(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }

        }
      }catch (e) {
        // leave it
      }

    }


    return status;
  }









  static checkShopTimingStatus(Vendor vendor,String fromAvailableTime,String toAvailableTime){
    var openTime = fromAvailableTime.split(" ");
    var closeTime = toAvailableTime.split(" ");
    var openHrm = openTime[0].split(":");
    var closeHrm = closeTime[0].split(":");
    DateTime now = DateTime.now();
    bool status = false;
    DateTime startTime;
    DateTime endTime;
    String dayVelocity;

    if (openTime[1] == 'AM' && closeTime[1] == 'AM') {
      startTime = DateTime(
          now.year, now.month, now.day, int.parse(openHrm[0].trim()),
          int.parse(openHrm[1].trim()));
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()),
          int.parse(closeHrm[1].trim()));
      dayVelocity = 'straight';

    } else if (openTime[1] == 'AM' && closeTime[1] == 'PM') {
      startTime = DateTime(
          now.year, now.month, now.day, int.parse(openHrm[0].trim()),
          int.parse(openHrm[1].trim()));
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()) + 12,
          int.parse(closeHrm[1].trim()));
      dayVelocity = 'straight';
    } else if (openTime[1] == 'PM' && closeTime[1] == 'PM') {
      startTime = DateTime(
          now.year, now.month, now.day, int.parse(openHrm[0].trim()) + 12,
          int.parse(openHrm[1].trim()));
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()) + 12,
          int.parse(closeHrm[1].trim()));
      dayVelocity = 'straight';
    }else if (openTime[1] == 'PM' && closeTime[1] == 'AM') {
      startTime = DateTime(
          now.year, now.month, now.day, int.parse(openHrm[0].trim()) + 12,
          int.parse(openHrm[1].trim()));
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()),
          int.parse(closeHrm[1].trim()));
      dayVelocity = 'reverse';
    }
    if (now.isAfter(startTime) && now.isBefore(endTime) && dayVelocity=='straight') {

      // do something
      status = true;
    } else if (now.isAfter(endTime) && now.isAfter(startTime)&& dayVelocity=='reverse'){

      status = true;
    }

    return status;
  }




  static itemAvailableStatus(ProductDetails2 product){
    String availableType =  product.itemTiming.availableType;
    bool status = false;
    String day = DateFormat('EEEE').format(DateTime.now());

    if(availableType=='1'){
      status =  checkItemTimingStatus(product, product.itemTiming.allTimes.fromAvailableTime, product.itemTiming.allTimes.toAvailableTime);
    } else if(availableType=='2'){
      try {
        for (var element in product.itemTiming.sameTime) {
          status = checkItemTimingStatus(
              product, element.fromAvailableTime,
              element.toAvailableTime);
          if(status==true) throw "";
        }
      }catch (e) {
        // leave it
      }
    } else if (availableType=='3'){
      try {
        if(day=='Monday') {
          for (var element in product.itemTiming.differentTime.monDay) {
            status = checkItemTimingStatus(product, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        } else if (day=='Tuesday'){
          for (var element in product.itemTiming.differentTime.tueDay) {
            status = checkItemTimingStatus(product, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Wednesday'){
          for (var element in product.itemTiming.differentTime.wedDay) {
            status = checkItemTimingStatus(product, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Thursday'){
          for (var element in product.itemTiming.differentTime.thurDay) {
            status = checkItemTimingStatus(product, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Friday'){
          for (var element in product.itemTiming.differentTime.friDay) {
            status = checkItemTimingStatus(product, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Saturday'){
          for (var element in product.itemTiming.differentTime.satDay) {
            status = checkItemTimingStatus(product, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }
        }else if (day=='Sunday'){
          for (var element in product.itemTiming.differentTime.sunDay) {
            status = checkItemTimingStatus(product, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) throw "";
          }

        }
      }catch (e) {
        // leave it
      }

    }




    return status;
  }

  static Future<void> openMap(double latitude, double longitude) async {
    Uri googleUrl = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static checkItemTimingStatus(ProductDetails2 product,String fromAvailableTime,String toAvailableTime){


    var openTime = fromAvailableTime.split(" ");
    var closeTime = toAvailableTime.split(" ");
    var openHrm = openTime[0].split(":");
    var closeHrm = closeTime[0].split(":");
    DateTime now = DateTime.now();
    bool status = false;
    DateTime startTime;
    DateTime endTime;


    if (openTime[1] == 'AM' && closeTime[1] == 'AM') {
      startTime = DateTime(
          now.year, now.month, now.day, int.parse(openHrm[0].trim()),
          int.parse(openHrm[1].trim()));
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()),
          int.parse(closeHrm[1].trim()));
    } else if (openTime[1] == 'AM' && closeTime[1] == 'PM') {
      startTime = DateTime(
          now.year, now.month, now.day, int.parse(openHrm[0].trim()),
          int.parse(openHrm[1].trim()));
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()) + 12,
          int.parse(closeHrm[1].trim()));
    } else if (openTime[1] == 'PM' && closeTime[1] == 'PM') {
      startTime = DateTime(
          now.year, now.month, now.day, int.parse(openHrm[0].trim()) + 12,
          int.parse(openHrm[1].trim()));
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()) + 12,
          int.parse(closeHrm[1].trim()));
    }
    if(startTime!= null) {
      if (now.isAfter(startTime) && now.isBefore(endTime)) {
        // do something

        status = true;
      }
    }

    return status;
  }




  static nextOpenTime(Vendor vendorList){
    String availableType =  vendorList.shopTiming.availableType;
    bool status = false;
    String nextTime;

    if(availableType=='1'){
      status =  checkNextTiming(vendorList, vendorList.shopTiming.allTimes.fromAvailableTime,  vendorList.shopTiming.allTimes.toAvailableTime);
      if(status==true) {
        nextTime =
        'Open at: ${vendorList.shopTiming.allTimes.fromAvailableTime}-${vendorList.shopTiming.allTimes.toAvailableTime}';
      }
    } else if(availableType=='2'){
      try {
        for (var element in vendorList.shopTiming.sameTime) {
          status = checkNextTiming(
              vendorList, element.fromAvailableTime,
              element.toAvailableTime);
          if(status==true) {
            nextTime =
            'Open at: ${element.fromAvailableTime}-${element.toAvailableTime}';
          }
          if(status==true) throw "";
        }
      }catch (e) {
        // leave it
      }
    } else if (availableType=='3'){
      String day = DateFormat('EEEE').format(DateTime.now());
      try {
        if(day=='Monday') {
          for (var element in vendorList.shopTiming.differentTime.monDay) {
            status = checkNextTiming(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) {
              nextTime =
              'Open at: ${element.fromAvailableTime}-${element.toAvailableTime}';
            }
            if(status==true) throw "";
          }
        } else if (day=='Tuesday'){
          for (var element in vendorList.shopTiming.differentTime.tueDay) {
            status = checkNextTiming(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) {
              nextTime =
              'Open at: ${element.fromAvailableTime}-${element.toAvailableTime}';
            }
            if(status==true) throw "";
          }
        }else if (day=='Wednesday'){
          for (var element in vendorList.shopTiming.differentTime.wedDay) {
            status = checkNextTiming(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) {
              nextTime =
              'Open at: ${element.fromAvailableTime}-${element.toAvailableTime}';
            }
            if(status==true) throw "";
          }
        }else if (day=='Thursday'){
          for (var element in vendorList.shopTiming.differentTime.thurDay) {
            status = checkNextTiming(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) {
              nextTime =
              'Open at: ${element.fromAvailableTime}-${element.toAvailableTime}';
            }
            if(status==true) throw "";
          }
        }else if (day=='Friday'){
          for (var element in vendorList.shopTiming.differentTime.friDay) {
            status = checkNextTiming(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) {
              nextTime =
              'Open at: ${element.fromAvailableTime}-${element.toAvailableTime}';
            }
            if(status==true) throw "";
          }
        }else if (day=='Saturday'){
          for (var element in vendorList.shopTiming.differentTime.satDay) {
            status = checkNextTiming(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) {
              nextTime =
              'Open at: ${element.fromAvailableTime}-${element.toAvailableTime}';
            }
            if(status==true) throw "";
          }
        }else if (day=='Sunday'){
          for (var element in vendorList.shopTiming.differentTime.sunDay) {
            status = checkNextTiming(vendorList, element.fromAvailableTime, element.toAvailableTime);
            if(status==true) {
              nextTime =
              'Open at: ${element.fromAvailableTime}-${element.toAvailableTime}';
            }
            if(status==true) throw "";
          }

        }
      }catch (e) {
        // leave it
      }

    }


    return nextTime;
  }


  static checkNextTiming(Vendor vendor,String fromAvailableTime,String toAvailableTime){
    var openTime = fromAvailableTime.split(" ");
    var closeTime = toAvailableTime.split(" ");
    var closeHrm = closeTime[0].split(":");
    DateTime now = DateTime.now();
    bool status = false;
    DateTime endTime;
    String dayVelocity;

    if (openTime[1] == 'AM' && closeTime[1] == 'AM') {
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()),
          int.parse(closeHrm[1].trim()));
      dayVelocity = 'straight';

    } else if (openTime[1] == 'AM' && closeTime[1] == 'PM') {
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()) + 12,
          int.parse(closeHrm[1].trim()));
      dayVelocity = 'straight';
    } else if (openTime[1] == 'PM' && closeTime[1] == 'PM') {
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()) + 12,
          int.parse(closeHrm[1].trim()));
      dayVelocity = 'straight';
    }else if (openTime[1] == 'PM' && closeTime[1] == 'AM') {
      endTime = DateTime(
          now.year, now.month, now.day, int.parse(closeHrm[0].trim()),
          int.parse(closeHrm[1].trim()));
      dayVelocity = 'reverse';
    }
    if (now.isBefore(endTime) && dayVelocity=='straight') {

      // do something

      status = true;
    }

    return status;
  }

  static checkCancellationStatus(  timestamp, int min){
    int timeInMillis = int.parse(timestamp);
    var cancellationDate = DateTime.fromMillisecondsSinceEpoch(timeInMillis * 1000).add(Duration(minutes: min ));

    int cancellationTs = cancellationDate.millisecondsSinceEpoch;
    int currentTs = DateTime.now().millisecondsSinceEpoch;
    if(currentTs>cancellationTs){

      return false;
    }else {

      return true;
    }
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Theme.of(context).primaryColor.withOpacity(0.85),
          child: const CircularLoadingWidget(height: 200),
        ),
      );
    });
    return loader;
  }

  static roundOffToXDecimal(double number, {int numberOfDecimal = 2}) {
    // To prevent number that ends with 5 not round up correctly in Dart (eg: 2.275 round off to 2.27 instead of 2.28)
    String numbersAfterDecimal = number.toString().split('.')[1];

    if (numbersAfterDecimal != '0') {
      int existingNumberOfDecimal = numbersAfterDecimal.length;
      number += 1 / (10 * pow(10, existingNumberOfDecimal));
    }

    return double.parse(number.toStringAsFixed(numberOfDecimal));
  }


  static pricePrint(String amount) {

    double displayAmount;
    displayAmount = double.parse(amount)?.toDouble();

    double currency;
    currency =roundOffToXDecimal(displayAmount,numberOfDecimal: setting.value.currencyDecimalDigits);


    /* switch (monenytype) {
      case 1:
        processAmount = moneyFormat( decimal[0].trim()).replaceAll('.',',');
        break;
      case 2:
        processAmount = moneyFormat( decimal[0].trim()).replaceAll(',','.');
        break;
      case 3:
        processAmount =  moneyFormat( decimal[0].trim()).replaceAll('.','');
        break;
      case 4:
        processAmount =  moneyFormat( decimal[0].trim()).replaceAll(',','');
        break;
      case 5:
        processAmount =  moneyFormat( decimal[0].trim()).replaceAll(',','\'');
        break;
      case 6:
        processAmount=  moneyFormat( decimal[0].trim()).replaceAll('.',' ');
        break;
      case 7:
        processAmount =  moneyFormat( decimal[0].trim()).replaceAll(',',' ');
        break;
      case 8:
        processAmount =   moneyFormat( decimal[0].trim()).replaceAll("'",' ');
        break;
      default:
        processAmount =  moneyFormat( decimal[0].trim()).replaceAll('.',',');
        break;
    } */


    if (setting.value.currencyRight) {
      return '$currency ${setting.value.defaultCurrency}';
    } else {
      return '${setting.value.defaultCurrency} $currency';

    }


  }

  static moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
  }

  static priceDistance(km) {

    if(setting.value.distanceUnit=='miles') {

      return '$km Mi';
    } else{

      return '$km Km';

    }

  }

  static mediaSize(context,type,value ){
    var size =MediaQuery.of(context).size;
    if(type=='height'){
      return size.height * value;
    }else {
      return size.width * value;
    }
  }

  static calculateTime(double distance, int handoverTime, bool minLock){
    var avgSpeed = (1/ 48);
    var hours  =  avgSpeed* distance;
    var mins   =  hours * 60;
    var totalMinutes   = (mins+handoverTime).toStringAsFixed(0);
    if(minLock){
      return totalMinutes;
    }else {
      return "$totalMinutes mins";
    }

  }

  static hideLoader(OverlayEntry loader) {
    Timer(const Duration(milliseconds: 500), () {
      try {
        loader?.remove();
      // ignore: empty_catches
      } catch (e) {}
    });
  }

  static String limitString(String text, {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, Math.min<int>(limit, text.length)) + (text.length > limit ? hiddenText : '');
  }

  static Color getColorFromHex(String hex) {
    if (hex.contains('#')) {
      return Color(int.parse(hex.replaceAll("#", "0xFF")));
    } else {
      return Color(int.parse("0xFF$hex"));
    }
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ${number.substring(4, 8)}';
      result += ' ${number.substring(8, 12)}';
      result += ' ${number.substring(12, 16)}';
    }
    return result;
  }

  static Uri getUri(String path) {
    // ignore: deprecated_member_use
    String path0 = Uri.parse(GlobalConfiguration().getString('base_url')).path;
    if (!path0.endsWith('/')) {
      path0 += '/';
    }
    Uri uri = Uri(
      // ignore: deprecated_member_use
        scheme: Uri.parse(GlobalConfiguration().getString('base_url')).scheme,
        // ignore: deprecated_member_use
        host: Uri.parse(GlobalConfiguration().getString('base_url')).host,
        // ignore: deprecated_member_use
        port: Uri.parse(GlobalConfiguration().getString('base_url')).port,
        path: path0 + path);
    return uri;
  }


  static Future<Marker> getMyPositionMarker(double latitude, double longitude) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: const Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }
  static BoxFit getBoxFit(String boxFit) {
    switch (boxFit) {
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'fit_height':
        return BoxFit.fitHeight;
      case 'fit_width':
        return BoxFit.fitWidth;
      case 'none':
        return BoxFit.none;
      case 'scale_down':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  static Future<Marker> getMarker(Map<String, dynamic> res) async {

    final Uint8List markerIcon = await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(res['shopId']),
        icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //print(res.name);
//        },
        anchor: const Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title: res['shopName'],
            snippet: Helper.priceDistance(res['distance']),
            onTap: () {

            }),
        position: LatLng(double.parse(res['latitude']), double.parse(res['longitude'])));

    return marker;
  }


  static Future<Marker> getMarkerProvider(Map<String, dynamic> res) async {

    final Uint8List markerIcon = await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(res['id']),
        icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //print(res.name);
//        },
        anchor: const Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title: res['name'],
            snippet: '2',
            onTap: () {

            }),
        position: LatLng(double.parse(res['latitude']), double.parse(res['longitude'])));

    return marker;
  }



  static distance(
      double lat1, double lon1, double lat2, double lon2, String unit) {
    double theta = lon1 - lon2;
    double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;
    if (unit == 'miles') {
      dist = dist * 0.8684;
    } else  {
      dist = dist * 1.609344;
    }

    return double.parse(dist.toStringAsFixed(2));
  }

  static double deg2rad(double deg) {
    return (deg * pi / 180.0);
  }

  static  double rad2deg(double rad) {
    return (rad * 180.0 / pi);
  }




  static AlignmentDirectional getAlignmentDirectional(String alignmentDirectional) {
    switch (alignmentDirectional) {
      case 'top_start':
        return AlignmentDirectional.topStart;
      case 'top_center':
        return AlignmentDirectional.topCenter;
      case 'top_end':
        return AlignmentDirectional.topEnd;
      case 'center_start':
        return AlignmentDirectional.centerStart;
      case 'center':
        return AlignmentDirectional.topCenter;
      case 'center_end':
        return AlignmentDirectional.centerEnd;
      case 'bottom_start':
        return AlignmentDirectional.bottomStart;
      case 'bottom_center':
        return AlignmentDirectional.bottomCenter;
      case 'bottom_end':
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.bottomEnd;
    }
  }

  static Html applyHtml(context, String html, {TextStyle style}) {
    return Html(
      data: html ?? '',

      useRichText: true,



    );
  }


  static toaster(title, message, type){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: type=='success'?Colors.green:
        type=='error'?Colors.red:Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }
}
