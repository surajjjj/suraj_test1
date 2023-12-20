
class CancelledModel {
  String orderId;
  String userId;
  String shopId;
  double amount;
  String message;

  CancelledModel();

  CancelledModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      orderId = jsonMap['orderId'];
      userId = jsonMap['userId'];
      shopId = jsonMap['shopId'];
      amount = jsonMap['amount'];
      message = jsonMap['message'];
    } catch (e) {
      orderId = '';
      userId = '';
      shopId = '';
      amount = 0;
      message = '';

    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["orderId"] = orderId;
    map["userId"] = userId;
    map["shopId"] = shopId;
    map["amount"] = amount;
    map["message"] = message;

    return map;
  }
}
