import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RestaurantOfferFilter extends StatefulWidget {
  const RestaurantOfferFilter({Key key}) : super(key: key);


  @override
  State<RestaurantOfferFilter> createState() => _RestaurantOfferFilterState();
}

class _RestaurantOfferFilterState extends State<RestaurantOfferFilter> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    return  Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height:44,
          child:ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.only(right:10,left:10,),
              itemBuilder: (context, index) {

                return  Container(
                    margin:const EdgeInsets.only(left :5),
                    child:Container(
                      padding: const EdgeInsets.only(bottom:5,),
                      child:  Container(
                        margin: const EdgeInsets.only(right:5),

                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),


                          child:Container(

                              padding: const EdgeInsets.only(left:10,right:10,top:12),

                              child:const Text('Best seller',

                              )
                          ),






                      ),

                    )
                );
              }
          ),
        ),


      ],
    );
  }

}


