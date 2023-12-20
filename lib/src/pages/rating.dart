import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../controllers/order_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../components/constants.dart';
import '../models/order_details.dart';


//ignore: must_be_immutable
class Rating extends StatefulWidget {
  OrderDetailsModel invoiceDetailsData;
  Rating({Key key, this.invoiceDetailsData}) : super(key: key);

  @override
  RatingState createState() => RatingState();
}

class RatingState extends StateMVC<Rating> {


  OrderController _con;

  RatingState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState

    _con.ordersToRatingModel(widget.invoiceDetailsData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
          children:[
            Container(
              width: double.infinity,
              height: 160,
              decoration: const BoxDecoration(
                  image:DecorationImage(
                      image:AssetImage('assets/img/cover3.jpg',
                      ),
                      fit: BoxFit.fill
                  )
              ),
              child:Container(
                  padding: const EdgeInsets.only(top:35,left: 10.0),
                  child:  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 10,top:10,right:10),
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
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              margin:const EdgeInsets.only(top:15),
                              child: Text('Rating',
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                          ]),
                        ),

                      ],
                    ),

                  ])
              ),
            ),
            Container(

              margin: const EdgeInsets.only(top:120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top:20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),
                              topRight:Radius.circular(30) )),

                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child:Container(
                                      padding: EdgeInsets.only(top:size.height * 0.03,left: 15,right:15),
                                      child:Column(
                                        children: [
                                          Text('How was',
                                            style: Theme.of(context).textTheme.headlineLarge.merge(const TextStyle(fontWeight: FontWeight.w900)),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 5,),
                                          Text('The Food Taste',
                                            style: Theme.of(context).textTheme.headlineLarge.merge(const TextStyle(fontWeight: FontWeight.w900)),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )
                                  ),
                                )
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top:size.height * 0.03),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 180,height: 180,
                                      child: Image.asset('assets/img/smiley1.png')
                                  )
                                ],
                              ),
                            ),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Container(
                                    padding: EdgeInsets.only(top:size.height * 0.02),
                                    child:SmoothStarRating(
                                        allowHalfRating: false,
                                        starCount: 5,
                                        rating: 4,
                                        size: 34.0,
                                        color: const Color(0xFFFEBF00),
                                        borderColor: const Color(0xFFFEBF00),
                                        onRated: (e){
                                          _con.ratingData.rating = e.toString();
                                        },
                                        spacing: 0.0),
                                  ),
                                  Text(widget.invoiceDetailsData.addressShop.username,
                                    style: Theme.of(context).textTheme.titleSmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ]
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child:Container(
                        color: Theme.of(context).primaryColor,
                          child:  Container(
                              margin: EdgeInsets.only(top:size.height * 0.01,left:20,right:20,bottom:10),

                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    children: [
                                      Icon(EvaIcons.messageSquare,
                                        color: Theme.of(context).colorScheme.background.withOpacity(0.6),
                                      ),
                                      Container(
                                          padding: const EdgeInsets.only(top:0,left: 10),
                                          child:Text('Add a comment',
                                            style: Theme.of(context).textTheme.titleSmall,
                                          )
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top:10,),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Theme.of(context).dividerColor,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TextFormField(
                                        onChanged: (e){
                                          _con.ratingData.message = e;
                                        },
                                        cursorColor: Theme.of(context).focusColor,
                                        maxLines: 5,
                                        decoration: InputDecoration.collapsed(
                                          hintText: '',
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              .merge(const TextStyle(color: Colors.grey)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 54,
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
                                        borderRadius: const BorderRadius.all(Radius.circular(30.0))
                                    ),

                                    child:ElevatedButton(

                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(transparent),
                                          elevation: MaterialStateProperty.all(0),
                                          shape:MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(30)))
                                      ),
                                      onPressed:(){
                                        Navigator.of(context).pushNamed('/food_rating',arguments: _con.ratingData);
                                      },

                                        child:Text(
                                            'Next',
                                            style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight,height:1.1))
                                        ),

                                    ),
                                  ),
                                ],
                              )
                          )
                      )

                  ),
                ],
              ),
            )


          ]
      ),

    );
  }
}
