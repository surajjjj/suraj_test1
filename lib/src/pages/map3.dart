import 'package:after_layout/after_layout.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:foodzo/src/models/livemap_details.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../generated/l10n.dart';
import '../components/constants.dart';
import '../components/points_clipper.dart';
import '../elements/checkout_list_widget.dart';
import '../models/payment.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../Widget/custom_divider_view.dart';
import '../components/directions_model.dart';
import '../components/directions_repository.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import '../repository/order_repository.dart' as repository;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'cancel.dart';
// ignore: must_be_immutable
class MapLiveTrack extends StatefulWidget {


  String orderId;
  String pageType;
  String vendorId;
  MapLiveTrack({Key key, this.orderId, this.pageType}) : super(key: key);

  @override
  State<MapLiveTrack> createState() => _MapLiveTrackState();
}

class _MapLiveTrackState extends State<MapLiveTrack>  with AfterLayoutMixin<MapLiveTrack> {
  final double _initFabHeight = 170.0;
  double _panelHeightOpen;
  final double _panelHeightClosed = 95.0;
  Payment paymentData =  Payment();
  LiveMapDetailModel liveMapDetails =  LiveMapDetailModel();
  String handoverTime = '0';
  String vendorName;
  String vendorId;
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
    listenForLiveMapDetails(widget.orderId);

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

  listenForLiveMapDetails(id) async {

    repository.LiveMapDetails(id).then((value) {

      setState(() { liveMapDetails = value; });

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
          vendorName =  result.data()["shopName"];
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


  _callNumber(number) async{
    //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  final int _duration = setting.value.cancel_timer;
  final CountDownController _controller = CountDownController();

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

       StreamBuilder(
       stream: FirebaseFirestore.instance.collection("orderDetails").where("orderId", isEqualTo: widget.orderId).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.data == null) return const CircularProgressIndicator();
             return Container(
               decoration: const BoxDecoration(
                 borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(18.0),
                     topRight: Radius.circular(18.0)),
               ),

               child:  snapshot.data.docs[0]['status']=='Placed'?Container(
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
                                   child: Icon(Icons.access_time_filled,color: Theme.of(context).colorScheme.primary),
                                 ),

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
                                 backgroundImage: AssetImage('assets/img/order_image.png'),
                                 maxRadius: 25,

                               ),




                             ),

                           ],
                         )


                       ]
                   )
               ):snapshot.data.docs[0]['status']=='Accepted'?Container(
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

                               ],
                             ),

                             Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,

                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                                       child: Text(
                                         S.of(context).order_is_being_prepared,
                                         style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight)),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(
                                         left: 10,
                                         right: 10,
                                       ),
                                       child: Text(
                                         S.of(context).your_order_is_being_prepared_now,
                                         style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).primaryColorLight.withOpacity(0.8))),
                                       ),
                                     ),
                                   ],
                                 )),
                             const Padding(
                               padding: EdgeInsets.only(top: 30),
                               child:  CircleAvatar(
                                 // ignore: deprecated_member_use
                                 backgroundImage: AssetImage('assets/img/indiaflag.png'),
                                 maxRadius: 25,

                               ),




                             ),

                           ],
                         )


                       ]
                   )
               ):snapshot.data.docs[0]['status']=='Packed'?Container(
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
                                   child: Icon(Icons.access_time_filled,color: Theme.of(context).colorScheme.primary),
                                 ),

                               ],
                             ),

                             Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,

                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                                       child: Text(
                                         S.of(context).order_is_packed,
                                         style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(
                                         left: 10,
                                         right: 10,
                                       ),
                                       child: Text(
                                         S.of(context).your_order_is_packed_right_now,
                                         style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary.withOpacity(0.8))),
                                       ),
                                     ),
                                   ],
                                 )),
                             const Padding(
                               padding: EdgeInsets.only(top: 30),
                               child:  CircleAvatar(
                                 // ignore: deprecated_member_use
                                 backgroundImage: AssetImage('assets/img/indiaflag.png'),
                                 maxRadius: 25,

                               ),




                             ),

                           ],
                         )


                       ]
                   )
               ):snapshot.data.docs[0]['status']=='RShipped'?Container(
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
                                   child: Icon(Icons.access_time_filled,color: Theme.of(context).colorScheme.primary),
                                 ),

                               ],
                             ),

                             Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,

                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                                       child: Text(
                                         S.of(context).order_is_ready_to_pickup,
                                         style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(
                                         left: 10,
                                         right: 10,
                                       ),
                                       child: Text(
                                         S.of(context).your_order_is_ready_to_pickup_from_the_store,
                                         style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary.withOpacity(0.8))),
                                       ),
                                     ),
                                   ],
                                 )),
                             const Padding(
                               padding: EdgeInsets.only(top: 30),
                               child:  CircleAvatar(
                                 // ignore: deprecated_member_use
                                 backgroundImage: AssetImage('assets/img/indiaflag.png'),
                                 maxRadius: 25,

                               ),




                             ),

                           ],
                         )


                       ]
                   )
               ):snapshot.data.docs[0]['status']=='Shipped' || snapshot.data.docs[0]['status']=='OnTheWay'?Container(
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
                                   child: Icon(Icons.access_time_filled,color: Theme.of(context).colorScheme.primary),
                                 ),

                               ],
                             ),

                             Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,

                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                                       child: Text(
                                         S.of(context).order_is_picked_up,
                                         style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(
                                         left: 10,
                                         right: 10,
                                       ),
                                       child: Text(
                                         '${S.of(context).your_order_is_picked_up_by} ${snapshot.data.docs[0]['driverName']}',
                                         style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary.withOpacity(0.8))),
                                       ),
                                     ),
                                   ],
                                 )),
                             const Padding(
                               padding: EdgeInsets.only(top: 30),
                               child:  CircleAvatar(
                                 // ignore: deprecated_member_use
                                 backgroundImage: AssetImage('assets/img/indiaflag.png'),
                                 maxRadius: 25,

                               ),




                             ),

                           ],
                         )


                       ]
                   )
               ):snapshot.data.docs[0]['status']=='Delivered'?Container(
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
                                   child: Icon(Icons.access_time_filled,color: Theme.of(context).colorScheme.primary),
                                 ),

                               ],
                             ),

                             Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,

                                   children: [
                                     Padding(
                                       padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                                       child: Text(
                                         S.of(context).order_is_delivered,
                                         style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(
                                         left: 10,
                                         right: 10,
                                       ),
                                       child: Text(
                                         '${S.of(context).your_order_is_delivered_by} ${snapshot.data.docs[0]['driverName']}',
                                         style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary.withOpacity(0.8))),
                                       ),
                                     ),
                                   ],
                                 )),
                             const Padding(
                               padding: EdgeInsets.only(top: 30),
                               child:  CircleAvatar(
                                 // ignore: deprecated_member_use
                                 backgroundImage: AssetImage('assets/img/indiaflag.png'),
                                 maxRadius: 25,

                               ),




                             ),

                           ],
                         )


                       ]
                   )
               ):Container()
             );}),
           liveMapDetails.vendorName!=null?Container(
               height: size.height,
               decoration: BoxDecoration(
                 borderRadius: const BorderRadius.only(
                     topLeft: Radius.circular(18.0),
                     topRight: Radius.circular(18.0)),
                 color: Theme.of(context).scaffoldBackgroundColor,
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
                                         child: Image.network(liveMapDetails.vendorLogo,
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
                                           '$vendorName restaurant is ',
                                           style: Theme.of(context).textTheme.titleSmall
                                       ),
                                     ),
                                     Padding(
                                       padding: const EdgeInsets.only(
                                         left: 10,
                                         right: 10,
                                       ),
                                       child: Text(
                                           '$status your order',
                                           style: Theme.of(context).textTheme.bodySmall
                                       ),
                                     ),
                                   ],
                                 )),
                             Container(
                                 margin: const EdgeInsets.only(top:10),
                                 child: IconButton(
                                   icon:  const Icon(Icons.call),
                                   color: Theme.of(context).primaryColorDark, onPressed: () {

                                   _callNumber(liveMapDetails.vendorPhone);
                                 },
                                 )




                             ),

                           ],
                         ),),
                         const CustomDividerView(
                           dividerHeight: 1,
                         ),
                         timerLimit?Container(
                             margin: const EdgeInsets.only(top: 15),
                             child: Wrap(children: [
                               Div(
                                   colS: 4,
                                   colM: 4,
                                   colL: 4,
                                   child: Container(
                                       margin: const EdgeInsets.only(top: 10),
                                       child: Text(
                                         'Do you cancel your order',
                                         textAlign: TextAlign.center,
                                         style: Theme.of(context)
                                             .textTheme
                                             .bodySmall,
                                       ))),
                               Div(
                                   colS: 4,
                                   colM: 4,
                                   colL: 4,
                                   child: Column(children: [
                                     CircularCountDownTimer(
                                       duration: _duration,
                                       initialDuration: 0,
                                       controller: _controller,
                                       width: 60,
                                       height: 60,
                                       ringColor: Colors.grey[300],
                                       ringGradient: null,
                                       fillColor: Colors.red,
                                       backgroundColor: Theme.of(context)
                                           .primaryColor,
                                       strokeWidth: 10.0,
                                       strokeCap: StrokeCap.round,
                                       textStyle: Theme.of(context)
                                           .textTheme
                                           .titleMedium
                                           .merge(const TextStyle(
                                         color: Colors.red,
                                       )),
                                       textFormat: CountdownTextFormat.S,
                                       isReverse: true,
                                       isReverseAnimation: false,
                                       isTimerTextShown: true,
                                       autoStart: true,
                                       onStart: () {
                                         debugPrint('Countdown Started');
                                       },

                                       // This Callback will execute when the Countdown Ends.
                                       onComplete: () {
                                         // Here, do whatever you want
                                         setState(() {
                                           timerLimit = false;
                                         });
                                       },

                                       // This Callback will execute when the Countdown Changes.
                                       onChange: (String timeStamp) {
                                         // Here, do whatever you want
                                         debugPrint(
                                             'Countdown Changed $timeStamp');
                                       },

                                       timeFormatterFunction:
                                           (defaultFormatterFunction,
                                           duration) {
                                         if (duration.inSeconds == 0) {
                                           // only format for '0'
                                           return "1";
                                         } else {
                                           // other durations by it's default format
                                           return Function.apply(
                                               defaultFormatterFunction,
                                               [duration]);
                                         }
                                       },
                                     ),
                                   ])),
                               Div(
                                 colS: 3,
                                 colM: 3,
                                 colL: 3,
                                 child: Container(
                                   margin: const EdgeInsets.only(
                                       bottom: 5, top: 10),
                                   width: 0,
                                   child: ElevatedButton(
                                       onPressed: () {
                                         Navigator.of(context).push(
                                             MaterialPageRoute(
                                                 builder: (context) =>
  CancelPage(
                                                       paymentData: paymentData,
                                                       liveMapDetails: liveMapDetails,
                                                       orderId: widget.orderId,
                                                      )));
                                       },
                                       style: ElevatedButton.styleFrom(
                                         padding: const EdgeInsets.all(5),
                                         backgroundColor: Colors.red,
                                       ),
                                       child: Text(
                                         'Cancel',
                                         style: Theme.of(context)
                                             .textTheme
                                             .titleSmall
                                             .merge(TextStyle(
                                             color: Theme.of(context).primaryColorLight)),
                                       )),
                                 ),
                               ),
                             ])):Container(),
                         const SizedBox(height: 10,),
                         const CustomDividerView(dividerHeight: 1,),
                         liveMapDetails.deliveryAssigned?Container(
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
                                           child: Image.network(liveMapDetails.driverImage,
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
                                             '${liveMapDetails.driverName} is on the way to the restaurant to pick up your order',
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
                           ),):Container(),

                         const SizedBox(height: 10,),
                         const CustomDividerView(dividerHeight: 1,),
                         const SizedBox(height: 10,),
                        liveMapDetails.deliveryInstruction!=null?Row(
                             children:[
                               Icon(Icons.check,size:15,color: greyColor1),
                               Expanded(
                                   child: Container(
                                     padding:  const EdgeInsets.only(left:4),
                                     child: Text(S.of(context).delivery_instruction,
                                       style: Theme.of(context).textTheme.titleSmall,
                                     ),
                                   )
                               ),
                               InkWell(
                                 onTap:(){},
                                 child: Icon(Icons.add_box,color: Theme.of(context).primaryColorDark,),
                               )
                             ]
                         ):Container(),
                         liveMapDetails.deliveryInstruction!=null? Container(
                             padding: const EdgeInsets.only(left:0,top:5,bottom: 10),
                             child:Text(liveMapDetails.deliveryInstruction,
                               style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color: greyColor1)),
                               overflow: TextOverflow.ellipsis,maxLines: 1,
                             )
                         ):Container(),

                       ],
                     )
                   ),


                   const SizedBox(height: 10),
                   Container(
                       decoration:const BoxDecoration(
                         borderRadius: BorderRadius.only(
                             topRight: Radius.circular(15),
                             topLeft:  Radius.circular(15)
                         ),

                       ),
                       child:ClipPath(

                           clipper: PointsClipper(

                           ),
                           child:Container(

                               decoration:BoxDecoration(
                                 color: Theme.of(context).primaryColor,
                                 borderRadius: const BorderRadius.only(
                                     topRight: Radius.circular(15),
                                     topLeft:  Radius.circular(15)
                                 ),

                               ),
                               child:Container(
                                 padding: const EdgeInsets.all(20.0),
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[

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
                                         Flexible(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             mainAxisSize: MainAxisSize.min,
                                             children: <Widget>[


                                              Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: <Widget>[
                                                    Text(S.of(context).delivery_partner_fee , style: const TextStyle(color: Colors.blue)),
                                                   paymentData.delivery_fees  != 0
                                                       ? Text('${Helper.pricePrint(paymentData.delivery_fees.toString())}',
                                                       style: Theme.of(context).textTheme.titleSmall)
                                                       : Text(S.of(context).free, style: Theme.of(context).textTheme.titleSmall),
                                                 ],
                                               ),


                                               const SizedBox(height: 10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: <Widget>[
                                                   Text(S.of(context).discount, style: const TextStyle(color: Colors.green)),
                                                   Text('${Helper.pricePrint(paymentData.discount.toString())}',
                                                       style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color: Colors.green))),
                                                 ],
                                               ),
                                               DottedLine(
                                                 dashColor: Theme.of(context).disabledColor,
                                               ),
                                               const SizedBox(height: 20),

                                                   paymentData.delivery_tips!=0?const SizedBox(height: 10):Container(),


                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: <Widget>[
                                                   Text(S.of(context).delivery_tip, style: Theme.of(context).textTheme.titleSmall),
                                                   InkWell(
                                                     onTap: (){},
                                                     child: Text(Helper.pricePrint(paymentData.delivery_tips.toString()),
                                                         style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).primaryColorDark,

                                                         ))
                                                     ),
                                                   )
                                                 ],
                                               ),
                                               const SizedBox(height:10),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: <Widget>[
                                                   InkWell(
                                                     onTap: (){
                                                       TaxPopupHelper.exit(context,paymentData.tax,paymentData.packingCharge);
                                                     },
                                                     child:Wrap(
                                                         children:[
                                                           Text(S.of(context).taxes_and_charges, style: Theme.of(context).textTheme.titleSmall),
                                                           const SizedBox(width:5),
                                                           const Icon(Icons.arrow_drop_down_outlined)
                                                         ]
                                                     ),
                                                   ),
                                                   Text(Helper.pricePrint((paymentData.delivery_tips+paymentData.packingCharge).toString()),
                                                       style: Theme.of(context).textTheme.titleSmall
                                                   ),

                                                 ],
                                               ),




                                               const SizedBox(height: 10),

                                             ],
                                           ),
                                         ),
                                       ],
                                     ),
                                     const SizedBox(height: 7),

                                     DottedLine(
                                       dashColor: Theme.of(context).disabledColor,
                                     ),
                                     const SizedBox(height: 15),
                                     Container(
                                       alignment: Alignment.center,
                                       margin:const EdgeInsets.only(bottom:25),
                                       child: Row(
                                         children: <Widget>[
                                           Text(
                                             S.of(context).grand_total,
                                             style: Theme.of(context).textTheme.titleSmall,
                                           ),
                                           const Spacer(),
                                           Text(
                                             '${Helper.pricePrint(paymentData.grand_total.toString())}',
                                             style: Theme.of(context).textTheme.titleSmall,
                                           ),
                                         ],
                                       ),
                                     ),
                                   ],
                                 ),
                               )
                           ))
                   )

                 ],
               )
           ):Container(),





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
            vendorName??'',
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
                      color: Theme.of(context).colorScheme.secondary,
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

                        Text('$status your order',
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
