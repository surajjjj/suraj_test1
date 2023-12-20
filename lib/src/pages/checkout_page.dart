import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../Widget/custom_divider_view.dart';
import '../components/paybutton_loader.dart';
import '../components/constants.dart';
import '../components/location_picker/google_maps_place_picker.dart';
import '../elements/sliding_up_widget.dart';
import '../models/address.dart';
import '../repository/product_repository.dart';
import '../helpers/helper.dart';
import '../repository/order_repository.dart';
import '../controllers/cart_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/checkout_list_widget.dart';
import '../repository/product_repository.dart' as cart_repo;
import '../../generated/l10n.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import 'payment_page.dart';
import 'set_location.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key key}) : super(key: key);

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState extends StateMVC<CheckoutPage> {

  CartController _con;
  var shimmerColor = Colors.grey[300];
  CheckoutPageState() : super(CartController()) {
    _con = controller;
  }


  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        bottomNavigationBar:1==1? Container(
          width: double.infinity,height:_con.checkOutGatePass?179:129,
          padding: const EdgeInsets.only(top:10,),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 6,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
    ValueListenableBuilder(
    valueListenable: cart_repo.currentCart,
    builder: (context, settings, _) {
      return _con.checkOutButtonLoad && currentCheckout.value.grand_total==0 ?const PayButtonLoader():Column(
        children:[
      currentUser.value.name==null || currentUser.value.name =='' ||  currentUser.value.phone==null?Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left:15,right:15),
             child:Text(
               S.of(context).almost_there,
               style: Theme.of(context).textTheme.displayMedium,
             ),),
              Container(
                margin: const EdgeInsets.only(top:5,bottom: 15,left:15,right:15),
                child: Text(S.of(context).complete_address_quickly_to_place_order,
                style: TextStyle(color: priceColor1,fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left:15,right:15),
                height: 54,
                width: double.infinity,
                decoration: BoxDecoration(
                  color:Theme.of(context).colorScheme.secondary,
                    /*gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      colors: <Color>[
                        Theme.of(context).primaryColorDark,
                        Theme.of(context).focusColor

                      ],
                    ),*/
                    borderRadius: const BorderRadius.all(Radius.circular(7.0))
                ),

                child:ElevatedButton(

                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(transparent),
                        elevation: MaterialStateProperty.all(0),
                        shape:MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(7)))
                    ),
                    onPressed:() async {


                        await   Navigator.of(context).pushNamed('/edit_profile');
                        setState(() {
                          currentUser.value.address;
                        });
                    },
                    child: Text(
                        S.of(context).complete_your_profile,
                        style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight,height:1.1))
                    ),
                ),
              ),
      ]):  currentUser.value.myAddress.flatNo=='' || currentUser.value.myAddress.flatNo==null?Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left:15,right:15),
              child:Text(
                S.of(context).almost_there,
                style: Theme.of(context).textTheme.displayMedium,
              ),),
            Container(
              margin: const EdgeInsets.only(top:5,bottom: 15,left:15,right:15),
              child: Text(S.of(context).complete_address_quickly_to_place_order,
                style: TextStyle(color: priceColor1,fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left:15,right:15),
              height: 54,
              width: double.infinity,
              decoration: BoxDecoration(
                color:Theme.of(context).colorScheme.secondary,
                 /* gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: <Color>[
                      Theme.of(context).primaryColorDark,
                      Theme.of(context).focusColor

                    ],
                  ),*/
                  borderRadius: const BorderRadius.all(Radius.circular(7.0))
              ),

              child:ElevatedButton(

                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape:MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(7)))
                ),
                onPressed:() async {


                  changeAddress();
                  setState(() {
                    currentUser.value.address;
                  });
                },
                child: Text(
                    S.of(context).add_address_at_next_step,
                    style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight,height:1.1))
                ),
              ),
            ),
          ]): !currentCheckout.value.deliveryPossible?SingleChildScrollView(child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          Padding(
            padding: EdgeInsets.only(left:size.width * 0.2,right:size.width * 0.2,top:Helper.mediaSize(context, 'height', 0.05)),
            child: SizedBox(
              width: double.infinity,
              height:50,
              child: ElevatedButton(
                onPressed: () {
                  /*Navigator.of(context).pushNamed('/Login');*/
                },
                 style:ElevatedButton.styleFrom(
                   backgroundColor: Theme.of(context).colorScheme.secondary,
                   padding: const EdgeInsets.only(top:10)
                 ),
                child: Column(
                  children: [
                    Text(
                      S.of(context).change_address,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          .merge(TextStyle(color: Theme.of(context).primaryColorLight,fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(height:4),
                    Text(S.of(context).use_another_address,style: TextStyle(fontSize:10,color:Theme.of(context).primaryColorLight.withOpacity(0.7),))

                  ],
                ),),
            ),
          ),
        ],
      )):     _con.checkOutGatePass? Container(
          padding: const EdgeInsets.only(top:15,),

          child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                Container(
                  margin:const EdgeInsets.only(bottom: 15,right:15,left:15),
                  child:Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        const Icon(Icons.location_on_outlined,color: Colors.red,),
                        Expanded(
                            child: Container(
                                padding:  const EdgeInsets.only(left:3),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Text('Delivery at ${currentCheckout.value.address.addressType}',
                                          style: Theme.of(context).textTheme.titleMedium
                                      ),
                                      Container(
                                          padding: const EdgeInsets.only(left:4,top:5),
                                          child:Text(currentUser.value.selected_address,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            overflow: TextOverflow.ellipsis,maxLines: 2,
                                          )
                                      ),
                                    ]
                                )
                            )
                        ),
                        InkWell(
                            onTap: (){
                              changeAddress();

                            },
                            child:Wrap(
                              children: [

                                  Icon(Icons.home_filled,color: Theme.of(context).primaryColorDark,),


                                Container(
                                    margin:const EdgeInsets.only(top:5),
                                  child:const Icon(Icons.arrow_drop_down_outlined,size:18))
                              ],
                            )
                        )
                      ]
                  ),),


                Align(
                  alignment: Alignment.bottomCenter,
                  child:Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      child: Wrap(
                          children:[
                            Div(
                              colS:5,
                              colM:5,
                              colL:5,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PaymentPages()));
                                  },
                                  child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:[
                                        Wrap(
                                            children:[
                                              Container(
                                                margin: const EdgeInsets.only(top:2),
                                                padding: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    border:Border.all(
                                                        color: Theme.of(context).dividerColor,
                                                        width: 1
                                                    )
                                                ),
                                                child:Image.asset( currentUser.value.paymentImage,
                                                  width: 20,height:15,
                                                  fit: BoxFit.fitWidth,
                                                ),
                                              ),
                                              Container(
                                                  margin: const EdgeInsets.only(left:10,top:5),
                                                  child:Text(S.of(context).pay_using,
      style: TextStyle(fontSize:10,fontWeight: FontWeight.bold,color:priceColor1),)
                                              ),
                                              Icon(Icons.arrow_drop_up,color:priceColor1,size:35)
                                            ]
                                        ),
                                        Text( currentUser.value.paymentType,
                                          style: Theme.of(context).textTheme.titleSmall,
                                        )
                                      ]
                                  )

                              ),
                            ),
                            Div(
                              colS:7,
                              colM:7,
                              colL:7,
                              child:SizedBox(
                                // ignore: deprecated_member_use
                                height: 58,
                                child: ElevatedButton(

                                  onPressed: () {

                                   _con.gotoPayment();
                                  },
                                  style:ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(7),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15), // <-- Radius
                                    ),

                                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                                  ),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Column(
                                        children:[
                                          Container(
                                              margin: const EdgeInsets.only(bottom: 3),
                                              child: Text(
                                               ' ${Helper.pricePrint(currentCheckout.value.grand_total.toString())}',
                                                style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: Theme.of(context).primaryColorLight)),
                                              )),
                                          Text(S.of(context).total,
                                            style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                          )

                                        ]
                                    ),
                                    Container(
                                      padding:const EdgeInsets.only(right:10),
                                      child:Text(S.of(context).place_order,
                                          style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: Theme.of(context).colorScheme.primary),
                                          )
                                      ),

                                    )
                                  ]),
                                ),
                              ),
                            ),

                          ]
                      )
                  ),
                )





              ]
          )
      ):Container()
      ]);
    })

            ],
          ),
        ):Container(
          width: double.infinity,height:179,
          padding: const EdgeInsets.only(top:10,),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 6,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              )
          ),
          child: Container(
              padding: const EdgeInsets.only(top:15,),

              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    Container(
                      margin:const EdgeInsets.only(bottom: 15,right:15,left:15),
                      child:Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            const Icon(Icons.location_on_outlined,color: Colors.red,),
                            Expanded(
                                child: Container(
                                    padding:  const EdgeInsets.only(left:3),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:[
                                          Text('Delivery at home',
                                              style: Theme.of(context).textTheme.titleMedium
                                          ),
                                          Container(
                                              padding: const EdgeInsets.only(left:4,top:5),
                                              child:Text(currentUser.value.selected_address,
                                                style: Theme.of(context).textTheme.bodyMedium,
                                                overflow: TextOverflow.ellipsis,maxLines: 1,
                                              )
                                          ),
                                        ]
                                    )
                                )
                            ),
                            InkWell(
                               onTap: (){
                                 changeAddress();
                               },
                                child:Text(
                                  S.of(context).change,style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).primaryColorDark)),
                                )
                            )
                          ]
                      ),),
                  ]
              )
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            ValueListenableBuilder(
                valueListenable: cart_repo.currentCart,
                builder: (context, setting, _) {
               // _con.grandSummary();
                  return SliverPersistentHeader(
                    pinned: true,
                    floating: false,
                    delegate: SliverCustomHeaderDelegate(
                      title: currentCheckout.value.shopName??'',
                      collapsedHeight: 70,
                      expandedHeight: 120,
                      paddingTop: MediaQuery.of(context).padding.top,
                      coverImgUrl: 'http://www.sriaghraharamatrimoni.com/assets/new_home_page/images/lp-3.png',
                      subtitle: '${currentCart.value.length} ${S.of(context).items}, ${S.of(context).to_pay}  ${Helper.pricePrint(currentCheckout.value.grand_total.toString())}',
                    ),
                  );
                }),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                CheckoutListWidget(con: _con,),
              ]),
            ),
          ],
        ));
  }
  loadUser(){
    setState(() => currentUser.value);

  }

  void changeAddress() {

    Future<void> future =   showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              color: const Color(0xff737373),
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
                  ),
                  child:Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        decoration: const BoxDecoration(

                          shape: BoxShape.rectangle,

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                padding: const EdgeInsets.only(left:20,top:20),
                                alignment: Alignment.topLeft,
                                child:Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[

                                      Text(S.of(context).change_address,
                                        style: Theme.of(context).textTheme.displaySmall,
                                      ),

                                    ]
                                )
                            ),


                            Container(
                              height: 28,width: 28,

                              margin: const EdgeInsets.only(right: 20,top: 20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).disabledColor.withOpacity(0.5),
                                    blurRadius: 1.5,
                                    spreadRadius:0.1,
                                  ),
                                ],
                              ),
                              child: InkWell(
                                child: const Icon(Icons.close,size: 18,),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                            )
                          ],
                        ),
                      ),

                      const CustomDividerView(
                        dividerHeight: 2,
                      ),
                      InkWell(
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
                                    return SlidingUpWidget(selectedPlace: selectedPlace,);
                                  },
                                )
                            ),
                          );

                        },
                        child: Column(
                            children:[

                              Container(
                                  padding: const EdgeInsets.only(top:18,left:18,bottom:18,right:10),
                                  child:Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          width:30,height:40,
                                          padding: const EdgeInsets.all(5),

                                          child: Icon(Icons.my_location_outlined,
                                              color: Theme.of(context).primaryColorDark
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
                      Expanded(
                          child:SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(top:10,left:25,bottom:5),
                                  child:Text(S.of(context).saved_addresses,
                                      style: Theme.of(context).textTheme.titleMedium.merge(TextStyle(color: Theme.of(context).disabledColor))
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  margin:const EdgeInsets.only(left:18,right:18),
                                  child:  ListView.separated(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount:  currentUser.value.address.length,
                                    itemBuilder: (context, index) {
                                      Address addressData = currentUser.value.address.elementAt(index);
                                      return SavedAddresses(addressData: addressData,loadUser:loadUser);
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(height: 1);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          )
                      ),

                    ],

                  )
              ),
            ),
          );
        });

    future.then((void value) => {
      _con.calculateDeliveryFees(),

    });
  }

}






class SliverCustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double collapsedHeight;
  final double expandedHeight;
  final double paddingTop;
  final String coverImgUrl;
  final String title;
  final String subtitle;
  String statusBarMode = 'dark';

  SliverCustomHeaderDelegate({
    this.collapsedHeight,
    this.expandedHeight,
    this.paddingTop,
    this.coverImgUrl,
    this.title,
    this.subtitle,
  });

  @override
  double get minExtent => collapsedHeight + paddingTop;

  @override
  double get maxExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  void updateStatusBarBrightness(shrinkOffset) {
    if (shrinkOffset > 50 && statusBarMode == 'dark') {
      statusBarMode = 'light';
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ));
    } else if (shrinkOffset <= 50 && statusBarMode == 'light') {
      statusBarMode = 'dark';
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
    }
  }

  Color makeStickyHeaderBgColor(shrinkOffset) {
    final int alpha = (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
    return Color.fromARGB(alpha, 255, 255, 255);
  }

  Color makeStickyHeaderTextColor(shrinkOffset, isIcon) {
    if (shrinkOffset <= 50) {
      return isIcon ? Colors.white : Colors.transparent;
    } else {
      final int alpha = (shrinkOffset / (maxExtent - minExtent) * 255).clamp(0, 255).toInt();
      return Color.fromARGB(alpha, 0, 0, 0);
    }
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    updateStatusBarBrightness(shrinkOffset);
    return SizedBox(
      height: maxExtent,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 50,right:10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  CircleAvatar(
                    // ignore: deprecated_member_use
                    backgroundImage: NetworkImage(currentCheckout.value.vendor.logo),
                    maxRadius: 25,

                  ),


                    const SizedBox(width: 10),
                    Expanded(
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(currentCheckout.value.shopName??'', textAlign: TextAlign.left, style: Theme.of(context).textTheme.titleLarge),
                          Text(currentCheckout.value.subtitle??'', textAlign: TextAlign.left, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      )
                    )


                ],
              ),

          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: makeStickyHeaderBgColor(shrinkOffset),
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: collapsedHeight,
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: makeStickyHeaderTextColor(shrinkOffset, false),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(
                              color: makeStickyHeaderTextColor(shrinkOffset, false),
                            )),
                          ),
                          Text(
                            subtitle,
                            maxLines: 1,
                            softWrap: true,
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(
                              color: makeStickyHeaderTextColor(shrinkOffset, false),
                            )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

