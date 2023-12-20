import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoreDetailShimmerWidget extends StatefulWidget {
  const StoreDetailShimmerWidget({Key key}) : super(key: key);

  @override
  State<StoreDetailShimmerWidget> createState() => _StoreDetailShimmerWidgetState();
}

class _StoreDetailShimmerWidgetState extends State<StoreDetailShimmerWidget> {
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Shimmer.fromColors(
          baseColor: Theme.of(context).primaryColor,
          highlightColor: Colors.grey[300],
          period: const Duration(seconds: 2),
          child:Container(
            height: 250,
            width:double.infinity,
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight:Radius.circular(50) ),
            ),
          ),

        )
    );

  }
}
