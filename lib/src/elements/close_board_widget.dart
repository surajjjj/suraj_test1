import 'package:flutter/material.dart';
import '../models/vendor.dart';
import 'lottie_animation_widget.dart';




// ignore: must_be_immutable
class CloseBoardWidget extends StatefulWidget {
  Vendor shopDetails;
  String notices;
  String animationFile;

  CloseBoardWidget({Key key, this.shopDetails,this.notices,this.animationFile}) : super(key: key);
  @override
  State<CloseBoardWidget> createState() => _CloseBoardWidgetState();
}

class _CloseBoardWidgetState extends State<CloseBoardWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left:10,top:10),
        child:Row(
            children:[
              Expanded(
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                       Text('Closed',
                       style: Theme.of(context).textTheme.displaySmall,
                       ),
                      Text(widget.notices,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),



                    ]
                  )
              ),
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 100,height:80,
                  child: LottieAnimationWidget(jsonData:widget.animationFile),
                )
              )
            ]
        )
    );
  }
}