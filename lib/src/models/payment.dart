class Payment {
  String id;
  String status;
  String method;
  String paymentType;
  // ignore: non_constant_identifier_names
  double grand_total = 0.0;
  double discount = 0.0;
  // ignore: non_constant_identifier_names
  double sub_total = 0.0;
  // ignore: non_constant_identifier_names
  double delivery_fees = 0;
  // ignore: non_constant_identifier_names
  double delivery_tips =0;
  double km = 0.0;
  double tax = 0.0;
  double packingCharge = 0.0;



  Payment();

  Payment.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      status = jsonMap['status'];
      method = jsonMap['method'];
      paymentType = jsonMap['paymentType'];
      grand_total = jsonMap['grand_total'] != null ? jsonMap['grand_total'].toDouble() :  0.0;
      discount = jsonMap['discount']!= null ? jsonMap['discount'].toDouble() : 0.0;
      sub_total = jsonMap['sub_total']!= null ? jsonMap['sub_total'].toDouble() :  0.0;

      delivery_fees = jsonMap['delivery_fees']!= null ? jsonMap['delivery_fees'].toDouble() :  0.0;
      delivery_tips = jsonMap['delivery_tips']!= null ? jsonMap['delivery_tips'].toDouble() :  0.0;
      tax = jsonMap['tax']!= null ? jsonMap['tax'].toDouble() :  0.0;
      km =  jsonMap['km']!= null ? jsonMap['km'].toDouble() :  0.0;

      packingCharge = jsonMap['packingCharge']!= null ? jsonMap['packingCharge'].toDouble() :  0.0;
    } catch (e) {
      id = '';
      status = '';
      method = '';
      km =0.0;
      delivery_fees = 0;
      delivery_tips = 0;
      tax = 0;

    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "paymentType": paymentType,
    "method": method,
    "grand_total": grand_total,
    "sub_total": sub_total,
    "discount": discount,
    "km": km,
    "delivery_fees": delivery_fees,
    "delivery_tips": delivery_tips,
    "tax": tax,
    "packingCharge": packingCharge,
  };

  Map toMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["status"] = status;
    map["paymentType"] = paymentType;
    map["method"] = method;
    map["grand_total"] = grand_total;
    map["sub_total"] = sub_total;
    map["discount"] = discount;
    map["km"] = km;
    map["delivery_fees"] = delivery_fees;
    map["delivery_tips"] = delivery_tips;
    map["tax"] = tax;
    map["packingCharge"] = packingCharge;
    return map;
  }
}
