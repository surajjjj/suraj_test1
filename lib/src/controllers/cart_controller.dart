import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mpesa/mpesa.dart';
import '../components/directions_model.dart';
import '../components/directions_repository.dart';
import '../models/cart_responce.dart';
import '../models/recharge.dart';
import '../models/wallet.dart';
import '../pages/global_payment.dart';
import '../repository/home_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/wallet_repository.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../generated/l10n.dart';
import '../models/addon.dart';
import '../models/addongroup_model.dart';
import '../models/combination_variant.dart';
import '../models/coupon.dart';
import '../models/timeslot.dart';
import '../helpers/helper.dart';
import '../models/checkout.dart';
import '../models/variant.dart';
import '../models/variant_group.dart';
import '../models/vendor.dart';
import '../pages/flutter_wave_payment.dart';
import '../pages/paypal_payment.dart';
import '../pages/stripe_payment.dart';
import '../repository/user_repository.dart';
import '../repository/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/product_repository.dart';
import '../repository/vendor_repository.dart';

class CartController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  int cartCount = 0;
  String variantTotalAmount = '0';
  List<Wallet> walletList = <Wallet>[];
  List<CouponModel> couponList = <CouponModel>[];
  List<CouponModel> tempCouponList = <CouponModel>[];
  CartResponse productData = CartResponse();
  String keyMatcher;
  String variantGlobalName;
  List<TimeSlot> timeSlot = <TimeSlot>[];
  bool checkOutButtonLoad = false;
  bool checkOutGatePass = true;
  Razorpay _razorpay;
  GlobalKey<ScaffoldState> scaffoldCheckout;
  bool couponStatus = false;
  OverlayEntry loader;
  bool paymentLoading = true;
  double donation=0;
  double totalsss=0;
  Recharge rechargeData = Recharge();
  TextEditingController couponController;
  CartController() {
    scaffoldCheckout = GlobalKey<ScaffoldState>();
    scaffoldKey = GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(context);
    couponController = TextEditingController();
  }

  @override
  void initState() {
    // settingRepo.initSettings();
    currentCheckout.value.deliveryPossible = true;
    super.initState();
    currentCart.notifyListeners();
    calculateDeliveryFees();
    // donation=currentCheckout.value.sub_total;
    // totalsss=donation+1;

    // showToastMessage("$totalsss");






  }

  getOriginalDistance() async {

    checkOutButtonLoad = true;

    getZoneId().then((value) async {

      currentUser.value.zoneId = value;
      if( currentUser.value.zoneId!="no_matched" && currentCheckout.value.zoneId == currentUser.value.zoneId){
        currentCheckout.value.deliveryPossible = true;
      }else{
        currentCheckout.value.deliveryPossible = false;
      }

      if(currentCheckout.value.deliveryPossible) {
        LatLng origin = LatLng(
            currentUser.value.latitude, currentUser.value.longitude);
        LatLng destination = LatLng(
            double.parse(currentCheckout.value.shopLatitude),
            double.parse(currentCheckout.value.shopLongitude));
        Directions info;
        final directions = await DirectionsRepository().getDirections(
            origin: origin, destination: destination);
        setState(() => info = directions);
        if (info?.totalDistance != null) {
          var parts = info.totalDistance.split("km");
          var part1 = parts[0].replaceAll(RegExp('[^A-Za-z0-9]'), '');

          currentCheckout.value.km = double.parse(part1);
        } else {
          currentCheckout.value.km = 1;
        }


        calculateDeliveryFees();
      }

      setCurrentUser(currentUser.value);
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      currentCart.notifyListeners();
      checkOutButtonLoad = false;
    }).catchError((e) {

    });


  }





  finder(CartResponse product){

    List<variantGroupModel> vGroup= [];
    List<AddonGroupModel> aGroup= [];


    for (var element in product.variantGroup) {
      List<variantModel> vl=  <variantModel>[];
      variantGroupModel ps = variantGroupModel();
      for (var element1 in element.variant) {

        if( element.relation=='parent' && product.totalSteps==2) {

          variantModel ve = variantModel();
          ve.variantName = element1.variantName;
          ve.variantId = element1.variantId;
          ve.productId = element1.productId;
          ve.selected = element1.selected;
          ve.step = element1.step;
          ve.subtype = element1.subtype;
          vl.add(ve);
          if(element1.selected==true) {
            variantGlobalName = element1.variantName;
          }
        } else if(element.relation=='child') {
          variantModel ve = variantModel();
          ve.variantName = element1.variantName;
          ve.variantId = element1.variantId;
          ve.productId = element1.productId;
          ve.selected = element1.selected;
          ve.step = element1.step;
          ve.subtype = element1.subtype;
          vl.add(ve);

        }
      }

      ps.groupName = element.groupName;
      ps.step = element.step;
      ps.boxType = element.boxType;
      ps.relation = element.relation;
      ps.variant = vl;
      vGroup.add(ps);
    }

    for (var element in product.addonGroup) {
      List<AddonModel> gl= <AddonModel>[];
      AddonGroupModel  addonGroup = AddonGroupModel();
      for (var element1 in element.addon) {
        AddonModel ge = AddonModel();

        ge.addon_id = element1.addon_id;
        ge.product_id = element1.product_id;
        ge.name = element1.name;
        ge.selected = element1.selected;
        ge.price = element1.price;
        ge.type = element1.type;
        ge.status = element1.status;
        ge.foodType = element1.foodType;
        gl.add(ge);
      }

      addonGroup.name = element.name;
      addonGroup.vendor = element.vendor;
      addonGroup.addon = gl;
      aGroup.add(addonGroup);
    }




    productData.variantGroup= vGroup;
    productData.addonGroup= aGroup;
    productData.productId = product.productId;
    productData.product_name = product.product_name;
    productData.product_name = product.product_name;
    productData.multipleVariant = product.multipleVariant;
    productData.image = product.image;
    productData.foodType = product.foodType;
    productData.price = product.price;
    productData.discount = product.discount;
    productData.packingCharge = product.packingCharge;
    productData.tax = product.tax;
    productData.availableType = product.availableType;
    productData.totalSteps = product.totalSteps;
    productData.defaultVariant = product.defaultVariant;
    productData.itemTiming = product.itemTiming;
    productData.qty = product.qty;
    productData.variantName = variantGlobalName;

    combinationFinder(product,variantGlobalName, 'direct');

  }



  gatewayVariant(CartResponse productDetails,Vendor shopDetails, variantName,step,type){


    bool gateway = false;
    if(step==2){
      for (var element in currentCart.value) {
        if(element.productId==productDetails.productId && element.variantName==variantName) {
          gateway = true;
        }
      }
    }

    if(gateway==false){
      addToCartRestaurant(productDetails,shopDetails, variantName, step);
    }else {
      incrementVariant(productDetails.productId,variantName);
    }

    if(type=='variant') {
      Navigator.pop(context);
    }
  }

  removeVariant(productId,variantName, type) {
    for (var element in currentCart.value) {

      if(element.productId==productId && element.variantName==variantName) {

        element.qty = element.qty - 1;

      }
    }
    currentCart.value.removeWhere((item) => item.qty == 0);
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
    grandSummary();
    if(type=='variant') {
      Navigator.pop(context);
    }

    if (currentCart.value.isEmpty) {
      currentCheckout.value.shopName = null;
      currentCheckout.value.shopTypeID = 0;
      currentCheckout.value.shopId = null;
      Navigator.of(context).pushReplacementNamed('/EmptyList');
    }
  }


  addToCartRestaurant(CartResponse productDetail,Vendor shopDetails, variantName, step,){

    CartResponse cartResponse = CartResponse();
    String cname;
    cartResponse.product_name = productDetail.product_name;
    cartResponse.price = variantTotalAmount;
    cartResponse.image = productDetail.image;
    cartResponse.productId = productDetail.productId;
    cartResponse.strike = '100';
    cartResponse.qty = productDetail.qty;
    cartResponse.variantName = variantName;
    cartResponse.userId = currentUser.value.id;
    cartResponse.tax = productDetail.tax * productDetail.qty;
    cartResponse.discount = productDetail.discount;
    cartResponse.packingCharge = productDetail.packingCharge;
    cartResponse.foodType = productDetail.foodType;
    cartResponse.multipleVariant = productDetail.multipleVariant;
    cartResponse.defaultVariant = productDetail.defaultVariant;
    cartResponse.itemTiming = productDetail.itemTiming;
    cartResponse.availableType = productDetail.availableType;
    cartResponse.variantGroup = productDetail.variantGroup;
    cartResponse.combinationVariant = productDetail.combinationVariant;
    for (var element in productDetail.combinationVariant) {
      if(element.selected){
        cname = element.cname;
      }
    }

    for (var element in productDetail.combinationAllVariant) {
      if(element.cname==cname){
        element.selected = true;
      }else {
        element.selected = false;
      }
    }

    cartResponse.combinationAllVariant = productDetail.combinationAllVariant;
    cartResponse.addonGroup = productDetail.addonGroup;
    cartResponse.totalSteps = productDetail.totalSteps;
    currentCheckout.value.km =
        double.parse(shopDetails.distance.replaceAll(',', ''));
    currentCheckout.value.shopId = shopDetails.shopId;
    currentCheckout.value.shopName = shopDetails.shopName;
    currentCheckout.value.subtitle = shopDetails.subtitle;
    currentCheckout.value.shopLatitude = shopDetails.latitude;
    currentCheckout.value.shopLongitude = shopDetails.longitude;

    currentCheckout.value.zoneId = currentUser.value.zoneId;
    currentCheckout.value.handoverTime = 10;
    currentCart.value.add(cartResponse);
    currentCheckout.value.handoverTime =
        int.parse(currentVendor.value.handoverTime);

    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
    setCurrentCartItem();

    setCurrentCheckout(currentCheckout.value);
    if (kDebugMode) {
      print(cartResponse.toMap());
    }


    grandSummary();

  }

  combinationFinder(CartResponse product, variantName, defaultSelect){


    List<CombinationVariantModel> cGroup= [];
    int i =1;

    for (var element in product.combinationAllVariant) {
      if(element.matchKey == '-$variantName-${element.variantName}' || product.totalSteps == 1) {
        CombinationVariantModel ce = CombinationVariantModel();

        ce.cname = element.cname;
        ce.variantPrice = element.variantPrice;
        ce.salesPrice = element.salesPrice;

        ce.variantId = element.variantId;
        ce.variantName = element.variantName;
        ce.matchKey = element.matchKey;
        if(defaultSelect=='direct'){
          ce.selected = element.selected;

          if(ce.selected){
            if(product.totalSteps==2) {
              keyMatcher = '-$variantName-${ce.variantName}';
            }else {
              keyMatcher = '-${ce.variantName}';
            }
          }

        }else if(defaultSelect=='userSelect'){
          if(i==1) {
            ce.selected = true;
            if(product.totalSteps==2) {
              keyMatcher = '-$variantName-${ce.variantName}';
            }else {
              keyMatcher = '-${ce.variantName}';
            }
          }else{
            ce.selected = false;
          }

        }
        i++;
        cGroup.add(ce);
      }
    }
    productData.combinationVariant = cGroup;
    productData.combinationAllVariant =  product.combinationAllVariant;
    variantCalculation(productData,'first');
  }



  variantCalculation(CartResponse product, String type){

    double variantAmount = 0.0 ;
    double addonAmount = 0.0;
    double total = 0.0;
    for (var element in product.combinationVariant) {

      if(element.selected){
        variantAmount += double.parse(element.salesPrice);
      }
    }

    if(!product.multipleVariant){
      variantAmount = double.parse(product.price);
    }

    for (var addon in product.addonGroup) {
      for (var element in addon.addon) {
        if(element.selected){
          addonAmount += double.parse(element.price);
        }
      }
    }
    if(type=='add') {
      product.qty =  product.qty+1;

    }else if(type=='sub'){
      if((product.qty)!=1) {
        product.qty = product.qty - 1;
      }
    }
    total = (variantAmount + addonAmount) * product.qty;

    setState(() {
      variantTotalAmount = total.toString();
    });

  }

  checkProductIdCartVariant(id) {
    int qty = 0;
    for (var element in currentCart.value) {
      if(element.productId==id) {
        qty += element.qty;
      }
    }

    return qty;
  }


  incrementVariant(productId,variantName) {
    for (var element in currentCart.value) {

      if(element.productId==productId && element.variantName==variantName) {

        element.qty = element.qty + 1;

      }
    }


    grandSummary();

  }



  cartVariantUpdate(CartResponse productDetails,variantName,variantGroup, combinationVariant,addonGroup, index){


    int i = 0;
    String cname;
    for (var element in currentCart.value) {
      if(i==index){
        element.product_name = productDetails.product_name;
        element.price = variantTotalAmount;
        element.image = productDetails.image;
        element.productId = productDetails.productId;
        element.strike = productDetails.strike;
        element.qty = productDetails.qty;
        element.variantName = variantName;
        element.variantGroup = variantGroup;
        element.combinationVariant = combinationVariant;
        for (var element in productDetails.combinationVariant) {
          if(element.selected){
            cname = element.cname;
          }
        }

        for (var element in productDetails.combinationAllVariant) {
          if(element.cname==cname){
            element.selected = true;
          }else {
            element.selected = false;
          }
        }
        element.combinationAllVariant =  productDetails.combinationAllVariant;
        element.addonGroup = addonGroup;

      }
      i++;
    }
    grandSummary();
    Navigator.pop(context);
  }


  repeatLastVariant(id) {
    int i = 1;
    for (var element in currentCart.value.reversed) {
      if(element.productId==id) {
        if (i == 1) {
          element.qty = element.qty + 1;
        }
        i++;
      }
    }
    grandSummary();
    Navigator.pop(context);
  }

  calculateDeliveryFees(){

    if( currentUser.value.zoneId!="no_matched" && currentCheckout.value.zoneId == currentUser.value.zoneId){

      if( currentCheckout.value.deliverType != 3) {

        currentCheckout.value.delivery_fees = Helper.calculateDeliveryFees().toDouble();
      }else{
        currentCheckout.value.delivery_fees = 0;
      }

      currentCheckout.value.deliveryPossible = true;
    }else{
      currentCheckout.value.deliveryPossible = false;
    }
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();

    grandSummary();

  }

  listenForCartsCount() async {
    setState(() => cartCount = currentCart.value.length);
  }

  calculateAmount() {

    double totalprice = 0;

    int addon =0;
    for (var cart in currentCart.value) {
      for (var element in cart.addonGroup) {
        for (var addonElement in element.addon) {
          if(addonElement.selected) {
            addon += int.parse(addonElement.price) * cart.qty;
          }
        }


      }

      totalprice += (double.parse(cart.price) * cart.qty)+ addon;
      }

    return double.parse(totalprice.toStringAsFixed(setting.value.currencyDecimalDigits)).toString();
  }








  grandSummary() {
    double saveAmount = 0;
    if (currentCheckout.value.couponStatus == false) {

      double totalPrice = 0;
      double totalSalesPrice = 0;
      double tax = 0;
      double addon = 0;
      double packingCharge = 0;
      double delivery = 0;
      double tipss = 0;
      double pkgcharge = 0;
      double cal = 0;
      double newtip = 0;
      double minusvlaue = 18;
      double taxn = 18;



      for (var cart in currentCart.value) {
        delivery += currentCheckout.value.delivery_fees;
        cal += delivery* (minusvlaue/100) ;
        // tipss += currentCheckout.value.delivery_tips;
        // newtip += tipss* (minusvlaue/100) ;
        tax += 5 ;
        totalPrice += double.parse(cart.price) * cart.qty;


        packingCharge += 5;
        pkgcharge += packingCharge*(minusvlaue/100) ;
      //  showToastMessage("$cal");

        if(cart.variantName!=null){
          totalSalesPrice += double.parse(cart.strike) * cart.qty;
        }


        for (var element in cart.addonGroup) {
          for (var addonElement in element.addon) {
            if (addonElement.selected) {
              addon += double.parse(addonElement.price) * cart.qty;
            }
          }

        }
      }

      tax = double.parse((pkgcharge+cal+(totalPrice * tax) / 100).toStringAsFixed(
          setting.value.currencyDecimalDigits));


      currentCheckout.value.packingCharge = packingCharge;

      saveAmount = double.parse(totalSalesPrice.toStringAsFixed(
          setting.value.currencyDecimalDigits)) - double.parse(
          totalPrice.toStringAsFixed(setting.value.currencyDecimalDigits));
      currentCheckout.value.sub_total = double.parse((totalPrice + addon+totalsss).toStringAsFixed(setting.value.currencyDecimalDigits));
      currentCheckout.value.discount = double.parse(
          saveAmount.toStringAsFixed(setting.value.currencyDecimalDigits));
      currentCheckout.value.tax = tax;
      currentCheckout.value.payment.tax = tax;
      couponStatus = currentCheckout.value.couponStatus;

      if (currentCheckout.value.deliverType != 3) {
        currentCheckout.value.grand_total = double.parse(
            (totalPrice + addon + currentCheckout.value.delivery_tips +
                currentCheckout.value.packingCharge +
                currentCheckout.value.delivery_fees + tax).toStringAsFixed(
                setting.value.currencyDecimalDigits));
      } else {
        currentCheckout.value.grand_total = double.parse(
            (totalPrice + addon + tax).toStringAsFixed(
                setting.value.currencyDecimalDigits));
      }

      paymentLoading = false;
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      currentCart.notifyListeners();
    } else {
      applyCoupon(currentCheckout.value.couponData, 'indirect');
    }
    return saveAmount;
  }



  redirect() {
    if (currentCart.value.isEmpty) {
      Navigator.of(context).pushReplacementNamed('/EmptyList');
    }
  }

  clearInstructionNote(){
    currentCheckout.value.instructionNote = '';
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
  }

  Future<void> listenForCoupons(type,vendorId,user) async {
    final Stream<CouponModel> stream = await getCoupon(type, vendorId,user);
    stream.listen((CouponModel coupons) {
      setState(() => couponList.add(coupons));
      setState(() => tempCouponList.add(coupons));
    }, onError: (a) {

    }, onDone: () {});
  }



  applyCoupon(CouponModel couponData, type) {
    double totalPrice = 0;
    double discountAmount = 0;
    double addon =0;
    double tax =0;
    double tacx =0;


    double packingCharge =0;
    double pkgcharge =0;
    double grandTotal = 0;
    double totalStrikePrice = 0;
    double saveAmount= 0;
    double minusvlaue= 5;
    double delivery= 0;
    double cal= 0;



    for (var cart in currentCart.value) {
      totalPrice += double.parse(cart.price) * cart.qty;
      totalStrikePrice += double.parse(cart.strike) * cart.qty;
      tax += currentCheckout.value.sub_total;
      tacx += tax * (minusvlaue/100) ;
      packingCharge += 5;
      pkgcharge += packingCharge*(18/100) ;

      delivery += currentCheckout.value.delivery_fees;
      cal += delivery* (18/100) ;
      for (var element in cart.addonGroup) {
        for (var addonElement in element.addon) {
        addon += double.parse(addonElement.price)* cart.qty;
        }
      }
    }
    grandTotal = totalPrice+addon;
    saveAmount = double.parse(totalStrikePrice.toStringAsFixed(setting.value.currencyDecimalDigits)) - double.parse(totalPrice.toStringAsFixed(
        setting.value.currencyDecimalDigits));



    if(grandTotal>= double.parse(couponData.minimumPurchasedAmount)) {
      if(couponData.couponType=='1' || couponData.couponType=='2' || couponData.couponType=='3') {
        if (couponData.discountType == 'amount') {

          discountAmount = saveAmount + double.parse(couponData.discount);
          currentCheckout.value.discount = double.parse(discountAmount.toStringAsFixed(setting.value.currencyDecimalDigits)).abs();
          currentCheckout.value.grand_total =
              (grandTotal - double.parse(couponData.discount)) + pkgcharge + tacx + cal;

        } else {

          discountAmount = ((grandTotal * double.parse(couponData.discount)) / 100);
          currentCheckout.value.discount = saveAmount + discountAmount;
          currentCheckout.value.discount = double.parse(currentCheckout.value.discount.toStringAsFixed(setting.value.currencyDecimalDigits)).abs();
          currentCheckout.value.grand_total =
              (grandTotal - discountAmount) + pkgcharge + tacx + cal;

        }
      } else if(couponData.couponType=='4'){
        currentCheckout.value.delivery_fees = 0;
        currentCheckout.value.discount = saveAmount + discountAmount;
        currentCheckout.value.discount = double.parse(currentCheckout.value.discount.toStringAsFixed(setting.value.currencyDecimalDigits)).abs();
        currentCheckout.value.grand_total =
            (grandTotal - discountAmount) + pkgcharge + tacx +cal;

      }


      currentCheckout.value.couponData = couponData;
      currentCheckout.value.couponStatus = true;
      currentCheckout.value.couponCode = couponData.code;
      currentCheckout.value.packingCharge = packingCharge;
      currentCheckout.value.sub_total = grandTotal;
      currentCheckout.value.tax = tacx+pkgcharge+cal;
      currentCheckout.value.payment.tax = tacx;


      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      currentCart.notifyListeners();

      if (type == 'direct') {


        Navigator.pop(context, currentCheckout.value.couponStatus);
        toaster('Applied !',S.of(context).your_coupon_is_applied_successfully,'success');
      }
    } else {
      removeCoupon();
    }
  }

  removeCoupon() {
    currentCheckout.value.couponCode = '';
    currentCheckout.value.couponStatus = false;
    currentCheckout.value.couponData =  CouponModel();
    double totalPrice = 0;
    double discountAmount = 0;
    double addon =0;
    double tax =0;
    double tacx =0;


    double packingCharge =0;
    double pkgcharge =0;    double grandTotal = 0;
    double totalstrikeprice = 0;
    double saveamount= 0;
    double minusvlaue= 5;
    double delivery= 0;
    double cal= 0;



    for (var cart in currentCart.value) {
      totalPrice += double.parse(cart.price) * cart.qty;
      tax += currentCheckout.value.sub_total;
      tacx += tax * (minusvlaue/100) ;
      packingCharge += 5;
      pkgcharge += packingCharge*(18/100) ;

      delivery += currentCheckout.value.delivery_fees;
      cal += delivery* (18/100) ;
      totalstrikeprice += double.parse(cart.strike) * cart.qty;

      for (var element in cart.addonGroup) {
        for (var addonElement in element.addon) {
        addon += double.parse(addonElement.price)* cart.qty;
        }
      }
    }

    grandTotal = totalPrice+addon;
    saveamount = double.parse(grandTotal.toStringAsFixed(setting.value.currencyDecimalDigits)) -  double.parse(totalstrikeprice.toStringAsFixed(setting.value.currencyDecimalDigits));
    currentCheckout.value.sub_total = grandTotal;
    currentCheckout.value.delivery_fees = Helper.calculateDeliveryFees().toDouble();
    currentCheckout.value.tax = tacx+pkgcharge+cal;
    currentCheckout.value.payment.tax = tax;
    currentCheckout.value.discount = saveamount  + discountAmount;
    currentCheckout.value.discount = double.parse(currentCheckout.value.discount.toStringAsFixed(setting.value.currencyDecimalDigits)).abs();
    currentCheckout.value.grand_total = (grandTotal - discountAmount) +pkgcharge+tacx + cal;
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();

    setState(() => couponStatus = false);

    toaster('Removed !',S.of(context).your_coupon_is_removed_successfully,'success');

  }

  clearCart(){
    currentCart.value.clear();
    currentCheckout.value = Checkout();
    setCurrentCartItem();
  }

  void gotoPayment() {
    paymentProcess();
    currentCheckout.value.address.addressSelect = currentUser.value.selected_address;
    currentCheckout.value.address.userId = currentUser.value.id;
    currentCheckout.value.address.phone = currentUser.value.phone;
    currentCheckout.value.address.username = currentUser.value.name;
    currentCheckout.value.userId = currentUser.value.id;
    currentCheckout.value.address.longitude = currentUser.value.longitude;
    currentCheckout.value.address.latitude = currentUser.value.latitude;

    if(currentUser.value.paymentType=='COD'){
      currentCheckout.value.payment.paymentType = 'cash on delivery';
      currentCheckout.value.payment.method = 'cash on delivery';

    } else {
      currentCheckout.value.payment.paymentType = currentUser.value.paymentType;
      currentCheckout.value.payment.method = 'online';

    }

    currentCheckout.value.cart = currentCart.value;
    if (kDebugMode) {
      print(currentCheckout.value.toMap());
    }
    if (currentUser.value.selected_address == null) {

      toaster('Oops !','Please select your address','error');
    } else {

      if(currentCheckout.value.deliverType==1 || currentCheckout.value.deliverType==3) {
        currentCheckout.value.deliveryTimeSlot = '';



        if( currentCheckout.value.payment.method=='online') {
          paymentGate();
        }else {


          if(currentCheckout.value.sub_total==0)
            {
              showToastMessage("Your Cart Value Is Zero Please Click On Plus Button and return Click minus Button");

            }
          else{
            if(currentCheckout.value.sub_total>90) {

              bookOrder(currentCheckout.value);
            }else
            {
              showToastMessage("we are not accepting orders below ₹90");
            }
          }


        }

      }else if (currentCheckout.value.deliveryTimeSlot == null || currentCheckout.value.deliveryTimeSlot == '') {

        toaster('Oops !','Please select your deliver time slot','error');

      } else {


        if(currentCheckout.value.sub_total>120) {

         // showToastMessage("gjugjgYour order amt is 120 minimu order 130");
          bookOrder(currentCheckout.value);
        }else
        {
          showToastMessage("we are not accepting orders below ₹90");
        }

      }
    }
  }


  void openCheckout() async {
    var options = {
      'key': setting.value.razorpay_key,
      'amount': currentCheckout.value.grand_total * 100,
      'name': setting.value.appName,
      'description': 'Online Shopping',
      'prefill': {'contact': currentUser.value.phone, 'email': currentUser.value.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      // debugPrint(e);
    }
  }


  paymentGate(){

    if (currentCheckout.value.payment.method == 'online') {
      if(currentUser.value.paymentType=='RayzorPay'){
        _razorpay = Razorpay();
        _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
        _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
        _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
        openCheckout();
      } if(currentCheckout.value.payment.paymentType == 'Paypal'){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PayPalPaymentWidget()));
      }if(currentCheckout.value.payment.paymentType == 'Stripe'){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const StripePaymentWidget()));
      }if(currentCheckout.value.payment.paymentType == 'flutterwave'){

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FlutterWavePaymentWidget()));
      }if(currentCheckout.value.payment.paymentType == 'Paystack'){

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => GlobalPaymentWidget(pageTitle: 'Paystack',)));
      }if(currentCheckout.value.payment.paymentType == 'wallet'){
        bookOrder(currentCheckout.value);
      } if(currentCheckout.value.payment.paymentType == 'mpesa'){

        Mpesa mpesa = Mpesa(
          clientKey: setting.value.mpesaConsumerKey,
          clientSecret: setting.value.mpesaConsumerSecret,
          passKey: setting.value.mpesaPasskey,
          environment: "sandbox",
        );

        mpesa
            .lipaNaMpesa(
          phoneNumber: currentUser.value.phone,
          amount: currentCheckout.value.grand_total,
          businessShortCode: "174379",
          callbackUrl: "https://www.google.co.in/",
        )
            .then((result) {
          bookOrder(currentCheckout.value);
        })
            .catchError((error) {
          //toaster('Oops !',error,'error');
        });
      }
    } else {

      bookOrder(currentCheckout.value);
    }

  }


  paymentProcess(){


    currentCheckout.value.payment.packingCharge = currentCheckout.value.packingCharge;
    currentCheckout.value.payment.delivery_tips = currentCheckout.value.delivery_tips;
    currentCheckout.value.payment.delivery_fees = currentCheckout.value.delivery_fees;
    currentCheckout.value.payment.sub_total     = currentCheckout.value.sub_total;
    currentCheckout.value.payment.discount      = currentCheckout.value.discount;
    currentCheckout.value.payment.grand_total   = currentCheckout.value.grand_total;

  }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    //Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId, timeInSecForIosWeb: 4);
    bookOrder(currentCheckout.value);
  }

  void _handlePaymentError(PaymentFailureResponse response) {

    //Fluttertoast.showToast(msg: "ERROR: " + response.code.toString() + " - " + response.message, timeInSecForIosWeb: 4);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIosWeb: 4);
  }


  void bookOrder(Checkout order) {

    order.saleCode = '${DateTime.now().millisecondsSinceEpoch}${currentUser.value.id}';

    Overlay.of(context).insert(loader);
    bookOrderResp().then((value) {

      FirebaseFirestore.instance
          .collection('orderDetails')
          .doc(value)
          .set({'status': 'Placed', 'userId': currentUser.value.id, 'orderId':value, 'shopId': order.shopId,'userName': currentUser.value.name,'grandState':false,
        'originLatitude': currentUser.value.latitude, 'originLongitude': currentUser.value.longitude, 'shopLatitude': double.tryParse(currentCheckout.value.shopLatitude),
        'shopLongitude': double.tryParse(currentCheckout.value.shopLongitude),'shopName':currentCheckout.value.shopName,'processingTime': Helper.calculateTime(  currentCheckout.value.km,  currentCheckout.value.handoverTime,true),}).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });

      if(currentCheckout.value.payment.paymentType=='wallet'){
        currentUser.value.walletAmount = (double.parse(currentUser.value.walletAmount) - currentCheckout.value.payment.grand_total).toString();
        setCurrentUserUpdate(currentUser.value);
      }




      Navigator.of(context).pushNamed('/Thankyou', arguments: value);
    }).catchError((e) {

      // ignore: deprecated_member_use

    }).whenComplete(() {
      Helper.hideLoader(loader);
      //refreshOrders();
      /** scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).orderThisorderidHasBeenCanceled(order.id)),
          )); */
    });
  }

  void sendImage(File image, saleCode) async {


    final String apiToken = 'api_token=${currentUser.value.apiToken}';
    // ignore: deprecated_member_use
    final uri = Uri.parse("${GlobalConfiguration().getString('base_url')}Api/sendimage/${currentUser.value.id}/$saleCode?$apiToken");
    var request = http.MultipartRequest('POST', uri);
    var pic = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(pic);
    var response = await request.send();
    if (response.statusCode == 200) {
      // Navigator.of(context).pushReplacementNamed('/Success');

    } else {}
  }



  getTimeSlot() async {
    final Stream<TimeSlot> stream = await getTimeSlotData();
    stream.listen((TimeSlot time) {
      setState(() => timeSlot.add(time));
    }, onError: (a) {

    }, onDone: () {});
  }

  calculateDistance(lat1, lon1,lat2,lon2){

    setState(() => checkOutButtonLoad = true);
    double distance = Helper.distance(lat1, lon1, double.parse(lat2), double.parse(lon2), setting.value.distanceUnit);
    currentCheckout.value.km = distance;

    if(1==2) {
      currentCheckout.value.km = distance;
      if (distance < setting.value.coverDistance) {
        currentCheckout.value.deliveryPossible = true;
      } else {
        currentCheckout.value.deliveryPossible = false;
      }
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      currentCart.notifyListeners();
    } else{
      getZoneId().then((value) {

        currentUser.value.zoneId = value;

        if( currentUser.value.zoneId!="no_matched" && currentCheckout.value.zoneId == currentUser.value.zoneId){
          currentCheckout.value.deliveryPossible = true;
        }else{
          currentCheckout.value.deliveryPossible = false;
        }

        setCurrentUser(currentUser.value);
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        currentCart.notifyListeners();
        setState(() => checkOutButtonLoad = false);
      }).catchError((e) {

      });
    }



  }

  void walletTopUp(amount){
    rechargeData.user_id = currentUser.value.id;
    rechargeData.type = 'credit';
    rechargeData.amount = amount;
    Overlay.of(context).insert(loader);
    SendRecharge(rechargeData).then((value) {

      if (value == true) {
        Navigator.of(context).pushReplacementNamed('/WThankyou');
      } else {
        // ignore: deprecated_member_use

      }
    }).catchError((e) {
      loader.remove();
      // ignore: deprecated_member_use
     /* scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text('Enter your amount'),
      )); */
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  couponSearch(List<CouponModel> list, code){

    List<CouponModel> tempList = list;
    List<CouponModel> dataList = tempList
        .where((u) =>
    (u.code.toLowerCase().contains(code.toLowerCase())) ||
        (u.title.toString().toLowerCase().contains(code.toLowerCase())))
        .toList();
    return dataList;
  }


  Future<void> listenForWallet() async {
    final Stream<Wallet> stream = await getWallet();
    stream.listen((Wallet walletAmount) {
      setState(() => walletList.add(walletAmount));


    }, onError: (a) {

    }, onDone: () {
      for (var element in walletList) {
        currentUser.value.walletAmount = element.balance;
      }
      Helper.hideLoader(loader);
    });
  }

  toaster(title, message, type){

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

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: message=='success'?Colors.green:
      message=='error'?Colors.red:Colors.orangeAccent,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }}
