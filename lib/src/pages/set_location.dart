
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../repository/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../generated/l10n.dart';
import '../Widget/custom_divider_view.dart';

import '../components/location_picker/google_maps_place_picker.dart';
import '../controllers/user_controller.dart';
import '../models/address.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';



//ignore: must_be_immutable
class SetLocation extends StatefulWidget {
    Function loadUser;
   SetLocation({Key key,this.loadUser}) : super(key: key);

  @override
  SetLocationState createState() => SetLocationState();
}

class SetLocationState extends StateMVC<SetLocation> {
  UserController _con;
  FocusNode focus = FocusNode();
  Address address;

  SetLocationState() : super(UserController()) {
    _con = controller;

  }


  double _panelHeightOpen;
  final double _panelHeightClosed = 150.0;
  int defaultDeliveryMode;
  @override
  void initState() {
    defaultDeliveryMode = 0;
    _con.addressData.addressType = 'Home';
    // TODO: implement initState
    super.initState();
  }




  Widget _panel(ScrollController sc, selectedPlace, formKey) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
        Form(
        key: formKey ,
           child: Container(
                padding: const EdgeInsets.only(top:10,right:15,left:15),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children:[

                      Row(
                          children:[

                            const Icon(Icons.swipe_up,color: Colors.green,),
                            Expanded(
                                child: Container(
                                  padding:  const EdgeInsets.only(left:10),
                                  child: Text(

                                    S.of(context).swipe,




                                    style: Theme.of(context).textTheme.headlineSmall,


                                  ),
                                )
                            )
                          ]
                      ),
                      Row(
                          children:[
                            const Icon(Icons.location_on_outlined,color: Colors.red,),
                            Expanded(
                                child: Container(
                                  padding:  const EdgeInsets.only(left:3),
                                  child: Text(S.of(context).address,
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                )
                            )
                          ]
                      ),
                      Container(
                          padding: const EdgeInsets.only(left:4,top:5),
                          child:Text(selectedPlace?.formattedAddress??'',
                            style: Theme.of(context).textTheme.bodyMedium,

                            overflow: TextOverflow.ellipsis,maxLines: 2,
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark.withOpacity(0.13),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          width: double.infinity,
                          child:Text(

                           S.of(context).swipe_up_add_detailed_address_will_help_our_partner_reach_your_doorstep_easily,
                            style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).primaryColorDark)),
                          )
                      ),

                      Container(
                          margin: const EdgeInsets.only(left: 10,right: 10),
                          width: double.infinity,
                          child: TextFormField(
                              textAlign: TextAlign.left,
                              autocorrect: true,
                              validator: (input) => input.length < 3 ? S.of(context).should_be_more_than_3_characters : null,
                              onSaved: (input) =>      _con.addressData.flatNo  = input,
                              keyboardType: TextInputType.text,
                              cursorColor: Theme.of(context).focusColor,
                              decoration: InputDecoration(
                                labelText: '${S.of(context).house} / ${S.of(context).flat} / ${S.of(context).block_no}',

                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    .merge(const TextStyle(color: Colors.grey)),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                    width: 1.0,
                                  ),
                                ),
                              ))),

                      const SizedBox(height:5),
                      Container(
                          margin: const EdgeInsets.only(left: 10,right: 10),
                          width: double.infinity,
                          child: TextFormField(
                              textAlign: TextAlign.left,
                              autocorrect: true,
                              keyboardType: TextInputType.text,
                              cursorColor: Theme.of(context).focusColor,
                              onSaved: (input) =>      _con.addressData.area  = input,
                              decoration: InputDecoration(
                                labelText: '${S.of(context).apartment} / ${S.of(context).apartment} / ${S.of(context).area}',
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    .merge(const TextStyle(color: Colors.grey)),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.secondary,
                                    width: 1.0,
                                  ),
                                ),
                              ))),
                      Container(
                          margin: const EdgeInsets.only(top:20,left: 10,right: 10,bottom: 15),
                          child: Text(S.of(context).directions_to_reach,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                .merge(const TextStyle(color: Colors.grey)),
                          )
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10,right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Theme.of(context).dividerColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            onSaved: (input) =>      _con.addressData.directionsToReach  = input,
                            cursorColor: Theme.of(context).focusColor,
                            maxLines: 5,
                            decoration: InputDecoration.collapsed(
                              hintText: 'eg. ${S.of(context).ring_the_bell_on_the_red_gate}',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  .merge(const TextStyle(color: Colors.grey)),
                            ),
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top:20,left: 10,right: 10,bottom:5),
                          child: Text(S.of(context).save_this_address_as,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                .merge(const TextStyle(color: Colors.grey)),
                          )
                      ),

                      SizedBox(
                        height:62,
                        child:ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            padding: const EdgeInsets.only(right:10),
                            itemBuilder: (context, index) {


                              return Container(
                                padding: const EdgeInsets.only(top:15,bottom:12,left:23,),
                                child:Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.2),
                                          blurRadius: 1,
                                          spreadRadius:0.3,
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child:Material(  //Wrap with Material
                                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
                                      //elevation:_category.selected?3:1,
                                      color: Theme.of(context).primaryColor,
                                      clipBehavior: Clip.antiAlias, // Add This
                                      child: MaterialButton(
                                        color:  defaultDeliveryMode==index?Colors.lightGreen:Theme.of(context).primaryColor,
                                        child: Center(
                                          child:   Wrap(
                                              children:[
                                                Icon(
                                                    index==0?Icons.home:index==1?Icons.home_repair_service_rounded:Icons.location_on,size:18,
                                                    color: Theme.of(context).hintColor
                                                ),
                                                Container(
                                                    padding: const EdgeInsets.only(top:0,left:10,right:5),
                                                    child:Text(index==0?S.of(context).home:index==1?S.of(context).office:S.of(context).others,
                                                        textAlign: TextAlign.center,
                                                        style:Theme.of(context).textTheme.titleSmall
                                                    )
                                                ),

                                              ]
                                          ),
                                        ),
                                        onPressed: () {
                                          if(index==0){
                                            _con.addressData.addressType = 'Home';
                                          } else if(index==2){
                                            _con.addressData.addressType = 'Office';
                                          }else {
                                            _con.addressData.addressType = 'Other';
                                          }
                                          setState(() {
                                            defaultDeliveryMode = index;
                                          });
                                        },
                                      ),)
                                ),

                              );
                            }
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top:10,left:20,right:20),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            /*gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: <Color>[
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).focusColor

                    ],
                  ),*/
                            color:Theme.of(context).colorScheme.secondary,
                            borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.2),
                                blurRadius: 1,
                                spreadRadius: 0.3,
                              ),
                            ],
                          ),

                          child:ElevatedButton(

                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                elevation: MaterialStateProperty.all(0),
                                shape:MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(7)))
                            ),
                            onPressed:(){

                              _con.addressData.latitude = selectedPlace.geometry.location.lat;
                              _con.addressData.longitude =  selectedPlace.geometry.location.lng;
                              _con.addressData.addressSelect = selectedPlace?.formattedAddress;
                              _con.addressData.isDefault = 'false';
                              currentUser.value.latitude =selectedPlace.geometry.location.lat;
                              currentUser.value.longitude =selectedPlace.geometry.location.lng;
                              _con.saveAddress();


                            },
                            child: Container(
                              padding: const EdgeInsets.only(top:5,bottom: 5),
                              child:Text(
                                  S.of(context).submit,
                                  style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).colorScheme.primary,height:1.1))
                              ),
                            ),
                          ),
                        ),
                      ),

                    ]
                )
            ),

        ),




          ],
        )

    );
  }



  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .77;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leadingWidth: 20,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.background
        ),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.5,
        title:Container(


          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)
          ),

          child:InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlacePicker(
                      apiKey: setting.value.googleMapsKey,
                      initialPosition: LatLng(currentUser.value.latitude, currentUser.value.longitude),
                      useCurrentLocation: false,

                      selectInitialPosition: true,
                      usePlaceDetailSearch: true,
                      forceSearchOnZoomChanged: true,

                      selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                        if (isSearchBarFocused) {
                          return const SizedBox();
                        }
                        return SlidingUpPanel(
                          maxHeight: _panelHeightOpen,
                          minHeight: _panelHeightClosed,
                          parallaxEnabled: true,
                          parallaxOffset: .5,
                          panelBuilder: (sc) => _panel(sc,selectedPlace,_con.loginFormKey),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18.0),
                              topRight: Radius.circular(18.0)),
                        );
                      },
                    )
                ),
              );
            },
            child: Column(
                children:[

                  Container(
                      padding: const EdgeInsets.only(top:18,left:5,bottom:18,right:10),
                      child:Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width:30,height:40,
                              padding: const EdgeInsets.all(5),

                              child: Icon(Icons.my_location_outlined,color: Colors.orange,

                                  // color: Theme.of(context).primaryColorDark
                              )
                          ),

                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left:15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(S.of(context).current_location,style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: Theme.of(context).primaryColorDark))
                                  ),
                                  Text(S.of(context).using_gps,
                                    style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color: Theme.of(context).primaryColorDark)),
                                  )

                                ],
                              ),
                            ),
                          ),

                        ],
                      )
                  ),
                ]
            ),
          ),
        ),

      ),
        body: Column(
            children:[

          Expanded(
            child: SizedBox(
                width:double.infinity,

                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[


                          const CustomDividerView(dividerHeight: 15.0),
                          Container(
                            padding: const EdgeInsets.only(top:20,left:25,bottom:5),
                            child:Text(S.of(context).saved_addresses,
                                style: Theme.of(context).textTheme.titleMedium.merge(TextStyle(color: Theme.of(context).disabledColor))
                            ),
                          ),
                          currentUser.value.address.isNotEmpty
                              ? ListView.separated(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: currentUser.value.address.length,
                            itemBuilder: (context, index) {
                              Address addressData = currentUser.value.address.elementAt(index);
                              return SavedAddresses(addressData: addressData,loadUser: widget.loadUser,);
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 1);
                            },
                          ):Container(),
                          const SizedBox(height:20)
                        ]
                    )
                )
            )
        ),


            ]
        )
    );
  }
}


//ignore: must_be_immutable
class SavedAddresses extends StatefulWidget {
   Function loadUser;
   SavedAddresses({Key key, this.addressData,this.loadUser}) : super(key: key);
  Address addressData;
  @override
  State<SavedAddresses> createState() => _SavedAddressesState();
}

class _SavedAddressesState extends State<SavedAddresses> {



  @override
  Widget build(BuildContext context) {

    return  InkWell(
      onTap: (){
        currentUser.value.latitude = widget.addressData.latitude;
        currentUser.value.longitude =  widget.addressData.longitude;
        currentUser.value.selected_address = widget.addressData.addressSelect;
        currentCheckout.value.address.flatNo  = widget.addressData.flatNo;
        currentCheckout.value.address.area  = widget.addressData.area;
        currentCheckout.value.address.addressType = widget.addressData.addressType;
        currentCheckout.value.address.directionsToReach  = widget.addressData.directionsToReach;
        currentUser.value.myAddress =   widget.addressData;
        setCurrentUserUpdate(currentUser.value);
          widget.loadUser();


        Navigator.pop(context);
      },
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:18),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1,color: Theme.of(context).dividerColor
                      )
                  )
              ),
              child:Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width:30,height:40,
                      padding: const EdgeInsets.all(5),

                      child: Icon(widget.addressData.addressType=='Home'?Icons.home_outlined:widget.addressData.addressType=='Office'?Icons.home_repair_service_rounded:Icons.location_on_outlined,
                          color: Theme.of(context).disabledColor
                      )
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left:15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.addressData.addressType,style: Theme.of(context).textTheme.titleSmall
                          ),
                          Text(widget.addressData.addressSelect,
                            overflow: TextOverflow.ellipsis,maxLines: 2,
                            style: Theme.of(context).textTheme.bodySmall,
                          )

                        ],
                      ),
                    ),
                  ),

                ],
              )
          ),



        ],
      ),
    );
  }
  }



