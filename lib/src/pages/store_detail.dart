import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../generated/l10n.dart';
import '../components/constants.dart';
import '../components/Shimmer/rectangular_loader_widget.dart';
import '../elements/close_board_widget.dart';
import '../elements/store_timing_widget.dart';
import 'shop_rating.dart';
import '../repository/order_repository.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';
import '../elements/offer_slider_widget.dart';
import '../elements/search_widget_re.dart';
import '../components/Shimmer/store_detail_shimmer_widget.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/vendor_controller.dart';
import '../elements/bottom_bar_widget.dart';
import '../elements/product_box1_widget.dart';
import '../models/restaurant_product.dart';
import '../models/vendor.dart';

// ignore: must_be_immutable
class StoreViewDetails extends StatefulWidget {
  Vendor shopDetails;
  int shopTypeID;

  StoreViewDetails({
    Key key,
    this.shopDetails,
    this.shopTypeID,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StoreViewDetailsState createState() => _StoreViewDetailsState();
}

class _StoreViewDetailsState extends StateMVC<StoreViewDetails>
    with SingleTickerProviderStateMixin {
  VendorController _con;

  _StoreViewDetailsState() : super(VendorController()) {
    _con = controller;
  }

  final controller1 = ScrollController();
  double itemsCount = 25;

  // ignore: non_constant_identifier_names

  bool popperShow = false;

  @override
  void initState() {
    super.initState();

    _con.listenForRestaurantProduct(
        int.parse(widget.shopDetails.shopId), loaderMenuSwap);

    currentCheckout.value.deliverType ??= 1;
  }

  loaderMenuSwap() {
    tabController = TabController(length: _con.vendorResProductList.length, vsync: this);
  }






  void moveSwap(int nextPage) {
    tabController.animateTo(nextPage);
    VerticalScrollableTabBarStatus.setIndex(nextPage);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  double expandHeight;
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    expandHeight = 260;
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: _con.tempVendorResProductList.length,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FancyFab(
            product: _con.tempVendorResProductList, moveSwap: moveSwap),
        body: _con.tempVendorResProductList.isEmpty
            ? SingleChildScrollView(
                child: Column(children: const [
                StoreDetailShimmerWidget(),
                RectangularLoaderWidget()
              ]))
            : VerticalScrollableTabView(
                tabController: tabController,
                listItemData: _con.tempVendorResProductList,
                verticalScrollPosition: VerticalScrollPosition.begin,
                eachItemChild: (object, index) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor),
                            child: ExpansionTile(
                                backgroundColor: Theme.of(context).primaryColor,
                                initiallyExpanded: true,
                                iconColor: Theme.of(context).colorScheme.background,
                                collapsedIconColor:
                                    Theme.of(context).colorScheme.background,
                                title: _sectionTitle(
                                    context,
                                    _con.tempVendorResProductList[index]
                                        .category_name),
                                children: [
                                  ProductBox1Widget(
                                    productData: _con
                                        .tempVendorResProductList[index]
                                        .productdetails,
                                    km: widget.shopDetails.distance,
                                    shopDetails: widget.shopDetails,

                                  )
                                ])),
                      ]);
                },
                slivers: [
                  SliverLayoutBuilder(builder: (context, constraints) {
                    return SliverAppBar(
                      shadowColor: transparent,
                      backgroundColor: Theme.of(context).primaryColor,

                      floating: false,
                      pinned: true,
                      //automaticallyImplyLeading: _isVisible,
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            height: 35,
                            width: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: Container(
                                padding: const EdgeInsets.only(left: 4),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(Icons.arrow_back_ios,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 18),
                                ))),
                      ),

                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: false,
                        //titlePadding: const EdgeInsets.only(bottom: 50),
                        title: constraints.scrollOffset >= 350
                            ? Text(widget.shopDetails.shopName,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    .merge(TextStyle(
                                        color:
                                            Theme.of(context).colorScheme.background)))
                            : const SizedBox(),
                        collapseMode: CollapseMode.pin,
                        background: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: size.width,
                                height: 250,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)),
                                        child: Image(
                                            image: widget.shopDetails.cover !=
                                                    'no_image'
                                                ? NetworkImage(
                                                    widget.shopDetails.cover)
                                                : const AssetImage(
                                                    'assets/img/banner1.jpg',
                                                  ),
                                            width: double.infinity,
                                            height: 250,
                                            fit: BoxFit.cover),
                                      ),
                                    ]),
                              ),
                              Positioned(
                                top: 50,
                                right: 20,
                                child: Container(
                                    height: 40,
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context).primaryColor,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0,
                                          ),
                                        ]),
                                    child: FavoriteButton(
                                      iconSize: 40,
                                      isFavorite: _con.checkMyShopList(widget.shopDetails.shopId),
                                      valueChanged: (isFavorite) {
                                        _con.addToFavorite(widget.shopDetails.shopId);
                                      },
                                    )),
                              ),
                              Positioned(
                                top: 95,
                                right: 25,
                                child: Container(
                                    height: 30,
                                    width: 30,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.5),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                            SearchResultWidgetRe(itemDetails: _con.vendorResProductList, shodDetails: widget.shopDetails,)));
                                      },
                                      child: const Icon(
                                        Icons.search,
                                      ),
                                    )),
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        clipBehavior: Clip.none,
                                        children: [
                                          AnimatedContainer(
                                            margin: const EdgeInsets.only(
                                                left: 20, right: 20, top: 20),
                                            decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            duration:
                                                const Duration(seconds: 0),
                                            width: double.infinity,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12
                                                          .withOpacity(0.2),
                                                      blurRadius: 1,
                                                      spreadRadius: 0.3,
                                                    ),
                                                  ],
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10,
                                                              left: 0,
                                                              right: 10),
                                                      child: Row(children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle),
                                                              height: 50,
                                                              width: 50,
                                                              child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              100),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      Navigator.of(context).pushNamed(
                                                                          '/shop_info',
                                                                          arguments:
                                                                              widget.shopDetails);
                                                                    },
                                                                    child: Image
                                                                        .network(
                                                                      widget
                                                                          .shopDetails
                                                                          .logo,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ))),
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  widget
                                                                      .shopDetails
                                                                      .shopName,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .displayMedium
                                                                      .merge(TextStyle(
                                                                          color:
                                                                              Theme.of(context).colorScheme.background))),
                                                              Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 5),
                                                                  child: Row(
                                                                      children: [
                                                                        const Icon(Icons.location_on,
                                                                            color: Colors.red,
                                                                            size: 20),
                                                                        Expanded(
                                                                            child:
                                                                                RichText(
                                                                                  maxLines: 1,
                                                                          text: TextSpan(
                                                                              text: widget.shopDetails.locationMark,

                                                                              style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(color: Color(0xFF8c98a8))),
                                                                              children: [
                                                                                TextSpan(text: ' | ${Helper.priceDistance(widget.shopDetails.distance)}', style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(fontWeight: FontWeight.bold)))
                                                                              ]),
                                                                        ))
                                                                      ])),
                                                            ],
                                                          ),
                                                        )),
                                                      ]),
                                                    ),
                                                    Center(
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 2,
                                                                  left: 2),
                                                          child: Text(
                                                              widget.shopDetails
                                                                  .subtitle,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor))),
                                                    ),
                                                    Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 8,
                                                                bottom: 10),
                                                        child: Wrap(
                                                          children: [
                                                            Div(
                                                                colS: 3,
                                                                colM: 3,
                                                                colL: 3,
                                                                child:
                                                                    Container(
                                                                        padding:
                                                                            const EdgeInsets
                                                                                .only(
                                                                          left:
                                                                              10,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            InkWell(
                                                                                onTap: () {
                                                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RatingReviews(vendorid: int.parse(widget.shopDetails.shopId),)));
                                                                                },
                                                                                child: const Icon(Icons.star, color: Colors.orange)),
                                                                            Expanded(
                                                                                  child: Container(
                                                                                      padding: const EdgeInsets.only(left: 3),
                                                                                      child: Text(
                                                                                        '${widget.shopDetails.ratingNum}(${widget.shopDetails.ratingTotal})',
                                                                                        style: Theme.of(context).textTheme.bodyMedium,
                                                                                      )),
                                                                            )
                                                                          ],
                                                                        ))),
                                                            Div(
                                                                colS: 4,
                                                                colM: 4,
                                                                colL: 4,
                                                                child:
                                                                    Row(
                                                                  children: [
                                                                    Image.asset(
                                                                        'assets/img/clock.png',
                                                                        height:
                                                                    25,
                                                                        width:
                                                                    25),
                                                                    Expanded(
                                                                        child: Container(
                                                                    padding: const EdgeInsets.only(left: 3),
                                                                    child: Text(
                                                                      '${Helper.calculateTime(double.parse(widget.shopDetails.distance.replaceAll(',', '')), int.parse(widget.shopDetails.handoverTime), false)}',
                                                                      style: Theme.of(context).textTheme.bodyMedium,
                                                                    )))
                                                                  ],
                                                                )),
                                                            Div(
                                                                colS: 5,
                                                                colM: 5,
                                                                colL: 5,
                                                                child:
                                                                    Container(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                10),
                                                                        child:
                                                                        widget.shopDetails.bestSeller?  Row(
                                                                          children: [
                                                                            Image.asset('assets/img/paymentwaiting.gif',
                                                                                height: 25,
                                                                                width: 25),
                                                                          Expanded(
                                                                                child: Container(
                                                                                    padding: const EdgeInsets.only(left: 3),
                                                                                    child: Text(
                                                                                      'Best Seller',
                                                                                      style: Theme.of(context).textTheme.bodyMedium,
                                                                                    )))
                                                                          ],
                                                                        ): Row(
                                                                          children: [
                                                                            Image.asset('assets/img/instant_icon.png',
                                                                                height: 25,
                                                                                width: 25),
                                                                            Expanded(
                                                                                child: Container(
                                                                                    padding: const EdgeInsets.only(left: 3),
                                                                                    child: Text(
                                                                                      Helper.priceDistance(widget.shopDetails.distance),
                                                                                      style: Theme.of(context).textTheme.bodyMedium,
                                                                                    )))
                                                                          ],
                                                                        ))),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          widget.shopDetails.foodType == 'Veg'
                                              ? Positioned(
                                                  top:  Helper.shopOpenStatus(
                                                      widget.shopDetails)
                                                      ?120:0,
                                                  right: 30,
                                                  child: Stack(children: const [
                                                    SizedBox(
                                                        width: 50,
                                                        height: 50,
                                                        child: Image(
                                                            image: AssetImage(
                                                                'assets/img/offer_badge_voilet.png'))),
                                                  ]))
                                              : Container(),
                                          !Helper.shopOpenStatus(
                                                  widget.shopDetails)
                                              ? Positioned(
                                                  top: widget.shopDetails
                                                              .foodType ==
                                                          'Veg'
                                                      ? -100
                                                      : 10,
                                                  left: size.width * 0.21,
                                                  child: Stack(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      children: const [
                                                        SizedBox(
                                                            width: 230,
                                                            height: 230,
                                                            child:
                                                                ClosedAnimation())
                                                      ]))
                                              : Container(),
                                        ]),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      expandedHeight: expandHeight,
                    );
                  }),
                  SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      child: !Helper.shopOpenStatus(widget.shopDetails)
                          ? StoreTimingWidgets(shopDetails: widget.shopDetails):
                           widget.shopDetails.openStatus=='Rain'?CloseBoardWidget(shopDetails: widget.shopDetails,
                             notices: 'Due to the heavy rain, Shop is closed temporarily',
                             animationFile: 'assets/img/rain.json',
                           ):  widget.shopDetails.openStatus=='Busy'?CloseBoardWidget(shopDetails: widget.shopDetails,
                             notices: 'Due to the high orders, Shop is closed temporarily',
                             animationFile: 'assets/img/power.json',
                           )
                          : Container(),
                    ),
                    OfferSliderWidget(
                      shopId: widget.shopDetails.shopId,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Container(
                                margin: const EdgeInsets.only(top:10,bottom:5),
                                child: widget.shopDetails.foodType != 'Veg'
                                    ? SizedBox(
                                    width: double.infinity,
                                    height:44,
                                    child:Wrap(
                                        children:List.generate(productList.length, (index) {
                                          return InkWell(
                                            onTap: (){
                                              for (var l in productList) {
                                                setState(() {
                                                  l.selected = false;
                                                });
                                              }
                                              productList[index].selected = true;
                                              setState(() {

                                                _con.tempVendorResProductList = _con.productFilter(_con.vendorResProductList, productList[index].filter);
                                                _con.globeTabs  = _con.tabMaker();


                                              });
                                            },
                                            child: Container(
                                                margin:const EdgeInsets.only(left :5,right:5),
                                                child:Container(
                                                  padding: const EdgeInsets.only(bottom:5,),
                                                  child:  Container(
                                                    padding:const EdgeInsets.only(left:5,right:5,bottom: 10),
                                                    decoration: BoxDecoration(
                                                      color:  productList[index].selected?const Color(0xFFfcd7bc):Theme.of(context).primaryColor,
                                                      borderRadius: BorderRadius.circular(5),
                                                      boxShadow: [BoxShadow(
                                                          color: Theme.of(context).disabledColor.withOpacity(0.13),
                                                          spreadRadius: 1,
                                                          blurRadius: 6)],
                                                    ),


                                                    child:Container(

                                                        padding: const EdgeInsets.only(left:3,right:3,top:12),

                                                        child:Wrap(
                                                            children:[
                                                              productList[index].type=='Veg'?Container(
                                                                  margin:const EdgeInsets.only(right:5,top:2),

                                                                  decoration: BoxDecoration(
                                                                    color: Theme.of(context).primaryColor,
                                                                    borderRadius: BorderRadius.circular(4),
                                                                    border:Border.all( width: 1,
                                                                        color: Colors.green
                                                                    ),

                                                                  ),
                                                                  child:const Icon(Icons.circle,size:11,color: Colors.green)
                                                              ): productList[index].type=='Non_Veg'?Container(
                                                                  margin:const EdgeInsets.only(right:5,top:2),

                                                                  decoration: BoxDecoration(
                                                                    color: Theme.of(context).primaryColor,
                                                                    borderRadius: BorderRadius.circular(4),
                                                                    border:Border.all( width: 1,
                                                                        color: Colors.brown
                                                                    ),

                                                                  ),
                                                                  child:const Icon(Icons.circle,size:11,color: Colors.brown)
                                                              ):Container(
                                                                  margin:const EdgeInsets.only(right:5,top:2),

                                                                  child:const Icon(Icons.circle,size:11,color: Colors.black)
                                                              ),
                                                              Text( productList[index].name,style:const TextStyle(fontWeight: FontWeight.w600))

                                                            ]
                                                        )
                                                    ),
                                                  ),

                                                )
                                            ),
                                          );
                                        })
                                    )
                                )
                                    : Container()),

                         /* Div(
                            colS: 9,
                            colM: 9,
                            colL: 9,
                            child: const RestaurantOfferFilter(),
                          ) */

                    ),
                  ])),
                  SliverPersistentHeader(
                    floating: false,
                    delegate: SliverAppBarDelegate(
                      TabBar(
                        isScrollable: true,
                        controller: tabController,
                        indicatorColor: Colors.cyan,
                        labelColor: Colors.cyan,
                        unselectedLabelColor: Colors.grey,
                        indicatorWeight: 3.0,
                        tabs: _con.tabMaker(),
                        onTap: (index) {
                          VerticalScrollableTabBarStatus.setIndex(index);
                        },
                      ),
                    ),
                    pinned: true,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, text) {
    return Row(
      children: [
        _buildSectionHoteSaleIcon(),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              .merge(const TextStyle(fontWeight: FontWeight.bold)),
        )
      ],
    );
  }

  Widget _buildSectionHoteSaleIcon() {
    return Container(
      margin: const EdgeInsets.only(right: 4.0),
      child: const Icon(
        Icons.whatshot,
        color: Colors.pink,
        size: 20.0,
      ),
    );
  }
}

class FancyFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final IconData icon;
  final List<RestaurantProduct> product;
  final Function moveSwap;

  const FancyFab(
      {Key key, this.onPressed, this.tooltip, this.icon, this.product, this.moveSwap}) : super(key: key);

  @override
  State<FancyFab> createState() => _FancyFabState();
}

class _FancyFabState extends State<FancyFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      // _animationController.reverse();
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  bool openState = false;

  Widget toggle() {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Container(
          margin: const EdgeInsets.only(bottom: 60, right: 10),
          decoration:BoxDecoration(
            color: transparent,
          ),
          child: Card(
              color: transparent,
              shape: const StadiumBorder(),
              elevation: 5,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color:transparent,
                ),

                // ignore: deprecated_member_use
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (openState) {
                          openState = false;
                          animate();
                        } else {
                          openState = true;
                          animate();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: const StadiumBorder(),
                    ),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        openState
                            ? Container(
                                padding: const EdgeInsets.only(top: 0),
                                child: Icon(
                                  Icons.close,
                                  color: Theme.of(context).primaryColorLight,
                                  size: 20,
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.only(top: 0),
                                child: Icon(
                                  Icons.local_dining,
                                  color: Theme.of(context).primaryColorLight,
                                  size: 20,
                                ),
                              ),
                        openState
                            ? Container(
                                padding: const EdgeInsets.only(top: 1),
                                child: Text(
                                  S.of(context).close,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      .merge(TextStyle(
                                          height: 1.0,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          fontWeight: FontWeight.w800)),
                                ))
                            : Container(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  S.of(context).menu,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      .merge(TextStyle(
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                          height: 1.0,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ),
                      ],
                    ))),
              ))),
      const BottomBarWidget(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.bottomRight,
        width: size.width,
        color: openState ? Colors.black12.withOpacity(0.4) : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Visibility(
              maintainState: openState,
              visible: openState,
              child: Transform(
                  transform: Matrix4.translationValues(
                    0.0,
                    _translateButton.value * 1.0,
                    0.0,
                  ),
                  child: Container(
                    height: size.height * 0.55,
                    width: size.width * 0.8,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                          ),
                        ]),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                S.of(context).menu,
                                style: Theme.of(context).textTheme.titleLarge,
                              )
                            ]),
                      ),
                      ListView.separated(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.product.length,
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, int index) {
                            RestaurantProduct product =
                                widget.product.elementAt(index);
                            return InkWell(
                              onTap: () {
                                widget.moveSwap(index);
                                setState(() {
                                  if (openState) {
                                    openState = false;
                                    animate();
                                  } else {
                                    openState = true;
                                    animate();
                                  }
                                });
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(
                                    bottom: 0, left: 15, right: 15),
                                title: Text(
                                  product.category_name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      .merge(const TextStyle(
                                          fontWeight: FontWeight.w300)),
                                ),
                                trailing: Text(
                                  product.productdetails.length.toString(),
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 0);
                          }),
                    ])),
                  )),
            ),
            toggle(),
          ],
        ));
  }
}

class ClosedAnimation extends StatefulWidget {
  const ClosedAnimation({Key key}) : super(key: key);

  @override
  State<ClosedAnimation> createState() => _ClosedAnimationState();
}

class _ClosedAnimationState extends State<ClosedAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller2;

  @override
  void initState() {
    super.initState();

    _controller2 = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Lottie.asset(
      'assets/img/closed.json',
      controller: _controller2,
      animate: true,
      onLoaded: (composition) {
        // Configure the AnimationController with the duration of the
        // Lottie file and start the animation.
        _controller2
          ..duration = composition.duration
          ..forward();
      },
    );
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      color: Theme.of(context).primaryColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  Delegate({
    @required this.child,
    this.minHeight = 56.0,
    this.maxHeight = 56.0,
  });

  final Widget child;
  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(Delegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class ProductFilter {
  ProductFilter({this.type, this.name, this.filter, this.selected});
  String type;
  String name;
  String filter;
  bool selected;
}

List<ProductFilter> productList = <ProductFilter>[
  ProductFilter(type: 'All', name: 'All', filter: 'All',selected: true),
  ProductFilter(type: 'Veg', name: 'Veg', filter: 'Veg', selected: false),
  ProductFilter(type:  'Non_Veg', name: 'Non Veg', filter: 'Non_Veg', selected: false),
];