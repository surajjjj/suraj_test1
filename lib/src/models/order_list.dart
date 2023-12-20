import 'cart_responce.dart';
import 'delivery_status.dart';

class OrderList {
  String userid;
  // ignore: non_constant_identifier_names
  String sale_code;
  // ignore: non_constant_identifier_names
  List<CartResponse> product_details;
  //List<Address> address;
  String shipping;
  // ignore: non_constant_identifier_names
  String payment_type;
  // ignore: non_constant_identifier_names
  String payment_status;
  // ignore: non_constant_identifier_names
  String payment_timestamp;
  // ignore: non_constant_identifier_names
  double grand_total;
  // ignore: non_constant_identifier_names
  String sale_datetime;
  // ignore: non_constant_identifier_names
  String delivery_datetime;
  // ignore: non_constant_identifier_names
  List<DeliveryStatus> delivery_status;
  String orderType;
  String status;
  String rating;
  String shopTypeId;
  String vendorLogo;
  String vendorName;
  String vendorLandmark;




  OrderList();

  OrderList.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      userid = jsonMap['userid'].toString();
      sale_code = jsonMap['sale_code'];
      product_details =
          jsonMap['product_details'] != null ? List.from(jsonMap['product_details']).map((element) => CartResponse.fromJSON(element)).toList() : [];
    //  address = jsonMap['address'] != null ? List.from(jsonMap['address']).map((element) => Address.fromJSON(element)).toList() : [];
      shipping = jsonMap['shipping'];
      payment_type = jsonMap['payment_type'];
      payment_status = jsonMap['payment_status'];
      payment_timestamp = jsonMap['payment_timestamp'];
      grand_total = jsonMap['grand_total'].toDouble();
      sale_datetime = jsonMap['sale_datetime'];
      delivery_datetime = jsonMap['delivery_datetime'];
      orderType = jsonMap['orderType'];
      shopTypeId = jsonMap['shopTypeId'];
      status = jsonMap['status'];
      rating = jsonMap['rating'];
      vendorLogo = jsonMap['vendorLogo'];
      vendorName = jsonMap['vendorName'];
      vendorLandmark = jsonMap['vendorLandmark'];
      delivery_status =
          jsonMap['delivery_status'] != null ? List.from(jsonMap['delivery_status']).map((element) => DeliveryStatus.fromJSON(element)).toList() : [];
    } catch (e) {

      userid = '';
      sale_code = '';
      product_details = [];
      //address = [];
      shipping = '';
      payment_type = '';
      payment_status = '';
      payment_timestamp = '';
      grand_total = 0.0;
      sale_datetime = '';
      status = '';
      rating = '';
      delivery_datetime = '';
      delivery_status = [];

    }
  }
}
