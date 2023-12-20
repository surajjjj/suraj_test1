import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BannerShimmerWidget extends StatefulWidget {
  const BannerShimmerWidget({Key key}) : super(key: key);



  @override
  State<BannerShimmerWidget> createState() => _BannerShimmerWidgetState();
}

class _BannerShimmerWidgetState extends State<BannerShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).disabledColor.withOpacity(0.2),
        period: const Duration(seconds: 2),
        child:Container(
          margin:const EdgeInsets.only(left:15,right:15),
          child: Container(
              height: 150,
              width: size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,

                borderRadius: BorderRadius.circular(15),
              ),
              child: const Text('')
          )
      ),


    );
  }
}
