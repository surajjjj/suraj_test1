import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../../generated/l10n.dart';
import '../components/constants.dart';
import '../controllers/order_controller.dart';
import '../models/rating.dart';


//ignore: must_be_immutable
class FoodRating extends StatefulWidget {
  RatingModel ratingData;
  FoodRating({Key key, this.ratingData}) : super(key: key);

  @override
  FoodRatingState createState() => FoodRatingState();
}

class FoodRatingState extends StateMVC<FoodRating> {


  OrderController _con;

  FoodRatingState() : super(OrderController()) {
    _con = controller;
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
                             child: Text('Food Review',
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

                            Container(
                              margin: const EdgeInsets.only(left:18,right:18,top:0),
                              child:ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                padding: EdgeInsets.zero,
                                itemCount: widget.ratingData.itemReview.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                      children:[
                                        Container(
                                            margin: const EdgeInsets.only(bottom:15),
                                            child:Row(
                                                children:[
                                                  Icon(Icons.fastfood_sharp,
                                                    color: Theme.of(context).colorScheme.background.withOpacity(0.6),
                                                  ),
                                                  Container(
                                                      margin: const EdgeInsets.only(left:15),
                                                      child:Text(widget.ratingData.itemReview[index].productName,
                                                        style: Theme.of(context).textTheme.titleLarge,
                                                      )
                                                  )
                                                ]
                                            )
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                decoration:BoxDecoration(
                                                    borderRadius: BorderRadius.circular(8)
                                                ),child:ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child:Image.network(widget.ratingData.itemReview[index].image,
                                                    height: 120,width:115,fit:BoxFit.cover
                                                ))
                                            ),
                                            Expanded(
                                              child:Container(
                                                  padding: const EdgeInsets.only(left: 15,right:15),
                                                  child:Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('😃 Did you like the taste',
                                                        style: Theme.of(context).textTheme.titleMedium,
                                                      ),
                                                      Container(
                                                          margin:const EdgeInsets.only(top:10),
                                                          child:Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children:[
                                                                SmoothStarRating(
                                                                    allowHalfRating: false,
                                                                    starCount: 5,
                                                                    rating: 4,
                                                                    size: 25.0,
                                                                    onRated: (e){

                                                                      widget.ratingData.itemReview[index].rating = e.toString();
                                                                    },
                                                                    color: const Color(0xFFFEBF00),
                                                                    borderColor: const Color(0xFFFEBF00),
                                                                    spacing: 0.0),
                                                              ]
                                                          )
                                                      ),
                                                      Container(
                                                          margin: const EdgeInsets.only(right:0),
                                                          width: double.infinity,
                                                          child: TextFormField(
                                                              textAlign: TextAlign.left,
                                                              autocorrect: true,
                                                              onChanged: (e){
                                                                widget.ratingData.itemReview[index].message = e;
                                                              },
                                                              keyboardType: TextInputType.text,
                                                              cursorColor: Theme.of(context).focusColor,
                                                              decoration: InputDecoration(
                                                                labelText: 'Write a review for Meals',

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

                                                    ],
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                      ]
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 10);
                                },
                              ),)
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
                                         _con.submitRating(widget.ratingData);
                                      },
                                      child: Text(
                                          S.of(context).done,
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
