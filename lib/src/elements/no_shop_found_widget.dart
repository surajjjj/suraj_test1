import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import 'lottie_animation_widget.dart';
//ignore: must_be_immutable
class NoShopFoundWidget extends StatefulWidget {
  double value;
  NoShopFoundWidget({Key key,this.value=0}) : super(key: key);

  @override
  State<NoShopFoundWidget> createState() => _NoShopFoundWidgetState();
}

class _NoShopFoundWidgetState extends State<NoShopFoundWidget> {
  bool loading = true;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      children:[
        Container(
          height:Helper.mediaSize(context, 'height',widget.value==0?0.3:widget.value),
        ),

            SizedBox(
              height:150,
              child:LottieAnimationWidget(jsonData: 'assets/img/empty.json',)
            ),
            Container(
              margin: const EdgeInsets.only(top:10),
              child:Text(S.of(context).shop_not_found,
              style: Theme.of(context).textTheme.bodySmall,
              )
            )





      ]
    ));



  }
}
