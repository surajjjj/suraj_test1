import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class AddressBoxLoaderWidget extends StatelessWidget {
   AddressBoxLoaderWidget({Key key}) : super(key: key);
  var shimmerColor = Colors.grey[300];
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left:10,right:10,top:15),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text('SELECT DELIVERY LOCATION',style:Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).hintColor))),
              const SizedBox(height:20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:[
                    const Align(
                        alignment:Alignment.topLeft,
                        child:Icon(Icons.location_on_outlined,size:30)
                    ),
                    Expanded(
                        child:Container(
                            padding: const EdgeInsets.only(left:10),
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Text('Please Wait...',style:Theme.of(context).textTheme.displayMedium),

                                ]
                            )

                        )
                    )
                  ]
              ),
              const SizedBox(height:20),
              Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: shimmerColor,
                period: const Duration(seconds: 2),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[

                      Container(
                          decoration: BoxDecoration(
                              color: shimmerColor,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          height: 10,
                          width: double.infinity,
                          padding: const EdgeInsets.only(right:30),
                          child:const Text('',
                          )
                      ),
                      Container(
                          margin: const EdgeInsets.only(top:10),
                          decoration: BoxDecoration(
                              color: shimmerColor,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          height: 10,
                          width: 200,
                          padding: const EdgeInsets.only(right:30),
                          child:const Text('',
                          )
                      ),
                      Container(
                        margin: const EdgeInsets.only(top:15),
                        width: double.infinity,
                        height:45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: shimmerColor,
                        ),

                      )
                    ]),
              )
            ]
        )

    );
  }
}
