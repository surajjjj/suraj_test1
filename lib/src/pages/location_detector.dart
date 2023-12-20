import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:lottie/lottie.dart';
import '../components/location_picker/google_maps_place_picker.dart';
import '../elements/address_box_loader_widget.dart';
import '../elements/lottie_animation_widget.dart';
import '../helpers/helper.dart';
import '../models/address.dart';
import '../repository/home_repository.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';

import '../../generated/l10n.dart';
class LocationDetector extends StatefulWidget {
  const LocationDetector({Key key}) : super(key: key);


  @override
  State<LocationDetector> createState() => _LocationDetectorState();
}

class _LocationDetectorState extends State<LocationDetector>with SingleTickerProviderStateMixin {
  AnimationController _controller;


  loc.Location locationR = loc.Location();
  int gate = 1;
  @override
  void initState() {
    _controller = AnimationController(vsync: this,);

    _getCurrentLocation();

    super.initState();
    locationGate();
  }
  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
  locationGate(){
    Timer(const Duration(seconds: 20), () {
      setState(() {
        gate=2;
      });
    });
  }

  checkLocation() async {

    await locationR.requestService();
    if (!await locationR.serviceEnabled()) {
      locationR.requestService();

      if (kDebugMode) {
        print('enabled location');
      }

    } else{

      _getCurrentLocation();
    }
  }

  String _currentAddress;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: Helper.of(context).onWillPop,

        child:Scaffold(
          body: Center(
              child: gate==1?Column(

                children: <Widget>[
                  Expanded(
                      child:Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 420,width:380,
                                child: LottieAnimationWidget(jsonData:'assets/img/location_detection.json')
                            ),
                          ]
                      )
                  ),
                  Container(
                    width: double.infinity,
                    height: 260,
                    padding: const EdgeInsets.only(left:32,right:32,bottom:20),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                            children:[
                              Image.asset('assets/img/logo.png',
                                  width:30,height:30
                              ),
                              Container(
                                  margin:const EdgeInsets.only(left:5,top:3),
                                  child:Text(setting.value.appName,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  )
                              )
                            ]
                        ),
                        Container(
                            padding: const EdgeInsets.only(top:5),
                            child:Text(S.of(context).help_us_find_you,
                              style: Theme.of(context).textTheme.displaySmall,
                            )
                        ),

                        Container(
                            padding: const EdgeInsets.only(top:10),
                            child:Text(_currentAddress == null?S.of(context).getting_location:S.of(context).your_location,
                              style: Theme.of(context).textTheme.bodySmall,
                            )

                        ),
                        Text(_currentAddress == null?'${S.of(context).finding}...':'Find',
                            style: TextStyle(color:Theme.of(context).disabledColor.withOpacity(0.9),)
                        ),

                        Container(
                            padding: const EdgeInsets.only(top:10),
                            child:Text(_currentAddress ?? '',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(color: Colors.black)),
                            )
                        ),
                      ],
                    ),),

                  /* Container(
                        padding: const EdgeInsets.only(top:10),
                          child:Text(_currentAddress ?? '',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: Theme.of(context).textTheme.caption.merge(const TextStyle(color: Colors.black)),
                          )
                      ),*/




                ],
              ):Container(
                padding: const EdgeInsets.all(32),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(
                      height: 220,width:220,
                      child: Lottie.asset(
                        'assets/img/location_not_found.json',


                        controller: _controller,
                        animate: true,
                        onLoaded: (composition) {
                          // Configure the AnimationController with the duration of the
                          // Lottie file and start the animation.
                          _controller
                            ..duration = composition.duration
                            ..forward();
                        },
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(top:10),
                      child:  Wrap(
                          children:[
                            Icon(Icons.location_on_outlined,color:Theme.of(context).disabledColor.withOpacity(0.9),),
                            Container(
                                padding: const EdgeInsets.only(left:5),
                                child:Text('${S.of(context).sorry} !',
                                  style: Theme.of(context).textTheme.displayMedium,
                                )),
                          ]
                      ),
                    ),

                    Container(
                        padding: const EdgeInsets.only(top:10),
                        child:Text(S.of(context).your_location_cant_find_automatically_please_click_the_button_select_your_location,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color: Theme.of(context).colorScheme.background)),
                        )
                    ),
                    const SizedBox(height:20),
                    MaterialButton(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                        elevation: 5.0,
                        minWidth: 200,
                        height: 50,
                        color: Theme.of(context).colorScheme.secondary,
                        child: Text(S.of(context).choose_location,
                            style: Theme.of(context).textTheme.titleLarge.merge(TextStyle( color:Theme.of(context).primaryColorLight))
                        ),
                        onPressed: () async {
                          if(currentUser.value.latitude!=0.0 && currentUser.value.longitude!=0.0){
                           await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlacePicker(
                          apiKey: setting.value.googleMapsKey,
                          initialPosition: const LatLng(31.1975844, 29.9598339),
                          useCurrentLocation: false,

                          selectInitialPosition: true,
                          usePlaceDetailSearch: true,
                          forceSearchOnZoomChanged: true,

                          selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                            if (isSearchBarFocused) {
                              return const SizedBox();
                            }


                            //  Address _address = Address(address: selectedPlace?.formattedAddress ?? '');
                            return FloatingCard(
                                height: 220,
                                elevation: 0,
                                width: double.infinity,
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                bottomPosition: 0.0,
                                leftPosition: 0.0,
                                rightPosition: 0.0,
                                color: Theme.of(context).primaryColor,
                                child: state == SearchingState.Searching
                                    ? AddressBoxLoaderWidget()
                                    : Container(
                                  padding: const EdgeInsets.only(left:15,right:15,top:15),
                                  child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(S.of(context).select_delivery_location,style:Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).hintColor))),
                                      const SizedBox(height:20),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            const Align(
                                                alignment:Alignment.topLeft,
                                                child:Icon(Icons.location_on_outlined,size:30)
                                            ),
                                            Expanded(
                                                child:Container(
                                                    padding: const EdgeInsets.only(left:10),
                                                    child:Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Text(S.of(context).address,style:Theme.of(context).textTheme.displayMedium),
                                                          const SizedBox(height: 10,),
                                                          Text(selectedPlace?.formattedAddress,overflow: TextOverflow.ellipsis,maxLines: 2,
                                                              style:Theme.of(context).textTheme.bodyMedium),
                                                        ]
                                                    )

                                                )
                                            )
                                          ]
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(bottom:15,top:35),
                                        width: double.infinity,
                                        height: 50.0,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.secondary,
                                          borderRadius: BorderRadius.circular(7),),

                                        child: MaterialButton(
                                          onPressed: () {
                                            currentUser.value.selected_address = selectedPlace?.formattedAddress;
                                            currentUser.value.latitude =  selectedPlace.geometry.location.lat;
                                            currentUser.value.longitude = selectedPlace.geometry.location.lng;
                                            Navigator.pop(context,selectedPlace?.formattedAddress);

                                          },
                                          child: Center(
                                              child: Text(
                                                  S.of(context).save_and_proceed,
                                                  style: Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).primaryColorLight))
                                              )),
                                        ),
                                      ),


                                    ],
                                  ),
                                )
                            );
                          },
                        )
                    ),
                  );
                            if(currentUser.value.selected_address!='' && currentUser.value.selected_address!=null){
                              currentUser.value.locationType = 'manual';
                              setCurrentUserUpdate(currentUser.value);
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                            }
                          }


                        }

                    ),



                  ],
                ),)
          ),
        ));
  }

  _getCurrentLocation() {
    if (kDebugMode) {
      print('location check');
    }

    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {

      setState(() {
        if (kDebugMode) {
          print('get position');
        }

        _getAddressFromLatLng(position);
      });
    }).catchError((e) {
      if (kDebugMode) {
        print(e);
      }

      checkLocation();
    });
  }

  _getAddressFromLatLng(Position currentPosition) async {
    try {
      if (kDebugMode) {
        print('location loaded');
      }
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude
      );

      Placemark place = placemarks[0];
      if (placemarks[0].locality != null && placemarks[0].locality.isNotEmpty) {
        setState(() {
          _currentAddress = "${place.street}, ${place.subLocality}, ${place
              .administrativeArea},${place.postalCode}, ${place.country}";
        });
      } else{
        setState(() {
          _currentAddress = "${place.street}, ${place.subAdministrativeArea}, ${place
              .administrativeArea},${place.postalCode}, ${place.country}";
        });
      }

      Address addressData = Address();
      if(catchLocationList.value.isEmpty){

        addressData.addressSelect = _currentAddress;
        addressData.latitude = currentPosition.latitude;
        addressData.longitude = currentPosition.longitude;
        addressData.selected  = false;
        catchLocationList.value.add(addressData);
        setCatchLocationList();
      } else {
        var contain = catchLocationList.value.where((element) => element.addressSelect==_currentAddress);

        addressData.addressSelect = _currentAddress;
        addressData.latitude = currentPosition.latitude;
        addressData.longitude = currentPosition.longitude;
        addressData.selected  = false;
        if (contain.isEmpty){

          catchLocationList.value.add(addressData);
          setCatchLocationList();
        }





      }
      currentUser.value.selected_address =  addressData.addressSelect;
      currentUser.value.latitude =  addressData.latitude;
      currentUser.value.longitude =  addressData.longitude;



      Timer(const Duration(seconds: 1), () {
        currentUser.value.locationType = 'automatic';
        if(currentUser.value.latitude!=0 && currentUser.value.latitude!=null) {
          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        }
      });

    } catch (e) {
      if (kDebugMode) {
        print('location $e' );
      }
      if (kDebugMode) {
        print(e);
      }
    }
  }


}



