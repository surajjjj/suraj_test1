import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class RectangularLoaderWidget extends StatefulWidget {
  const RectangularLoaderWidget({Key key}) : super(key: key);

  @override
  State<RectangularLoaderWidget> createState() => _RectangularLoaderWidgetState();
}

class _RectangularLoaderWidgetState extends State<RectangularLoaderWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child:Column(children:[
        Column(
      children:List.generate(4, (index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).primaryColor,
          highlightColor: Colors.grey[300],
          period: const Duration(seconds: 2),
          child:Container(
            padding: const EdgeInsets.only(top: 10,left:5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Flexible(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              margin: const EdgeInsets.only(left:10,bottom:10,right:10),
                              height:10,width:double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left:10,bottom:10,right:10),
                              height:10,width:size.width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left:10,bottom:10,right:10),
                              height:10,width:size.width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Wrap(children: [
                              Container(
                                margin: const EdgeInsets.only(left:10,bottom:10,right:10),
                                height:10,width:size.width * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left:10,bottom:10,right:10),
                                height:10,width:size.width * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left:10,bottom:10,right:10),
                                height:10,width:size.width * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left:10,bottom:10,right:10),
                                height:10,width:size.width * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: Colors.grey,
                                ),
                              ),
                            ]),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin:const EdgeInsets.only(right:15),
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

        );
      })
    )]));

  }
}
