import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import '../models/recharge.dart';
import '../models/wallet_transactions.dart';
import 'user_repository.dart';
import '../helpers/custom_trace.dart';
import '../helpers/helper.dart';
import '../models/wallet.dart';
Future<Stream<Wallet>> getWallet() async {
  Uri uri = Helper.getUri('api/user/wallet/balance/${currentUser.value.id}');

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Wallet.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(Wallet.fromJSON({}));
  }
}

Future<Stream<WalletTransactions>> getTransaction(type) async {
  Uri uri = Helper.getUri('api/user/wallet/list/${currentUser.value.id}/$type');
    if (kDebugMode) {
      print(uri);
    }
  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => WalletTransactions.fromJSON(data));
  } catch (e) {
    if (kDebugMode) {
      print(CustomTrace(StackTrace.current, message: uri.toString()).toString());
    }
    return Stream.value(WalletTransactions.fromJSON({}));
  }
}

// ignore: non_constant_identifier_names
Future<bool> SendRecharge(Recharge data) async {
  data.status = 'waiting';
  // ignore: deprecated_member_use
  final String url = '${GlobalConfiguration().getString('api_base_url')}api/recharge';

  bool res;
  final client = http.Client();
  final response = await client.post(
      Uri.parse(url),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(data.toMap()),
  );

  if (response.statusCode == 200) {
    // setCurrentUser(response.body);
    // currentUser.value = User.fromJSON(json.decode(response.body)['data']);
    if (json.decode(response.body)['data'] == 'success') {
      res = true;
    } else {
      res = false;
    }
  } else {
    throw Exception(response.body);
  }
  return res;
}