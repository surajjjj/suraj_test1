
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';



// ignore: must_be_immutable
class PayButtonLoader extends StatefulWidget {
  const PayButtonLoader({Key key}) : super(key: key);

  @override
  State<PayButtonLoader> createState() => _PayButtonLoaderState();
}

class _PayButtonLoaderState extends State<PayButtonLoader> {



  @override
  Widget build(BuildContext context) {
   return  Shimmer.fromColors(
       baseColor: Colors.white,
       highlightColor: Colors.grey[300],
       period: const Duration(seconds: 2),
       child:Container(
           margin: const EdgeInsets.only(top:20),
           alignment:Alignment.bottomCenter,
           child:Wrap(
               alignment: WrapAlignment.end,
               children: [
                 SizedBox(
                   width: MediaQuery.of(context).size.width * 0.5,
                   child: Padding(
                     padding:const EdgeInsets.only(top:5,right:10,left:20,bottom:10),
                     child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                       Container(
                         width: 90,
                         height:15,
                         decoration: BoxDecoration(
                             color: Theme.of(context).colorScheme.secondary,
                             borderRadius: BorderRadius.circular(10)
                         ),
                       ),
                       const SizedBox(height:6),
                       Container(
                         width: 70,
                         height:15,
                         decoration: BoxDecoration(
                             color: Theme.of(context).colorScheme.secondary,
                             borderRadius: BorderRadius.circular(10)
                         ),
                       ),
                     ]),
                   ),
                 ),

                 Container(
                   width: MediaQuery.of(context).size.width * 0.5,
                   height:50,
                   decoration: BoxDecoration(
                       color: Theme.of(context).colorScheme.secondary,
                       borderRadius: BorderRadius.circular(10)
                   ),
                 ),






               ])
       ));
  }
}


