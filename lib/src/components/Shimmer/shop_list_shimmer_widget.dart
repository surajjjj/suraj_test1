import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShopListShimmerWidget extends StatefulWidget {
  const ShopListShimmerWidget({Key key}) : super(key: key);

  @override
  State<ShopListShimmerWidget> createState() => _ShopListShimmerWidgetState();
}

class _ShopListShimmerWidgetState extends State<ShopListShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child:Column(
            children:[
              ListView.separated(
                scrollDirection: Axis.vertical,
                itemCount:6,
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.only(top: 16),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, int index) {

                  return  Shimmer.fromColors(
                    baseColor: Theme.of(context).primaryColor,
                    highlightColor: Colors.grey[300],
                    period: const Duration(seconds: 2),
                    child:Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey,
                      ),
                      height: 200,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 10,left: 10),

                    ),

                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 20);
                },
              ),
            ]
        ));

  }
}
