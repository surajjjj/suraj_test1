import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../models/shop_rating.dart';
import 'package:badges/badges.dart' as badges;



// ignore: must_be_immutable
class ReviewBox1 extends StatefulWidget {
  ShopRatingModel ratingDetails;
  ReviewBox1({Key key, this.ratingDetails}) : super(key: key);
  @override
  State<ReviewBox1> createState() => _ReviewBox1State();
}

class _ReviewBox1State extends State<ReviewBox1> {


  bool viewMore =true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AspectRatio(aspectRatio: 1.4,
        child:Container(
            margin: const EdgeInsets.only(left:20,top:20,bottom:20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius:BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.2),
                  blurRadius: 1,
                  spreadRadius:0.1,
                ),
              ],

            ),

            child:ClipRRect(
              //borderRadius: BorderRadius.all(Radius.circular(10)),
              borderRadius: BorderRadius.circular(15),
              child:Container(
                  padding: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),),
                  child:Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 66,
                            width:66,
                            margin: const EdgeInsets.only(top:10,),
                            alignment: Alignment.bottomRight,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:Theme.of(context).primaryColor,
                            ),
                            child:ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Image.network(  widget.ratingDetails.image, height: 66,width:66,
                                  fit: BoxFit.cover,)

                            ),
                          ),

                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(left:10,right:10,top:10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Container(
                                        padding: const EdgeInsets.only(top:3),
                                        child: Text(
                                          widget.ratingDetails.buyer,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),


                                      ),

                                      Container(
                                        padding:const EdgeInsets.only(top:4),
                                        child: Container(
                                            padding:const EdgeInsets.only(top:2,),
                                            child:Text('',
                                                style:Theme.of(context).textTheme.bodySmall.
                                                merge(TextStyle(height:1.0,color:Theme.of(context).colorScheme.background.withOpacity(0.6)))
                                            )
                                        ),),

                                      SizedBox(height:size.height * 0.01),
                                    ]),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left:10,top:3),
                                    child:badges.Badge(
                                        toAnimate: false,
                                        elevation: 0,
                                        shape: BadgeShape.square,
                                        padding: const EdgeInsets.only(left:6,right: 6,top:3,bottom:3),
                                        badgeColor: Theme.of(context).primaryColorDark,
                                        borderRadius: BorderRadius.circular(8),
                                        badgeContent: Wrap(
                                          children: [

                                            Text(widget.ratingDetails.rate.toString(),
                                              style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(height: 1.2,color: Theme.of(context).colorScheme.primary)),
                                            ),
                                            Container(
                                              padding:const EdgeInsets.only(left:2),
                                              child: Icon(Icons.star,size:15,color:Theme.of(context).colorScheme.primary),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),
                          child:Text(  widget.ratingDetails.message,
                              overflow:TextOverflow.ellipsis,maxLines: 3,
                              style:Theme.of(context).textTheme.bodySmall
                          )
                      ),
                   /*   Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                                padding: const EdgeInsets.only(top:5,left:5,right:5,bottom:5),

                                child:Text('Read more',style: Theme.of(context).textTheme.bodyText1.merge(TextStyle(color: Theme.of(context).primaryColorDark)),)
                            ),),
                        ],
                      ), */



                    ],
                  )
              ),



            )
        ));
  }
}
