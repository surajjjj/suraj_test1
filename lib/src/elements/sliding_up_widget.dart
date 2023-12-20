import 'package:flutter/material.dart';
import '../components/constants.dart';
import '../controllers/user_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../generated/l10n.dart';
import '../repository/order_repository.dart';
import '../repository/user_repository.dart';

//ignore: must_be_immutable
class SlidingUpWidget extends StatefulWidget {
   dynamic selectedPlace;
   SlidingUpWidget({Key key, this.selectedPlace}) : super(key: key);

  @override
  SlidingUpWidgetState createState() => SlidingUpWidgetState();
}

class SlidingUpWidgetState extends StateMVC<SlidingUpWidget> {
  UserController _con;
  SlidingUpWidgetState() : super(UserController()) {
    _con = controller;

  }
  int defaultDeliveryMode = 0;
  double _panelHeightOpen;
  final double _panelHeightClosed = 150.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.addressData.addressType = 'Home';
    //loadMusic();

  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .77;
    return
        SlidingUpPanel(
      maxHeight: _panelHeightOpen,
      minHeight: _panelHeightClosed,
      parallaxEnabled: true,
      parallaxOffset: .5,
      panelBuilder: (sc) => _panel(sc,widget.selectedPlace,_con.loginFormKey),
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18.0),
          topRight: Radius.circular(18.0)),
    );
  }

  Widget _panel(ScrollController sc, selectedPlace, formKey) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: sc,
          children: <Widget>[
            Form(
                key:formKey ,
                child: Container(
                    padding: const EdgeInsets.only(top:10,right:15,left:15),
                    child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Row(
                              children:[
                                const Icon(Icons.location_on_outlined,color: Colors.red,),
                                Expanded(
                                    child: Container(
                                      padding:  const EdgeInsets.only(left:3),
                                      child: Text('Address',
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
                                'Swipe up! add detailed address will help our partner reach your doorstep easily',
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
                                    labelText: 'HOUSE / FLAT / BLOCK NO',

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
                                    labelText: 'APARTMENT / ROAD / AREA',
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
                              child: Text('DIRECTIONS TO REACH',
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
                                  hintText: 'eg. Ring the bell on the red gate',
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
                              child: Text('SAVE THIS ADDRESS AS',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    .merge(const TextStyle(color: Colors.grey)),
                              )
                          ),


                        ]
                    )
                )),
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
                                          child:Text(index==0?'HOME':index==1?'Office':'Other',
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
                      backgroundColor: MaterialStateProperty.all(transparent),
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
                    currentUser.value.latitude = selectedPlace.geometry.location.lat;
                    currentUser.value.longitude =   selectedPlace.geometry.location.lng;
                    currentUser.value.selected_address =selectedPlace?.formattedAddress;
                    currentCheckout.value.address.flatNo  = _con.addressData.flatNo;
                    currentCheckout.value.address.area  = _con.addressData.area;
                    currentCheckout.value.address.directionsToReach  = _con.addressData.directionsToReach;
                    currentUser.value.myAddress = _con.addressData;
                    Navigator.pop(context);

                  },
                  child: Container(
                    padding: const EdgeInsets.only(top:5,bottom: 5),
                    child:Text(
                        'Submit',
                        style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).colorScheme.primary,height:1.1))
                    ),
                  ),
                ),
              ),
            ),




          ],
        )

    );
  }
}
