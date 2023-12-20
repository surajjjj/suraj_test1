import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

class RestaurantShimmerWidget extends StatefulWidget {
  const RestaurantShimmerWidget({Key key}) : super(key: key);



  @override
  State<RestaurantShimmerWidget> createState() => _RestaurantShimmerWidgetState();
}

class _RestaurantShimmerWidgetState extends State<RestaurantShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
        baseColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).disabledColor.withOpacity(0.2),
        period: const Duration(seconds: 2),
        child:Container(
          padding: const EdgeInsets.only(left:15,right:15),
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Container(
                    height: 20,width:size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,

                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                Container(
                  height: 18,width:size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,

                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    '',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),


              const SizedBox(
                height: 10,
              ),

            ]))

    );
  }
}
