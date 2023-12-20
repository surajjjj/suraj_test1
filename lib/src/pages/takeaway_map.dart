
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/directions_model.dart';
import '../components/directions_repository.dart';
import '../repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../controllers/map_controller.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../generated/l10n.dart';

import '../components/Shimmer/rectangular_loader_widget.dart';
// ignore: must_be_immutable
class TakeawayWidget extends StatefulWidget {

  final GlobalKey<ScaffoldState> parentScaffoldKey;
  String orderId;

  TakeawayWidget({Key key, this.parentScaffoldKey, this.orderId}) : super(key: key);

  @override
  TakeawayWidgetState createState() => TakeawayWidgetState();
}

class TakeawayWidgetState extends StateMVC<TakeawayWidget> {
  MapController _con;

  TakeawayWidgetState() : super(MapController()) {
    _con = controller;
  }
  List<LatLng> latlng = <LatLng>[];
  bool timerLimit = true;
  BitmapDescriptor customIcon;
  Marker _origin;
  Marker _destination;
  Directions _info;
  GoogleMapController _googleMapController;
  int track;
  @override
  void initState() {
   /* _con.currentMarket = widget.routeArgument?.param as Market;
    if (_con.currentMarket?.latitude != null) {
      // user select a market
      _con.getMarketLocation();
      _con.getDirectionSteps();
    } else {
      _con.getCurrentLocation();
    } */
    _con.getTakeaway(widget.orderId);
    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(5, 5)), 'assets/img/shop.png').then((d) {
      customIcon = d;

      getTrackDetails();
    });
    super.initState();
  }
  final _initialCameraPosition = CameraPosition(
    target: LatLng(currentUser.value.latitude, currentUser.value.longitude),
    zoom: 17.5,
  );

  getTrackDetails() {
    FirebaseFirestore.instance.collection("orderDetails").where("orderId", isEqualTo: widget.orderId).snapshots().listen((snapshot) {
      for (var result in snapshot.docs) {


          BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(5, 5)), 'assets/img/deliveryboy.png').then((d) {
            setState((){
              customIcon = d;
            });

            LatLng driver = LatLng(result.data()["shopLatitude"], result.data()["shopLongitude"]);
            LatLng destination = LatLng(currentUser.value.latitude, currentUser.value.longitude);
            latlng.add(driver);
            latlng.add(destination);
            _addMarker(driver);
            _addMarker(destination);

          });
          if(result.data()["status"]=='Placed'){
            track =  1;
          } else if(result.data()["status"]=='Accepted'){
            track =  2;
          }else if(result.data()["status"]=='Packed'){
            track =  3;
          }else if(result.data()["status"]=='RShipped'){
            track =  4;
          }else if(result.data()["status"]=='Delivered'){
            track =  5;
          }

          setState(() {
            track = track;
          });


      }
    });
  }
  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  Future<void> goCurrentLocation() async {




    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(currentUser.value.latitude,currentUser.value.longitude),
      zoom: 14.4746,
    )));

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
      return false;
    },
    child:Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Theme.of(context).hintColor),
                onPressed: () => Navigator.of(context).pushNamed('/Pages', arguments: 2),
              ),
        title: Text(
            S.of(context).explorer,
          style: Theme.of(context).textTheme.displayMedium
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.my_location,
              color: Theme.of(context).hintColor,
            ),
            onPressed: () {
            goCurrentLocation();
            },
          ),

        ],
      ),
      body: _con.pageLoader?const RectangularLoaderWidget():Stack(
//        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomStart,
        children: <Widget>[
        GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: {if (_origin != null) _origin, if (_destination != null) _destination},
        polylines: {
          if (_info != null)
            Polyline(
              polylineId: const PolylineId('overview_polyline'),
              color: Colors.black,
              width: 4,
              points: _info.polylinePoints.map((e) => LatLng(e.latitude, e.longitude)).toList(),
            ),
        },
      ),


          Column(
              mainAxisAlignment: MainAxisAlignment.start,
            children:[

              Container(
                padding: const EdgeInsets.only(top:20,left:10,right:10),
                child:Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(7)
                  ),
                height: 120,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(bottom:20,left:10),
                          child:Row(
                          children:[
                            TimelineTile(
                              axis: TimelineAxis.horizontal,
                              alignment: TimelineAlign.center,
                              isFirst: true,
                              indicatorStyle:IndicatorStyle(
                                width: 15,height:15,
                                indicator: Container(
                                  decoration:BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: track>=1?Colors.green:Colors.grey,
                                  ),

                                ),
                                color: Colors.grey,
                              ),
                              beforeLineStyle: LineStyle(
                                color: track>=1?Colors.green:Colors.grey,
                                thickness: 6,
                              ),

                              endChild: Text(S.of(context).order_placed,
                              style: Theme.of(context).textTheme.bodySmall.merge(
                                TextStyle(color: track>=1?Colors.green:Colors.grey)
                              ),
                              ),
                            ),

                            TimelineTile(
                                axis: TimelineAxis.horizontal,
                                alignment: TimelineAlign.center,
                                indicatorStyle:IndicatorStyle(
                                    width: 15,height:15,
                                  color: track>=2?Colors.green:Colors.grey,
                                ),
                                beforeLineStyle: LineStyle(
                                  color: track>=2?Colors.green:Colors.grey,
                                  thickness: 6,
                                ),
                                afterLineStyle:LineStyle(
                                  color: track>=2?Colors.green:Colors.grey,
                                  thickness: 6,
                                ),
                                endChild: SizedBox(
                                  width:80,
                                  child:Text(S.of(context).confirm_order,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodySmall
                                  ),
                                )
                            ),
                            TimelineTile(
                                axis: TimelineAxis.horizontal,
                                alignment: TimelineAlign.center,
                                indicatorStyle:IndicatorStyle(
                                    width: 15,height:15,
                                  color: track>=3?Colors.green:Colors.grey,
                                ),
                                beforeLineStyle: LineStyle(
                                  color: track>=3?Colors.green:Colors.grey,
                                  thickness: 6,
                                ),
                                afterLineStyle:LineStyle(
                                  color: track>=3?Colors.green:Colors.grey,
                                  thickness: 6,
                                ),
                                endChild: SizedBox(
                                  width:80,
                                  child:Text(S.of(context).preparing,
                                    textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodySmall
                                  ),
                                )
                            ),
                            TimelineTile(
                                axis: TimelineAxis.horizontal,
                                alignment: TimelineAlign.center,
                                indicatorStyle:IndicatorStyle(
                                  width: 15,height:15,
                                  color: track>=4?Colors.green:Colors.grey,
                                ),
                                beforeLineStyle: LineStyle(
                                  color: track>=4?Colors.green:Colors.grey,
                                  thickness: 6,
                                ),
                                afterLineStyle:LineStyle(
                                  color: track>=4?Colors.green:Colors.grey,
                                  thickness: 6,
                                ),
                                endChild: SizedBox(
                                  width:80,
                                  child:Text(S.of(context).ready_for_handover,
                                    textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodySmall
                                  ),
                                )
                            ),
                            TimelineTile(
                                axis: TimelineAxis.horizontal,
                                alignment: TimelineAlign.center,
                                isLast: true,
                                indicatorStyle:IndicatorStyle(
                                  width: 15,height:15,
                                  color: track>=5?Colors.green:Colors.grey,
                                ),

                                beforeLineStyle:LineStyle(
                                  color: track>=5?Colors.green:Colors.grey,
                                  thickness: 6,
                                ),

                                endChild: SizedBox(
                                  width:80,
                                  child:Text(S.of(context).delivered,
                                    textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodySmall
                                  ),
                                )
                            ),

                          ]
                      ))



                    ]
                  ),





              ),),

            ]
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children:[
              Container(
                  margin: const EdgeInsets.all(10),
                  child: Stack(
                    clipBehavior: Clip.none, alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        height:215,
                        width:double.infinity,
                        padding: const EdgeInsets.only(top:0
                        ),

                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5.0,
                                spreadRadius: 1.0,
                              ),
                            ]
                        ),

                        child: Column(

                          children: <Widget>[

                            Container(
                                padding: const EdgeInsets.only(top:30,right:25,left:25),
                                child:Text(_con.takeawayData.shopName,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:Theme.of(context).textTheme.titleSmall
                                )
                            ),

                            Container(
                              padding: const EdgeInsets.only(top:5),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children:[
                                    SmoothStarRating(
                                        allowHalfRating: false,
                                        starCount: 5,
                                        rating: double.parse(_con.takeawayData.ratingNum),
                                        size: 15.0,
                                        color: const Color(0xFFFEBF00),
                                        borderColor: const Color(0xFFFEBF00),
                                        spacing: 0.0),
                                        const SizedBox(width:5),
                                       Text('(${_con.takeawayData.ratingNum})',
                                         style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(height: 1.1)),
                                       ),
                                    const SizedBox(width:20),

                                 /*   InkWell(
                                      onTap: (){},
                                    child: Container(
                                        padding: EdgeInsets.all(3),
                                        decoration:BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                        child:Center(
                                            child:Icon(Icons.call,color:Theme.of(context).primaryColorLight,size:18)
                                        )
                                    )
                                    ), */


                                  ]
                              ),),
                            Container(
                                padding: const EdgeInsets.only(top:10),
                                child:Text(S.of(context).trip_route,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style:Theme.of(context).textTheme.titleSmall
                                )
                            ),
                            Container(
                              color: Theme.of(context).primaryColor,
                              padding: const EdgeInsets.only(left: 30, bottom: 10,right:30, top: 20),
                              child:Wrap(
                              children: [
                                Div(
                                colS:3,
                                colM:3,
                                colL:3,
                                  child:Container(
                                    padding: const EdgeInsets.only(right:10),
                                    child:Text(currentUser.value.name,
                                     overflow: TextOverflow.ellipsis,maxLines: 2,
                                    ),
                                  ),
                              ),
                                Div(
                                  colS:5,
                                  colM:5,
                                  colL:5,
                                  child: Container(
                                      padding: const EdgeInsets.only(top:3.5),
                                      child:Wrap(
                                    children: [
                                      Container(
                                        width: 100,
                                          padding: const EdgeInsets.only(top:6),
                                          child:DottedLine(
                                            direction: Axis.horizontal,
                                            lineLength: double.infinity,
                                            lineThickness: 1.0,
                                            dashLength: 4.0,
                                            dashColor: Theme.of(context).primaryColorDark,
                                            dashRadius: 0.0,
                                            dashGapLength: 4.0,
                                            dashGapColor: Colors.transparent,
                                            dashGapRadius: 0.0,
                                          )
                                      ),
                                      Icon(Icons.circle,color:Theme.of(context).primaryColorDark,size:12),
                                    ],
                                  ))
                                ),
                                Div(
                                  colS:4,
                                  colM:4,
                                  colL:4,
                                  child:Container(
                                    padding: const EdgeInsets.only(right:10),
                                    child:Text(S.of(context).shop,
                                      overflow: TextOverflow.ellipsis,maxLines: 2,
                                    ),
                                  ),
                                ),

                              ],
                              )


                            ),
                            Container(
                              padding: const EdgeInsets.only(top:10,right:25,left:25),
                              child:Row(
                                  children:[
                                    Expanded(
                                        child:Container(
                                            padding: const EdgeInsets.only(right:15,),
                                            child:Text(_con.takeawayData.shopAddress,
                                            overflow: TextOverflow.ellipsis,maxLines: 2,
                                            )
                                        )
                                    ),
                                    InkWell(
                                      onTap: (){
                                        _con.openMap( _con.takeawayData.shopLatitude,  _con.takeawayData.shopLongitude);
                                      },
                                      child: Icon(Icons.directions,color:Theme.of(context).primaryColorDark),
                                    )
                                  ]
                              ),
                            ),







                          ],
                        ),

                      ),

                      Positioned(
                        top:-40,
                        child: Container(
                            margin: const EdgeInsets.only(top:10),
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color:Colors.white,
                            ),


                            height: 59,
                            width:59,
                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child:Image(

                                image: NetworkImage(
                                  _con.takeawayData.shopLogo,

                                ),
                                height: 59,width:59,
                                fit: BoxFit.fill,
                              ),
                            )


                        ),
                      ),

                    ],
                  )),

            ]
          ),

        ],
      ),
    ),);
  }

  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('origin'),
          infoWindow: const InfoWindow(title: 'Origin'),
          icon: customIcon,
          position: pos,
        );
        // Reset destination
        _destination = null;

        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsRepository().getDirections(origin: _origin.position, destination: pos);
      setState(() => _info = directions);
    }
  }
}
