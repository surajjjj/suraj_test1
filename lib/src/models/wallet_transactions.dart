import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class WalletTransactions {
  // ignore: non_constant_identifier_names
  String transactions_id;
  String type;
  String amount;
  String balance;
  String status;
  String date;
  // ignore: non_constant_identifier_names
  String 	message;



  WalletTransactions();

  WalletTransactions.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      transactions_id = jsonMap['transactions_id'];
      type = jsonMap['type'];
      amount = jsonMap['amount'] ?? 0.0;
      balance = jsonMap['balance']?? 0.0;
      status = jsonMap['status'];
      date = jsonMap['date'];
      message = jsonMap['message'];


    } catch (e) {

      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
