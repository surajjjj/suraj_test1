import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryShimmerWidget extends StatefulWidget {
  const CategoryShimmerWidget({Key key}) : super(key: key);



  @override
  State<CategoryShimmerWidget> createState() => _CategoryShimmerWidgetState();
}

class _CategoryShimmerWidgetState extends State<CategoryShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
        baseColor: Theme.of(context).primaryColor,
        highlightColor: Theme.of(context).disabledColor.withOpacity(0.2),
        period: const Duration(seconds: 2),
        child: SizedBox(
          height: size.height* 0.15,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (context, int index) {

              return Container(
                  margin:const EdgeInsets.only(left:15,right:15),
                  child:Container(
                    padding: const EdgeInsets.only(bottom:10),
                    child:Column(
                        children:[
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                                width: 70.0,
                                height: 70.0,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/img/united-states-of-america.png')
                                    )
                                )),
                          ),
                          const SizedBox(height:10),
                          Container(
                            height: 12,width:80,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,

                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '',
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ]
                    ),
                  ),
              );

            },),
        )

    );
  }
}
