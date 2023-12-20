import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrdersShimmerWidget extends StatefulWidget {
  const OrdersShimmerWidget({Key key}) : super(key: key);



  @override
  State<OrdersShimmerWidget> createState() => _OrdersShimmerWidgetState();
}

class _OrdersShimmerWidgetState extends State<OrdersShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:10),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).primaryColor,
    highlightColor: Theme.of(context).disabledColor.withOpacity(0.2),
    period: const Duration(seconds: 2),

      child:SingleChildScrollView(
          child:Column(
        children:List.generate(3, (index) {
          return  Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 2)),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.asset('assets/img/loading.gif', fit: BoxFit.cover),
            ),
          );
        })






      )
      )

    )
    );
  }
}
