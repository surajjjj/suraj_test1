import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../generated/l10n.dart';
import '../components/constants.dart';
import '../models/payment.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../Widget/custom_divider_view.dart';
import '../components/directions_model.dart';
import '../components/directions_repository.dart';
import '../helpers/helper.dart';
import '../repository/user_repository.dart';
import '../repository/order_repository.dart' as repository;

// ignore: must_be_immutable
class MapLiveTrack extends StatefulWidget {


  String orderId;
  String pageType;
  MapLiveTrack({Key key, this.orderId, this.pageType}) : super(key: key);

  @override
  MapLiveTrackState createState() => MapLiveTrackState();
}

class MapLiveTrackState extends State<MapLiveTrack>  with AfterLayoutMixin<MapLiveTrack> {
  final double _initFabHeight = 170.0;
  double _panelHeightOpen;
  final double _panelHeightClosed = 95.0;
  Payment paymentData =  Payment();
  String handoverTime = '0';

  OverlayEntry loader ;

  final _initialCameraPosition = CameraPosition(
    target: LatLng(currentUser.value.latitude, currentUser.value.longitude),
    zoom: 17.5,
  );

  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  Directions _info;
  String status;

  List<LatLng> latlng = <LatLng>[];
  bool timerLimit = true;
  BitmapDescriptor customIcon;
  @override
  void initState() {
    loader = Helper.overlayLoader(context);
    if(widget.pageType=='viewDetails'){
      timerLimit = false;
    }

    listenForPaymentDetails(widget.orderId);

    BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(5, 5)), 'assets/img/shop.png').then((d) {
      customIcon = d;

      getTrackDetails();
    });

    super.initState();

  }


  listenForPaymentDetails(id) async {

    repository.PaymentDetails(id).then((value) {

      setState(() { paymentData = value; });

    }).catchError((e) {

    }).whenComplete(() {

    });

  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();

  }

  getTrackDetails() {
    FirebaseFirestore.instance.collection("orderDetails").where("orderId", isEqualTo: widget.orderId).snapshots().listen((snapshot) {
      for (var result in snapshot.docs) {

        setState((){
          status = result.data()["status"];
        });
        if(result.data()["status"] == 'Completed'){
          // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);

        } else if(result.data()["status"] == 'Shipped'){

          BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(5, 5)), 'assets/img/deliveryboy.png').then((d) {
            setState((){
              customIcon = d;
            });

            LatLng driver = LatLng(result.data()["driverLatitude"], result.data()["driverLongitude"]);
            LatLng destination = LatLng(result.data()["originLatitude"], result.data()["originLongitude"]);
            latlng.add(driver);
            latlng.add(destination);
            _addMarker(driver);
            _addMarker(destination);


          });
        } else {
          handoverTime = result.data()["processingTime"].toString();
          LatLng driver = LatLng(result.data()["shopLatitude"], result.data()["shopLongitude"]);
          LatLng destination = LatLng(result.data()["originLatitude"], result.data()["originLongitude"]);
          latlng.add(driver);
          latlng.add(destination);
          _addMarker(driver);
          _addMarker(destination);
        }



      }
    });
  }





  Widget _panel(ScrollController sc) {

    var size = MediaQuery.of(context).size;
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child:Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius:const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
            ),
            child:ListView(
              controller: sc,
              children: <Widget>[

                Container(

                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),

                  ),

                  child:Container(
                      padding: const EdgeInsets.only(right:18,left:18,bottom: 15),

                      child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Icon(Icons.access_time_filled,color: Theme.of(context).primaryColorLight),
                                    ),
                                    Container(
                                        height: 15,
                                        color: Colors.white,
                                        padding: const EdgeInsets.all(3),
                                        child: Center(
                                            child: Text(
                                              'LIVE',
                                              style: TextStyle(fontSize: 7, color: Theme.of(context).primaryColorLight),
                                            ))),
                                  ],
                                ),

                                Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,

                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                                          child: Text(
                                            S.of(context).order_is_received,
                                            style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: Text(
                                            S.of(context).your_order_is_placed_successfully,
                                            style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).primaryColorLight.withOpacity(0.8))),
                                          ),
                                        ),
                                      ],
                                    )),
                                const Padding(
                                  padding: EdgeInsets.only(top: 30),
                                  child:  CircleAvatar(
                                    // ignore: deprecated_member_use
                                    backgroundImage: AssetImage('assets/img/united-states-of-america.png'),
                                    maxRadius: 25,

                                  ),




                                ),

                              ],
                            )


                          ]
                      )
                  ),
                ),
                Container(
                    height: size.height,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18.0),
                          topRight: Radius.circular(18.0)),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.1),
                          blurRadius: 1,
                          spreadRadius:0.5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(top:20,left:15,right:15),
                            padding: const EdgeInsets.only(top:10,bottom: 10,left:15,right:15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    width: 1,color: Theme.of(context).disabledColor.withOpacity(0.6)
                                )
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top:10),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.asset('assets/img/logo.png',
                                                    width: 50,height: 50,fit: BoxFit.fill,
                                                  )
                                              )
                                          ),

                                        ],
                                      ),

                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 10,),
                                                child: Text(
                                                    'Barbequeen restaurant is ',
                                                    style: Theme.of(context).textTheme.titleSmall
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                child: Text(
                                                    'Preparing your order',
                                                    style: Theme.of(context).textTheme.bodySmall
                                                ),
                                              ),
                                            ],
                                          )),
                                      Container(
                                          margin: const EdgeInsets.only(top:10),
                                          child: Icon(Icons.call,
                                            color: Theme.of(context).primaryColorDark,
                                          )




                                      ),

                                    ],
                                  ),),
                                const SizedBox(height: 10,),
                                const CustomDividerView(dividerHeight: 1,),
                                Container(
                                  margin: const EdgeInsets.only(top:10),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.asset('assets/img/logo.png',
                                                    width: 50,height: 50,fit: BoxFit.fill,
                                                  )
                                              )
                                          ),

                                        ],
                                      ),

                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10, right: 10,),
                                                child: Text(
                                                    'Santhose kumar is on the way to the restaurant to pick up your order',
                                                    style: Theme.of(context).textTheme.titleSmall
                                                ),
                                              ),
                                              Wrap(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.only(top:10, left: 10, right: 5),
                                                    child: Text(
                                                        'partner has been vacinated',
                                                        style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:customeColor1))
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: const EdgeInsets.only(right: 10,top:16),
                                                    child: Icon(Icons.arrow_forward_ios,
                                                        size: 15,
                                                        color:customeColor1
                                                    ),
                                                  )
                                                ],
                                              ),


                                              const SizedBox(height: 10,),

                                            ],
                                          )),


                                      Container(
                                          margin: const EdgeInsets.only(top:10),
                                          child: Icon(Icons.call,
                                            color: Theme.of(context).primaryColorDark,
                                          )




                                      ),

                                    ],
                                  ),),

                                const SizedBox(height: 10,),
                                const CustomDividerView(dividerHeight: 1,),
                                const SizedBox(height: 10,),
                                Row(
                                    children:[
                                      Icon(Icons.check,size:15,color: greyColor1),
                                      Expanded(
                                          child: Container(
                                            padding:  const EdgeInsets.only(left:4),
                                            child: Text('delivery Instructions',
                                              style: Theme.of(context).textTheme.titleSmall,
                                            ),
                                          )
                                      ),
                                      InkWell(
                                        onTap:(){},
                                        child: Icon(Icons.add_box,color: Theme.of(context).primaryColorDark,),
                                      )
                                    ]
                                ),
                                Container(
                                    padding: const EdgeInsets.only(left:0,top:5,bottom: 10),
                                    child:Text('delivery partner will avoid ringing the doorbell',
                                      style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color: greyColor1)),
                                      overflow: TextOverflow.ellipsis,maxLines: 1,
                                    )
                                ),

                              ],
                            )
                        ),



                        Container(
                            decoration:BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                            child:Container(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(S.of(context).bill_details, style: Theme.of(context).textTheme.titleSmall),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Order id1', style: Theme.of(context).textTheme.titleSmall),
                                      Text('#${widget.orderId}', style: Theme.of(context).textTheme.titleSmall),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(S.of(context).item_total, style: Theme.of(context).textTheme.titleSmall),
                                      Text(Helper.pricePrint(paymentData.sub_total.toString()), style: Theme.of(context).textTheme.titleSmall),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(S.of(context).discount, style: const TextStyle(color: Colors.green)),
                                      Text(Helper.pricePrint(paymentData.discount.toString()),
                                          style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color: Colors.green))),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[


                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(Helper.pricePrint(paymentData.delivery_fees.toString()) , style: const TextStyle(color: Colors.blue)),


                                                Text(S.of(context).free, style: Theme.of(context).textTheme.titleSmall),
                                              ],
                                            ),


                                            const SizedBox(height: 10),


                                            Container(
                                                padding: const EdgeInsets.only(bottom:10),
                                                child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Text(S.of(context).packaging_charge, style: Theme.of(context).textTheme.bodySmall),
                                                    Text(Helper.pricePrint(paymentData.packingCharge.toString()), style: Theme.of(context).textTheme.bodySmall),
                                                  ],
                                                )

                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(S.of(context).tax,
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                ),
                                                Text(Helper.pricePrint(paymentData.tax.toString()),
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                ),
                                              ],
                                            ),


                                            const SizedBox(height: 5),
                                            Text('${S.of(context).you_save}   ${S.of(context).on_this_order}',
                                                style: Theme.of(context).textTheme.bodySmall),




                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  const SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(S.of(context).delivery_tip, style: Theme.of(context).textTheme.titleSmall),
                                      Text(Helper.pricePrint(paymentData.delivery_tips.toString()), style: Theme.of(context).textTheme.titleSmall),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          S.of(context).to_pay,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        const Spacer(),
                                        Text(
                                          Helper.pricePrint(paymentData.grand_total.toString()),
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                        )

                      ],
                    )
                ),





              ],
            )
        )

    );
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .85;
    return  WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        return false;
      },
      child:Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.primary
          ),
          centerTitle: true,
          title: Text(
            'Rasikas Restaurant',
            style: Theme.of(context).textTheme.displayMedium.merge(TextStyle(letterSpacing: 1.3,color:Theme.of(context).colorScheme.primary)),
          ),
        ),
        body: Stack(
//        fit: StackFit.expand,
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            SlidingUpPanel(
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: .5,
              panelBuilder: (sc) => _panel(sc),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              body: GoogleMap(
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
              onPanelSlide: (double pos) => setState(() {
                pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
              }),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    color: Colors.green,
                    width: double.infinity,
                    height: 80,
                    child:Column(
                      children: [

                        Text('Preparing your order',
                          style: Theme.of(context).textTheme.headlineSmall.merge(TextStyle(color: Theme.of(context).colorScheme.primary)),
                        ),

                        Container(

                            margin:const EdgeInsets.only(top:10,left: 15,right:15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child:Wrap(
                              children: [
                                Div(
                                    colS:5,
                                    colM:5,
                                    colL:5,
                                    child: Container(
                                        alignment: Alignment.center,
                                        decoration:BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                  width: 1,color: Theme.of(context).primaryColor.withOpacity(0.3),
                                                )
                                            )
                                        ),
                                        child:Container(
                                            padding: const EdgeInsets.all(10),
                                            child:Wrap(
                                              children: [
                                                Container(
                                                    padding: const EdgeInsets.only(right:10),
                                                    child:Icon(EvaIcons.clockOutline,color: Theme.of(context).colorScheme.primary,)
                                                ),
                                                Container(
                                                    margin: const EdgeInsets.only(top:1),
                                                    child:Text('On Time',
                                                      style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                                    )
                                                )
                                              ],
                                            )
                                        )

                                    )
                                ),
                                Div(
                                    colS:7,
                                    colM:7,
                                    colL:7,
                                    child: Container(
                                        alignment: Alignment.center,

                                        child:Container(
                                            padding: const EdgeInsets.all(10),
                                            child:  Container(
                                                margin: const EdgeInsets.only(top:1),
                                                child:Text('Arriving in ${_info?.totalDuration??''} ',
                                                  style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                                )
                                            )
                                        )

                                    )
                                ),
                              ],
                            )
                        ),
                      ],
                    )
                ),
              ],
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
        /*print(customIcon);*/
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

  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout

    if (currentUser.value.apiToken != null) {



    }
  }






}
