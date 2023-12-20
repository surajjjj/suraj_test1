import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/checkout.dart';
import '../models/product_details2.dart';
import '../models/timeslot.dart';
import '../models/category.dart';
import '../helpers/helper.dart';
import '../models/cart_responce.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'order_repository.dart';

ValueNotifier<List<CartResponse>> currentCart = ValueNotifier<List<CartResponse>>(<CartResponse>[]);


Future<Stream<ProductDetails2>> getOfferProductlist(offer,categoryId,shopId) async {

  Uri uri = Helper.getUri('api/offerbanner/$offer/$categoryId/$shopId');
  Map<String, dynamic> queryParams = {};
  uri = uri.replace(queryParameters: queryParams);

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) =>  Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => ProductDetails2.fromJSON(data));
  } catch (e) {
    return Stream.value(ProductDetails2.fromJSON({}));
  }
}

Future<Stream<ProductDetails2>> getProductlist(String type, searchTxt) async {

  Uri uri = Helper.getUri('api/productlist/$type');
  Map<String, dynamic> queryParams = {};
  queryParams['search'] = '$searchTxt';
  uri = uri.replace(queryParameters: queryParams);



  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) =>  Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => ProductDetails2.fromJSON(data));
  } catch (e) {
    return Stream.value(ProductDetails2.fromJSON({}));
  }
}

/* discount offer list */
Future<Stream<ProductDetails2>> getProductListOffer(String type, searchTxt) async {

  Uri uri = Helper.getUri('api/productlist/$type');
  Map<String, dynamic> queryParams = {};
  queryParams['search'] = '$searchTxt';
  uri = uri.replace(queryParameters: queryParams);

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) =>  Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => ProductDetails2.fromJSON(data));
  } catch (e) {
    return Stream.value(ProductDetails2.fromJSON({}));
  }
}


void setCurrentCartItem() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('current_cart', json.encode(currentCart.value));
}

void setCurrentCheckout(Checkout jsonString) async {
  try {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_checkout', json.encode(jsonString.toMap()));
  // ignore: empty_catches
  }catch(e){
  }
}


Future<Checkout> getCurrentCheckout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

try {
  currentCheckout.value = Checkout.fromJSON(json.decode(prefs.get('current_checkout')));
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentCheckout.notifyListeners();
  currentCheckout.value.delivery_tips = 0;
// ignore: empty_catches
} catch(e){

}
  return currentCheckout.value;
}


Future<void> removeCheckout() async {
  currentCheckout.value = null;
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentCheckout.notifyListeners();


}


void clearCartItem() async {
  //currentCart.value = new CartResponce();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('current_cart');
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentCart.notifyListeners();
}






Future<List<CartResponse>> getCurrentCartItem() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  currentCart.value = List.from(json.decode(prefs.get('current_cart'))).map((element) => CartResponse.fromJSON(element)).toList();
  // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
  currentCart.notifyListeners();
  return currentCart.value;
}

Future<Stream<Category>> mostOfcategories() async {
  Uri uri = Helper.getUri('api/sub_categories');

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => Category.fromJSON(data));
  } catch (e) {
    return Stream.value(Category.fromJSON({}));
  }
}



// ignore: missing_return
Future<Stream<TimeSlot>> getTimeSlotData() async {
  Uri uri = Helper.getUri('api/user/deliverytimeslot/${currentCheckout.value.shopId}');

  try {
    final client = http.Client();
    final streamedRest = await client.send(http.Request('get', uri));

    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) => Helper.getData(data))
        .expand((data) => (data as List))
        .map((data) => TimeSlot.fromJSON(data));
  // ignore: empty_catches
  } catch (e) {
  }
}



