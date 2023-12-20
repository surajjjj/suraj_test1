import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/product_controller.dart';
import '../models/searchisresult.dart';
import '../pages/store_detail.dart';
import 'restaurant_product_box.dart';

// ignore: must_be_immutable
class RestaurantProductSliderWidget extends StatefulWidget {

  List<ItemDetails> itemDetails;
  RestaurantProductSliderWidget({Key key,this.itemDetails}) : super(key: key);

  @override
  RestaurantProductSliderWidgetState createState() => RestaurantProductSliderWidgetState();
}

class RestaurantProductSliderWidgetState extends StateMVC<RestaurantProductSliderWidget>with TickerProviderStateMixin {

  AnimationController _controller;
  Animation<Offset> _animation;
  ProductController _con;
  RestaurantProductSliderWidgetState() : super(ProductController()) {
    _con = controller;

  }



  int intState = 7;
  bool openState =false;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(
          milliseconds: 800
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


    super.initState();
  }
  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
var size= MediaQuery.of(context).size;
    return SizedBox(
        height:250,
        child:ListView.builder(
            shrinkWrap: true,
            itemCount: widget.itemDetails.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {

              return SlideTransition(
                  position: _animation,
                  transformHitTests: true,
                  textDirection: TextDirection.ltr,
                  child:SizedBox(
                    height:200,width:size.width * 0.93,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    StoreViewDetails(shopDetails: widget.itemDetails[index].vendor,
                                      shopTypeID: 2,
                                    )));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top:10),
                            child:Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Container(
                                  margin:const EdgeInsets.only(right:15),
                                  child:const Icon(Icons.star,size:20)
                                ),
                                Expanded(
                                  child:Wrap(
                                    children: [
                                     Container(
                                       margin: const EdgeInsets.only(top:4),
                                       child:Text(widget.itemDetails[index].vendor.shopName,
                                       style: Theme.of(context).textTheme.titleSmall,
                                       ),
                                     ),
                                      Container(
                                          margin: const EdgeInsets.only(left:10),
                                          child:const Icon(Icons.arrow_forward)
                                      )
                                    ],
                                  )

                                ),

                              ]
                            )
                          ),
                        ),
                        RestaurantProductBox(choice: widget.itemDetails[index].productList, con: _con,km:  widget.itemDetails[index].vendor.distance,shopDetails: widget.itemDetails[index].vendor,),
                      ],
                    )
                  )
              );
            }
        ));
  }
  // ignore: non_constant_identifier_names
  callback(){

  }
}


