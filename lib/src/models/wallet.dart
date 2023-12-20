import 'package:flutter/foundation.dart';

import '../helpers/custom_trace.dart';

class Wallet {
  // ignore: non_constant_identifier_names
  // ignore: non_constant_identifier_names
  String user_id;
  String balance;

  Wallet();

  Wallet.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      user_id = jsonMap['user_id'];
      balance = jsonMap['balance'];
    } catch (e) {
      user_id = '';
      balance = '';
      if (kDebugMode) {
        print(CustomTrace(StackTrace.current, message: e));
      }
    }
  }
}
