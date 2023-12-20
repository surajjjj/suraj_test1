import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/mastercategory_model.dart';
import '../models/takeaway.dart';
import '../models/vendor.dart';
import 'package:url_launcher/url_launcher.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../repository/market_repository.dart';
import '../repository/market_repository.dart' as repository;

class MapController extends ControllerMVC {

  List<Vendor> topMarkets = <Vendor>[];

  List<Marker> allMarkers = <Marker>[];
  List<Marker> allProviderMarkers = <Marker>[];
  Address currentAddress;
  Set<Polyline> polylines = {};
  TakeawayModel takeawayData = TakeawayModel();
  List<MasterCategoryModel> shopTypeList= <MasterCategoryModel>[];
  CameraPosition cameraPosition;
  // MapsUtil mapsUtil = new MapsUtil();
  Completer<GoogleMapController> mapController = Completer();
  OverlayEntry loader;
  bool pageLoader = true;

  MapController() {

    loader = Helper.overlayLoader(context);
  }

  void listenForNearMarkets(Address myLocation, Address areaLocation) async {
    final Stream<Vendor> stream = await getNearMarkets(myLocation, areaLocation,'');
    stream.listen((Vendor market) {
      // Helper.calculateDistance();


      setState(() {
        if (market.logo != null) {
          topMarkets.add(market);
        }
      });
      Helper.getMarker(market.toMap()).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    }, onError: (a) {}, onDone: () {});
  }

  void listenForNearMarketsWithID(Address myLocation, Address areaLocation, id) async {
    setState(() {
      topMarkets.clear();
    });

    final Stream<Vendor> stream = await getNearMarkets(myLocation, areaLocation,id);
    stream.listen((Vendor market) {
      // Helper.calculateDistance();


      setState(() {
        if (market.logo != null) {
          topMarkets.add(market);
        }
      });
      Helper.getMarker(market.toMap()).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    }, onError: (a) {}, onDone: () {});
  }

  void getCurrentLocation() async {
    try {

      setState(() {

        cameraPosition = CameraPosition(
          target: LatLng(currentUser.value.latitude, currentUser.value.longitude),
          zoom: 14.4746,
        );

      });

      Helper.getMyPositionMarker(currentUser.value.latitude,currentUser.value.longitude).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {

      }
    }
  }


  void getTakeaway(id) async {

    repository.getTakeawayDetail(id).then((value) {
      setState(() {
        takeawayData = value;
        pageLoader = false;
      });
    }).whenComplete(() {

    });
  }

  openMap(latitude,longitude) async{
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await
    // ignore: deprecated_member_use
    canLaunch(googleUrl)) {
      // ignore: deprecated_member_use
      await launch(googleUrl);
    } else {

      throw 'Could not open the map.';
    }
  }



  void getMarketLocation() async {
    try {

      setState(() {
        cameraPosition = CameraPosition(
          target: LatLng(currentUser.value.latitude, currentUser.value.longitude),
          zoom:  17.5,
        );
      });
      Helper.getMyPositionMarker(currentUser.value.latitude, currentUser.value.longitude).then((marker) {
        setState(() {
          allMarkers.add(marker);
        });
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {

      }
    }
  }




  Future<void> goCurrentLocation() async {
    final GoogleMapController controller = await mapController.future;



    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentUser.value.latitude,currentUser.value.longitude),
      zoom: 14.4746,
    )));

  }

  void getMarketsOfArea() async {
    setState(() {
      topMarkets = <Vendor>[];
      Address areaAddress = Address.fromJSON({"latitude": currentUser.value.latitude, "longitude": currentUser.value.longitude});
      if (cameraPosition != null) {
        listenForNearMarkets(currentAddress, areaAddress);
      } else {
        listenForNearMarkets(currentAddress, currentAddress);
      }
    });
  }



  /*
  void getDirectionSteps() async {
    currentAddress = await sett.getCurrentLocation();
    mapsUtil
        .get("origin=" +
            currentAddress.latitude.toString() +
            "," +
            currentAddress.longitude.toString() +
            "&destination=" +
            currentMarket.latitude +
            "," +
            currentMarket.longitude +
            "&key=${sett.setting.value?.googleMapsKey}")
        .then((dynamic res) {
      if (res != null) {
        List<LatLng> _latLng = res as List<LatLng>;
        _latLng?.insert(0, new LatLng(currentAddress.latitude, currentAddress.longitude));
        setState(() {
          polylines.add(new Polyline(
              visible: true,
              polylineId: new PolylineId(currentAddress.hashCode.toString()),
              points: _latLng,
              color: config.Colors().mainColor(0.8),
              width: 6));
        });
      }
    });
  }
 */
  Future refreshMap() async {
    setState(() {
      topMarkets = <Vendor>[];
    });
    //  listenForNearMarkets(currentAddress, currentAddress);
  }

  Future<void> listenForShopType() async {
    final Stream<MasterCategoryModel> stream = await getShopType();
    stream.listen((MasterCategoryModel type) {
      setState(() => shopTypeList.add(type));
    }, onError: (a) {}, onDone: () {

    });
  }


}
