
import 'package:favorite_button/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/vendor_controller.dart';
import '../elements/custome_page_view.dart';
import '../helpers/helper.dart';
import '../models/vendor.dart';
import '../pages/store_detail.dart';
//ignore: must_be_immutable
class BestRestaurantsWidget extends StatefulWidget {

  List<Vendor>vendorList;
  BestRestaurantsWidget({Key key, this.vendorList}) : super(key: key);


  @override
  BestRestaurantsWidgetState createState() => BestRestaurantsWidgetState();
}

class BestRestaurantsWidgetState extends StateMVC<BestRestaurantsWidget> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  PageController _ctrl;

  int currentPage = 0;

  VendorController _con;

  BestRestaurantsWidgetState() : super(VendorController()) {
    _con = controller;
  }


  @override
  void initState() {
    _controller = AnimationController(

      duration: const Duration(
      milliseconds: 650
      ),
      vsync: this,
    )..forward();
    _animation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInCubic,
    ));


    _ctrl = PageController(
      initialPage: 0,
      viewportFraction: 0.67,
    );
    _ctrl.addListener(() {
      int next = _ctrl.page.round();

      if(currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });

    super.initState();
  }
  @override
  void dispose(){
    _ctrl.dispose();
    _controller.dispose();
    super.dispose();

  }
  _buildStoryPage(bool active,Vendor vendorDetails ) {
    // Animated Properties

    final double top = active ? 10 : 35;
    final double bottom = active ? 0 : 35;

    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left:19),
          child:GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    StoreViewDetails(shopDetails: vendorDetails,
                      shopTypeID: 2,
                    )));
          },
          child: AnimatedContainer(
              alignment: Alignment.topLeft,
              width: size.width * 0.58,
              height: size.height *0.4 - top - bottom - 7 -8,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutQuint,

              margin: EdgeInsets.only(top: top, bottom: 15,),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image:  vendorDetails.cover!='no_image'?NetworkImage(vendorDetails.cover):const AssetImage('assets/img/groceryintro2.png'),
                  ),

              ),
              foregroundDecoration:!Helper.shopOpenStatus(vendorDetails)?  BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.saturation
              ):null,
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.7, 1.0],
                        colors: [
                          Color(0x00000000),
                          Color(0x00000000),
                          Color(0xff000000),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 20,
                      left: 20,
                      child:Stack(children:[
                        Container(
                            margin: const EdgeInsets.only(right:15),
                             decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            
                              child:   Container(
                            
                                  padding: const EdgeInsets.all(8),
                                  child:Wrap(
                                      children:[
                                        Text('${vendorDetails.ratingNum} ',
                                        style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                        ),
                                        Container(
                                            margin:const EdgeInsets.only(right:5,top:3),


                                            child:const Icon(Icons.star,size:11,color:Colors.orange)
                                        ),
                                        Text('(${vendorDetails.ratingTotal})',
                                          style: Theme.of(context).textTheme.bodyMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                                        ),


                                      ]
                                  )

                              ),
                            

                        ),
                      ]
                      )


                  ),

                  Positioned(
                      bottom:20,left:10,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[
                            Container(
                              margin: const EdgeInsets.only(bottom:5),
                                child:Wrap(
                                  children: [
                                    Container(
                                        margin:const EdgeInsets.only(left:7),

                                        child:Container(
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF8c98a8).withOpacity(0.75),
                                            borderRadius: BorderRadius.circular(10),
                                          ),

                                            child: Center(
                                              child:  Container(
                                                  padding: const EdgeInsets.only(right:5,left:5),
                                                  child:Text(vendorDetails.subtitle,
                                                      textAlign: TextAlign.center,
                                                      style:TextStyle(color:Theme.of(context).colorScheme.primary,fontSize:8.9)
                                                  )
                                              ),
                                            ),


                                        )

                                    ),

                                  ],
                                )
                            ),
                            Container(
                              padding: const EdgeInsets.only(top:0,left: 10),
                              width: size.width * 0.4,
                              child:Text(vendorDetails.shopName, maxLines: 1,style: Theme.of(context).textTheme.headlineSmall.merge(TextStyle(color:Theme.of(context).primaryColorLight)),),
                            ),

                            Container(
                              padding: const EdgeInsets.only(top:10,left:10),
                              width: size.width * 0.4,
                              child:Text(vendorDetails.locationMark, maxLines: 1, softWrap: true, style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).primaryColorLight)),),
                            ),
                          ]
                      )
                  ),




                  Positioned(
                    top: 20,
                    right:15,
                    child:Container(
                        height: 37,
                        width: 37,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor, boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ]),
                        child: FavoriteButton(
                          iconSize: 40,
                          isFavorite: _con.checkMyShopList(vendorDetails.shopId),
                          valueChanged: (isFavorite) {
                            _con.addToFavorite(vendorDetails.shopId);
                          },
                        )
                    ),
                  ),


                ],
              )

          ),

        ),)

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      height: size.height* 0.4,
      padding: EdgeInsets.zero,
      child: CustomPageView(
        viewportDirection: false,
        controller: _ctrl,
        children: List.generate(widget.vendorList.length, (index) {
          bool active = index == currentPage;
          Vendor vendorDetails = widget.vendorList.elementAt(index);
          return  SlideTransition(
            position: _animation,
            transformHitTests: true,

            textDirection: TextDirection.ltr,
            child: _buildStoryPage(active, vendorDetails)
          );
         /* return _buildStoryPage(active,);*/
        }),
      ),
    );

  }

}





