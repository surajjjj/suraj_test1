import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/explore_search.dart';
import '../models/main_category.dart';
import '../models/searchisresult.dart';
import '../repository/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../models/auto_suggestion.dart';
import '../models/vendor.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/trending.dart';
import '../models/slide.dart';
import '../repository/home_repository.dart';
import '../models/mastercategory_model.dart';
import '../repository/vendor_repository.dart' as repository;


class HomeController extends ControllerMVC {
  List<Slide> slides = <Slide>[];
  List<Slide> middleSlides = <Slide>[];
  List<Slide> fixedSlider = <Slide>[];
  List<Vendor>vendorList = <Vendor>[];
  List<Vendor>vendorSearch = <Vendor>[];
  List<Trending> trending = <Trending>[];
  List<MasterCategoryModel> categoryList= <MasterCategoryModel>[];
  List<SearchISResult> searchResultList= <SearchISResult>[];
  List<MainCategoryModel> mainShopCategories = <MainCategoryModel>[];

  List<Explore> exploreList = <Explore>[];
  bool loader = false;
  String searchState = 'no_data';
  bool pageLoader = true;
  bool notFound = false;
  List<ItemDetails> featuredProductList = <ItemDetails>[];
  List<ItemDetails> popularProductList = <ItemDetails>[];
  SearchISLResult searchResultData = SearchISLResult();
  String zoneDetect = 'no';
  bool itemNotFound=false;
  bool shopNotFound=false;




  Future<void> listenForSlidingProduct(type) async {

    setState(() => featuredProductList.clear());
    setState(() => popularProductList.clear());
    final Stream<ItemDetails> stream = await getSlidingProduct(type);
    stream.listen((ItemDetails list) {
     if(type=='featured') {
       setState(() => featuredProductList.add(list));
     }else if(type=='popular'){
       setState(() => popularProductList.add(list));
     }
    }, onError: (a) {

    }, onDone: () {

    });

  }





  Future<void> listenForVendorSearch(searchTxt) async {
    setState(() =>loader = true);
    setState(() => vendorSearch.clear());
    final Stream<Vendor> stream = await getTopVendorListSearch(searchTxt);
    stream.listen((Vendor list) {
      setState(() =>loader = false);
      setState(() => vendorSearch.add(list));
    }, onError: (a) {

    }, onDone: () {

    });
  }

  Future<void> listenForVendorItemSearch(searchTxt) async {
   if(searchTxt!='') {
     setState(() => searchState = 'finding');



     getTopVendorItemListSearch(searchTxt).then((value) {
       setState(() =>  searchResultData = value);
       if(searchResultData.vendor.isEmpty){

         setState(() => shopNotFound  = true);
       }

       if(searchResultData.item.isEmpty){
         setState(() =>  itemNotFound  = true);
       }
     }).catchError((e) {

     }).whenComplete(() {
       setState(() => searchState = 'find');




       if(searchResultData.vendor.isNotEmpty || searchResultData.item.isNotEmpty) {
         if (recentSearch.value.isNotEmpty) {
           bool notMatch = false;
           for (var element in recentSearch.value) {
             if (element.text == searchTxt) {
               notMatch = true;
             }
           }
           if (!notMatch) {
             AutoSuggestion recentSearchData = AutoSuggestion();
             recentSearchData.text = searchTxt;
             recentSearch.value.add(recentSearchData);
             setRecentSearch();
           }
         } else {
           AutoSuggestion recentSearchData = AutoSuggestion();
           recentSearchData.text = searchTxt;
           recentSearch.value.add(recentSearchData);
           setRecentSearch();
         }
       }

     });
   }
  }






  Future<void> listenForMasterCategory(type) async {
    setState(() => categoryList.clear());
    final Stream<MasterCategoryModel> stream = await getMasterCategory(type);
    stream.listen((MasterCategoryModel type) {
      setState(() => categoryList.add(type));
    }, onError: (a) {}, onDone: () {


    });
  }









  openMap(latitude,longitude) async{
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    // ignore: deprecated_member_use
    if (await canLaunch(googleUrl)) {
      // ignore: deprecated_member_use
    await launch(googleUrl);
    } else {
    throw 'Could not open the map.';
    }
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

  addToFavorite(id) async {

    if (currentUser.value.apiToken == null) {
      Navigator.of(context).pushReplacementNamed('/Login');
    } else {
      if (checkMyShopList(id) == false) {
        currentUser.value.favoriteShop.add(id);
        toaster('Added !',S.of(context).this_store_was_added_to_favorite,'success');


      } else {
        currentUser.value.favoriteShop.remove(id);
        toaster('Removed !',S.of(context).this_store_was_removed_to_favorite,'error');


      }
      repository.addFavoriteShop().then((value) {});
      Navigator.pop(context);
    }

  }



/*
  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  }

  Future<void> listenForShopType() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      setState(() => categories.add(_category));
    }, onError: (a) {
      print(a);
    }, onDone: () {});
  } */





  Future<void> listenForExplore() async {
    final Stream<Explore> stream = await getExplore();
    stream.listen((Explore interSort) {
      setState(() => exploreList.add(interSort));
    }, onError: (a) {

    }, onDone: () {});
  }


  listenForZone(){
    setState(() => middleSlides.clear());
    setState(() => slides.clear());
    setState(() => pageLoader = true,);

     getZoneId().then((value) {
          currentUser.value.zoneId = value;
          if(currentUser.value.zoneId=='no_matched'){
            zoneDetect = 'not_match';
          }else if(currentUser.value.zoneId!=''){
            zoneDetect = 'matched';
          }
          if (kDebugMode) {
            print(currentUser.value.zoneId);
          }
          setCurrentUser(currentUser.value);
    }).catchError((e) {

    }).whenComplete(() {
       setState(() => pageLoader = false,);
       listenForSlides(1);
       listenForSlidingProduct('featured');
       listenForSlidingProduct('popular');
       listenForMasterCategory('home');
       listenForVendorList('quick_on','no', 100);

    });
  }
  Future<void> listenForSlides(id) async {
    final Stream<Slide> stream = await getSlides(id);
    stream.listen((Slide slide) {
      setState(() => slides.add(slide));
    }, onError: (a) {

    }, onDone: () {});
  }

  Future<void> listenForVendorList( type,select, limit) async {
    setState(() => vendorList.clear());

    final Stream<Vendor> stream = await repository.getVendorList(type, select, limit);

    stream.listen((Vendor list) {
      setState(() => vendorList.add(list));
    }, onError: (a) {

    }, onDone: () {



        setState(() {
          if(vendorList.isEmpty ){
            notFound = true;
          }
        });

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
