import 'package:flutter/material.dart';
import '../models/vendor.dart';

import '../helpers/helper.dart';




// ignore: must_be_immutable
class StoreTimingWidgets extends StatefulWidget {
  Vendor shopDetails;
  StoreTimingWidgets({Key key, this.shopDetails}) : super(key: key);
  @override
  State<StoreTimingWidgets> createState() => _StoreTimingWidgetsState();
}

class _StoreTimingWidgetsState extends State<StoreTimingWidgets> {

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
                       Text('Opens at',
                       style: Theme.of(context).textTheme.titleLarge,
                       ),
                      Text('This outlet usually next opens for delivery from ${Helper.nextOpenTime(widget.shopDetails)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),



                    ]
                  )
              ),
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: 100,height:80,
                  child: Image.asset('assets/img/closednow.png',
                  fit: BoxFit.fill,
                  ),
                )
              )
            ]
        )
    );
  }
}