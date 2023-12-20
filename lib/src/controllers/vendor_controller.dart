
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodzo/src/models/shop_info_model.dart';
import '../models/coupon.dart';
import '../models/product_details2.dart';
import '../models/slide.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/category.dart';
import '../repository/vendor_repository.dart' as repository;
import '../models/mastersubcategory_model.dart';
import '../repository/home_repository.dart';
import '../models/restaurant_product.dart';
import '../repository/vendor_repository.dart';
import '../models/vendor.dart';

class VendorController extends ControllerMVC {
  List<Vendor> vendorList = <Vendor>[];
  List<Vendor> tempVendorList = <Vendor>[];
  List<Category> categories = <Category>[];
  List<Slide> middleSlides = <Slide>[];
  ShopInfoModel shopInfoDetails = ShopInfoModel();
  List<ProductDetails2> productSlide = <ProductDetails2>[];
  List<RestaurantProduct> vendorResProductList = <RestaurantProduct>[];
  List<RestaurantProduct> tempVendorResProductList = <RestaurantProduct>[];
  List<MasterSubCategoryModel> subcategoryList= <MasterSubCategoryModel>[];
  List<CouponModel> couponList = <CouponModel>[];
  List<Tab> globeTabs = [];
  bool notFound = false;
  String todayDeals;
  String middleSidleLock;
  VendorController();

  Future<void> listenForVendorList( type,select, limit) async {
    setState(() => notFound = false);
    setState(() => vendorList.clear());
    setState(() => tempVendorList.clear());
    final Stream<Vendor> stream = await getVendorList(type, select, limit);

    stream.listen((Vendor list) {
      setState(() => vendorList.add(list));
      setState(() => tempVendorList.add(list));

    }, onError: (a) {

    }, onDone: () {

      setState(() {
        if(tempVendorList.isEmpty ){
          notFound = true;
        }
      });
    });
  }

  Future<void> listenForVendorListOffer(shopType, offerType, offer,shopTypeId ) async {

    final Stream<Vendor> stream = await getVendorListOffer(shopType, offerType, offer, shopTypeId);

    stream.listen((Vendor list) {
      setState(() => vendorList.add(list));

    }, onError: (a) {

    }, onDone: () {
      for (var element in vendorList) {

        setState(() {
          if(element.shopId=='no_data' || element.shopId=='not_found'){

            notFound = true;
          }

        });
      }
    });
  }




  Future<void> listenForOffers(shopId) async {
    final Stream<CouponModel> stream = await getCoupons(shopId);
    stream.listen((CouponModel category) {
      setState(() => couponList.add(category));
    }, onError: (a) {

    }, onDone: () {});
  }


  Future<void> listenForRestaurantProduct(int shopType, loaderTest) async {
    final Stream<RestaurantProduct> stream = await get_restaurantProduct(shopType);

    stream.listen((RestaurantProduct list) {
      setState(() => vendorResProductList.add(list));



    }, onError: (a) {

    }, onDone: () {
      loaderTest();
      tempVendorResProductList  = productFilter(vendorResProductList,'All');
    });
  }







  Future<void> listenForMiddleSlidesVideo(id) async {
    final Stream<Slide> stream = await getVendorSlides(id);
    stream.listen((Slide slide) {
      setState(() => middleSlides.add(slide));
    }, onError: (a) {

    }, onDone: () {
      setState(() {
        middleSidleLock = middleSlides[0].id;
      });
    });
  }



  void listenForFavoritesShop() async {
    final Stream<Vendor> stream = await getFavoritesShop();
    stream.listen((Vendor favorite) {
      setState(() {
        vendorList.add(favorite);
      });
    }, onError: (a) {
      // ignore: deprecated_member_use

    }, onDone: () {

      for (var element in vendorList) {

        setState(() {


          if(element.shopId=='not_found'){
            notFound = true;
          }

        });
      }
    });
  }

  void listenForVendorSlide({String id}) async {
    final Stream<ProductDetails2> stream = await getShopProductSlide(id);
    stream.listen((ProductDetails2 list) {
      setState(() {
        productSlide.add(list);
      });
    }, onError: (a) {
      // ignore: deprecated_member_use

    }, onDone: () {

      setState(() {
        todayDeals = productSlide[0].id;
      });

    });
  }

  Future<void> listenForMasterSubCategory(type) async {
    setState(() => subcategoryList.clear());
    final Stream<MasterSubCategoryModel> stream = await getMasterSubCategory(type);
    stream.listen((MasterSubCategoryModel type) {
      setState(() => subcategoryList.add(type));
    }, onError: (a) {}, onDone: () {


    });
  }


  shopFilter(List<Vendor> list,type){
    List<Vendor> tempList = list;
    List<Vendor> dataList = <Vendor>[];
    if(type=='Takeaway') {
      for (var element in tempList) {
        if (element.takeaway) {
          dataList.add(element);
        }
      }
    } else if(type=='All') {
      dataList = tempList;
    } else if(type=='Opened Shop'){
      for (var element in tempList) {
        if (Helper.shopOpenStatus(element)) {
          dataList.add(element);
        }
      }

    } else if(type=='Rating'){

      tempList.sort((a, b) {
        double aValue = double.parse(a.ratingTotal.replaceAll(',',''));
        double bValue = double.parse(b.ratingTotal.replaceAll(',',''));
        return aValue.toInt() - bValue.toInt() ;

      });
      dataList = tempList.reversed.toList();

    } else if(type=='Distance'){
      tempList.sort((a, b) {
        double aValue = double.parse(a.distance.replaceAll(',',''));
        double bValue = double.parse(b.distance.replaceAll(',',''));
        return aValue.toInt() - bValue.toInt() ;

      });
      dataList = tempList;
    }else if(type =='Delivery Time'){
      tempList.sort((a, b) {
        double aValue = double.parse(Helper.calculateTime(double.parse(a.distance.replaceAll(',','')),int.parse(a.handoverTime),true));
        double bValue = double.parse(Helper.calculateTime(double.parse(b.distance.replaceAll(',','')),int.parse(b.handoverTime),true));
        return aValue.toInt() - bValue.toInt() ;

      });
      dataList = tempList;
    }

    return dataList;
  }

  addToFavorite(id) async {

    if (currentUser.value.apiToken == null) {
      Navigator.of(context).pushNamed('/Login');
    } else {
      if (checkMyShopList(id) == false) {
        currentUser.value.favoriteShop.add(id);
       toaster('Add Successfully !',S.of(context).this_store_was_added_to_favorite,'success');


      } else {
        currentUser.value.favoriteShop.remove(id);
       toaster('Removed Successfully !',S.of(context).this_store_was_removed_to_favorite,'success');

      }
     repository.addFavoriteShop().then((value) {});

    }

  }

  productFilter(List<RestaurantProduct> vendorResProductList, type){

    List<RestaurantProduct> tempVendorProductList = <RestaurantProduct>[];
    if(type=='All'){
      tempVendorProductList = vendorResProductList;
    }else if(type=='Veg'){

      for (var element in vendorResProductList) {

        RestaurantProduct productList =  RestaurantProduct();
        List<ProductDetails2> pList = <ProductDetails2>[];
          for (var element1 in element.productdetails) {

                if(element1.foodType=='Veg'){
                  ProductDetails2 productDetails = ProductDetails2();
                  productDetails = element1;
                  pList.add(productDetails);

                }
          }
          if( pList.isNotEmpty) {

            productList.id = element.id;
            productList.image = element.image;
            productList.category_name = element.category_name;
            productList.productdetails = pList;

            tempVendorProductList.add(productList);

          }

      }
    }else if(type=='Non_Veg'){
      for (var element in vendorResProductList) {
        RestaurantProduct productList =  RestaurantProduct();
        List<ProductDetails2> pList = <ProductDetails2>[];
        for (var element1 in element.productdetails) {

          if(element1.foodType=='NON Veg'){
            ProductDetails2 productDetails = ProductDetails2();
            productDetails = element1;
            pList.add(productDetails);

          }
        }
        if( pList.isNotEmpty) {

          productList.id = element.id;
          productList.image = element.image;
          productList.category_name = element.category_name;
          productList.productdetails = pList;
          tempVendorProductList.add(productList);
        }

      }
    }

    return tempVendorProductList;
  }

  tabMaker() {
    List<Tab> tabs = [];

    for (var element in tempVendorResProductList) {

      tabs.add(Tab(
        text: element.category_name,
      ));
    }


     return tabs;
  }
  checkMyShopList(id){
    String res;
    if( currentUser.value.favoriteShop.isNotEmpty) {

      for (var element in currentUser.value.favoriteShop) {
        if (element == id) {
          res = 'yes';
        }
      }
    }
    if (res == 'yes') {
      return true;
    } else {
      return false;

    }
  }


  Future<void> listenShopInfo(id) async {


    getShopInfo(id).then((value) {
      setState(() {
        shopInfoDetails = value;
      });
      }).catchError((e) {

      }).whenComplete(() {

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



}
