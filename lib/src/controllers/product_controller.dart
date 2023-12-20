import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/addongroup_model.dart';
import '../models/combination_variant.dart';
import '../models/shop_rating.dart';
import '../repository/vendor_repository.dart';
import '../../generated/l10n.dart';
import '../models/addon.dart';
import '../models/product_details2.dart';
import '../models/variant.dart';
import '../models/variant_group.dart';
import '../models/vendor.dart';
import '../repository/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../models/auto_suggestion.dart';
import '../models/cart_responce.dart';
import '../repository/product_repository.dart';
import '../repository/search_repository.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';


class ProductController extends ControllerMVC {
  // ignore: non_constant_identifier_names
  List<ProductDetails2> productList = <ProductDetails2>[];
  ProductDetails2 productData = ProductDetails2();
  List<ShopRatingModel> shopReviewList = <ShopRatingModel>[];
  String variantTotalAmount = '0';
  String keyMatcher;
  String variantGlobalName;
  // ignore: non_constant_identifier_names
  List<AutoSuggestion> auto_suggestion = <AutoSuggestion>[];

  GlobalKey<ScaffoldState> scaffoldKey;
  String searchText;
  String pageTitle;
  OverlayEntry loader;
  bool loadCart = false;
  CartResponse cartResponse = CartResponse();
  ProductController() {
    loader = Helper.overlayLoader(context);
    scaffoldKey = GlobalKey<ScaffoldState>();
  }



  void saveSearch(String search) {
    setRecentSearch(search);
    Navigator.of(context).pushReplacementNamed('/ProductList');
  }
  void listenForOfferProductList(offer,categoryId,shopId) async {
    String search = await getRecentSearch();
    setState(() => searchText = search);
    setState(() => productList.clear());
    setState(() => pageTitle = searchText);

    final Stream<ProductDetails2> stream = await getOfferProductlist(offer,categoryId,shopId);
    stream.listen((ProductDetails2 product) {
      setState(() => productList.add(product));

    }, onError: (a) {

      // ignore: deprecated_member_use
      /*scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text('verify_your_internet_connection'),
      ));*/
    }, onDone: () {});
  }

  void listenForProductList(String type) async {
    String search = await getRecentSearch();
    setState(() => searchText = search);
    setState(() => productList.clear());
    setState(() => pageTitle = searchText);

    final Stream<ProductDetails2> stream = await getProductlist(type, searchText);
    stream.listen((ProductDetails2 product) {
      setState(() => productList.add(product));

    }, onError: (a) {

      // ignore: deprecated_member_use
      /*scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text('verify_your_internet_connection'),
      ));*/
    }, onDone: () {});
  }




















  listenGetSuggestion(text) async {
    final Stream<AutoSuggestion> stream = await getAutosuggestion(text);
    auto_suggestion.clear();
    stream.listen((AutoSuggestion product) {
      setState(() => auto_suggestion.add(product));
    }, onDone: () {});
  }

  rTypeProductSearch( tempUsers, String filterString) async {

 /**List<ProductDetails2> _list = tempUsers
        .where((u) =>
    (u.product_name.toLowerCase().contains(filterString.toLowerCase())) ||
        (u.id.toLowerCase().contains(filterString.toLowerCase())))
        .toList();
   print(_list.length);
    return _list; */
  }




  void listenForShopReview(int id) async {
    final Stream<ShopRatingModel> stream = await getShopReviewlist(id);
    stream.listen((ShopRatingModel product) {
      setState(() {
        shopReviewList.add(product);
      });
    }, onError: (a) {

    }, onDone: () {

    });
  }


  gatewayVariant(ProductDetails2 productDetails, combination,Vendor shopDetails, variantName,step,type){



   bool gateway = false;
    if(step==2){
      for (var element in currentCart.value) {

        if(element.productId==productDetails.id && element.variantName==variantName) {
          gateway = true;
        }
      }
    }

     if(gateway==false){
       addToCartRestaurant(productDetails,combination, shopDetails, variantName, step);
     }else {
       incrementVariant(productDetails.id,variantName);
     }
  if(type=='variant') {
    Navigator.pop(context);
  }
  }

  finder(ProductDetails2 product){

    List<variantGroupModel> vGroup=  <variantGroupModel>[];

    List<AddonGroupModel> aGroup=  <AddonGroupModel>[];


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
        } else if(element.relation=='child'){
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
      List<AddonModel> gl=  <AddonModel>[];
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
    productData.id = product.id;
    productData.product_name = product.product_name;
    productData.product_name = product.product_name;
    productData.rating = product.rating;
    productData.ratingTotal = product.ratingTotal;
    productData.multipleVariant = product.multipleVariant;
    productData.image = product.image;
    productData.foodType = product.foodType;
    productData.description = product.description;
    productData.price = product.price;
    productData.strike = product.strike;
    productData.discount = product.discount;
    productData.packingCharge = product.packingCharge;
    productData.tax = product.tax;
    productData.availableType = product.availableType;
    productData.totalSteps = product.totalSteps;
    productData.defaultVariant = product.defaultVariant;
    productData.itemTiming = product.itemTiming;

    combinationFinder(product,variantGlobalName, 'direct');

  }

  combinationFinder(ProductDetails2 product, variantName, defaultSelect){
    List<CombinationVariantModel> cGroup= [];
    int i =1;

    for (var element in product.combinationVariant) {
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

    variantCalculation(productData,'first');
  }

  variantCalculation(ProductDetails2 product, String type){
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


  addToCartRestaurant(ProductDetails2 productDetail, combination ,Vendor shopDetails, variantName, step){

         CartResponse cartResponse = CartResponse();
         String cname;
         cartResponse.product_name = productDetail.product_name;

         if(productDetail.multipleVariant){
           cartResponse.variantName = variantName;
           cartResponse.price = variantTotalAmount;
           for (var element in productDetail.combinationVariant) {
             if(element.selected){
               cname = element.cname;
             }
           }

           for (var element in combination) {
             if(element.cname==cname){
               element.selected = true;
             }else {
               element.selected = false;
             }
           }
           cartResponse.combinationAllVariant = combination;
         }else{
           cartResponse.variantName = variantName;
           cartResponse.price = productDetail.price;
         }

         cartResponse.image = productDetail.image;
         cartResponse.productId = productDetail.id;
         cartResponse.strike = productDetail.strike;
         cartResponse.qty = productDetail.qty;

         cartResponse.userId = currentUser.value.id;
         cartResponse.tax = double.parse(productDetail.tax) * productDetail.qty;
         cartResponse.discount = productDetail.discount;
         cartResponse.packingCharge = double.parse(productDetail.packingCharge);
         cartResponse.foodType = productDetail.foodType;
         cartResponse.multipleVariant = productDetail.multipleVariant;
         cartResponse.defaultVariant = productDetail.defaultVariant;
         cartResponse.itemTiming = productDetail.itemTiming;
         cartResponse.availableType = productDetail.availableType;
         cartResponse.variantGroup = productDetail.variantGroup;


         cartResponse.combinationVariant = productDetail.combinationVariant;

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
         currentCheckout.value.vendor = shopDetails;
         currentCheckout.value.handoverTime =
             int.parse(currentVendor.value.handoverTime);

         // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
         currentCart.notifyListeners();
         setCurrentCartItem();

         setCurrentCheckout(currentCheckout.value);

         if (kDebugMode) {

           print(cartResponse.toMap());
         }



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

    Navigator.pop(context);
  }


  incrementVariant(productId,variantName) {
    for (var element in currentCart.value) {

      if(element.productId==productId && element.variantName==variantName) {

          element.qty = element.qty + 1;

      }
    }
// ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
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
    if(type=='variant') {
      Navigator.pop(context);
    }
  }




  clearCart(){
    currentCheckout.value.shopName = null;
    currentCheckout.value.shopTypeID = 0;
    currentCheckout.value.shopId = null;
    currentCart.value.clear();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentCart.notifyListeners();
    setCurrentCartItem();
    setCurrentCheckout(currentCheckout.value);
    toaster('Cart cleared',S.of(context).cart_cleared_successfully,'success');
   Navigator.pop(context);
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
}
