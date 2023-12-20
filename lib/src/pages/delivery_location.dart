import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart';
import '../../generated/l10n.dart';
class DeliveryLocation extends StatefulWidget {
  const DeliveryLocation({Key key}) : super(key: key);

  @override
  DeliveryLocationState createState() => DeliveryLocationState();
}

class DeliveryLocationState extends StateMVC<DeliveryLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: Column(children: [
          // ignore: prefer_const_constructors
          SizedBox(height: 100),
          Container(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.only(top: 50, left: 0, right: 0),
              width: double.infinity,
              // ignore: prefer_const_constructors
              child: Image(
                  // ignore: prefer_const_constructors
                  image: AssetImage("assets/img/location.png"),
                  width: double.infinity,
                  height: 350,
                  fit: BoxFit.fill)),
          const SizedBox(height: 40),          //Text('Home delivery in 13+ cities'),
        ]),
      ),
      Align(
          alignment: Alignment.bottomRight,
          child: InkWell(
            onTap: () {},
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Container(
                width: double.infinity,
                height: 120.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      currentUser.value.selected_address==null?
                      Text(S.of(context).where_dou_you_want_your_delivery):Text(currentUser.value.selected_address),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, top: 5, bottom: 5),
                        child: SizedBox(
                          width: double.infinity,
                          // ignore: deprecated_member_use
                          child: ElevatedButton(
                              onPressed: () async {
                               // Address _addressData = new Address();
                                /*Navigator.of(context).pushNamed('/Login');*/
                              /**  LocationResult result = await showLocationPicker(
                                  context,
                                  setting.value.googleMapsKey,
                                  initialCenter: LatLng(31.1975844, 29.9598339),
                                  automaticallyAnimateToCurrentLocation: true,
                                  myLocationButtonEnabled: true,
                                  layersButtonEnabled: true,
                                  resultCardAlignment: Alignment.bottomCenter,
                                );

                                _addressData.latitude = result.latLng.latitude;
                                _addressData.longitude = result.latLng.longitude;
                                _addressData.addressSelect = result.address;
                                _addressData.username = currentUser.value.name;
                                _addressData.phone = currentUser.value.phone;
                                _addressData.id = 'Home';
                                _addressData.isDefault = 'true';
                                _addressData.userId = currentUser.value.id;
                                currentUser.value.selected_address =  result.address;
                                currentUser.value.latitude = result.latLng.latitude;
                                currentUser.value.longitude = result.latLng.longitude;

                                setState(() => currentUser.value.address.add(_addressData));
                                   print(currentUser.value.toMap());
                                setCurrentUserUpdate(currentUser.value);
                                Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2); */
                              //
                              },
                              style:ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(15),

                                backgroundColor:Theme.of(context).colorScheme.secondary.withOpacity(1),
                              ),

                              child: Text(
                                S.of(context).use_my_location,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    .merge(TextStyle(color: Theme.of(context).primaryColorLight)),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    ]));
  }
}
