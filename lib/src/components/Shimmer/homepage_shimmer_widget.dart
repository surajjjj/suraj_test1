import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class HomePageShimmerWidget extends StatefulWidget {
  const HomePageShimmerWidget({Key key}) : super(key: key);



  @override
  State<HomePageShimmerWidget> createState() => _HomePageShimmerWidgetState();
}

class _HomePageShimmerWidgetState extends State<HomePageShimmerWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Shimmer.fromColors(
      baseColor: Theme.of(context).primaryColor,
    highlightColor: Theme.of(context).disabledColor.withOpacity(0.2),
    period: const Duration(seconds: 2),

    child:SingleChildScrollView(
        child:Column(
      children:[
        Container(
          height: size.height * 0.12,
          color:Theme.of(context).colorScheme.background,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: 170,
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
        ),
        Container(
          height: 20,
          padding: const EdgeInsets.only(left:20,right: 10),
          child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
             Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(3)
                      ),
                      height:10,width:size.width * 0.3
                  ),
                Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(3)
                    ),
                    height:10,width:size.width * 0.3
                ),


              ]
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 20,
          children:List.generate(4, (index) {
            return Container(
              margin:const EdgeInsets.only(left:5,right:5),
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

                    ]
                ),
              ),
            );
          })
        ),

        Container(
            margin: const EdgeInsets.only(top:15,bottom: 80),
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
        )),




      ]
    ))

    );
  }
}
