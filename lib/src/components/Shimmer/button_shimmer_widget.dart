import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ButtonShimmerWidget extends StatefulWidget {
  const ButtonShimmerWidget({Key key}) : super(key: key);

  @override
  State<ButtonShimmerWidget> createState() => _ButtonShimmerWidgetState();
}

class _ButtonShimmerWidgetState extends State<ButtonShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey[300],
      period: const Duration(seconds: 2),
      child:Container(
        padding: const EdgeInsets.only(left:20),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width:MediaQuery.of(context).size.width*0.3,
                height: 40,
                padding: const EdgeInsets.only(top:5,left:13,right:13,bottom:5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,

                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child:   Wrap(
                      children:[

                        Container(
                            padding: const EdgeInsets.only(top:3,left:10,right:5),
                            child:Text('',
                                textAlign: TextAlign.center,
                                style:TextStyle(fontFamily:'Touche W03 Regular',fontWeight: FontWeight.w100,color: Theme.of(context).hintColor)
                            )
                        ),

                      ]
                  ),
                )



            ),
            Container(
                width:MediaQuery.of(context).size.width*0.3,
                height: 40,
                padding: const EdgeInsets.only(top:5,left:13,right:13,bottom:5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,

                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child:   Wrap(
                      children:[

                        Container(
                            padding: const EdgeInsets.only(top:3,left:10,right:5),
                            child:Text('',
                                textAlign: TextAlign.center,
                                style:TextStyle(fontFamily:'Touche W03 Regular',fontWeight: FontWeight.w100,color: Theme.of(context).hintColor)
                            )
                        ),

                      ]
                  ),
                )



            ),
            Container(
                width:MediaQuery.of(context).size.width*0.3,
                height: 40,
                padding: const EdgeInsets.only(top:5,left:13,right:13,bottom:5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,

                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child:   Wrap(
                      children:[

                        Container(
                            padding: const EdgeInsets.only(top:3,left:10,right:5),
                            child:Text('',
                                textAlign: TextAlign.center,
                                style:TextStyle(fontFamily:'Touche W03 Regular',fontWeight: FontWeight.w100,color: Theme.of(context).hintColor)
                            )
                        ),

                      ]
                  ),
                )



            ),
          ],
        ),
      ),


    );
  }
}
