import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BestRestaurantShimmerWidget extends StatefulWidget {
  const BestRestaurantShimmerWidget({Key key}) : super(key: key);
  @override
  State<BestRestaurantShimmerWidget> createState() => _BestRestaurantShimmerWidgetState();
}

class _BestRestaurantShimmerWidgetState extends State<BestRestaurantShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
        baseColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).disabledColor.withOpacity(0.2),
        period: const Duration(seconds: 2),
        child:SizedBox(
          height: size.height* 0.33,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: 10,
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (context, int index) {

              return Container(
                margin:const EdgeInsets.only(left:15,right:15),
                  child: Container(
                      margin:const EdgeInsets.only(),
                      height: size.height* 0.33,
                      width: size.width * 0.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,

                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('')
                  )
              );

            },),
        )

    );
  }
}
