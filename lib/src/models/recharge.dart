
class Recharge {
  // ignore: non_constant_identifier_names
  String user_id;
  String amount;
  String type;
  String status;

  Recharge();

  Recharge.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      user_id = jsonMap['user_id'];
      amount = jsonMap['amount'];
      type = jsonMap['type'];
      status = jsonMap['status'];
    } catch (e) {
      user_id = '';
      amount = '';
      type = '';
      status = '';

    }
  }

  Map toMap() {
    var map = <String, dynamic>{};
    map["user_id"] = user_id;
    map["amount"] = amount;
    map["type"] = type;

    map["status"] = status;



    return map;
  }


}
