import 'package:flutter/material.dart';

import 'lottie_animation_widget.dart';

class ServiceNotAvailableWidget extends StatefulWidget {
  const ServiceNotAvailableWidget({Key key}) : super(key: key);

  @override
  State<ServiceNotAvailableWidget> createState() => _ServiceNotAvailableWidgetState();
}

class _ServiceNotAvailableWidgetState extends State<ServiceNotAvailableWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate(<Widget>[

           SizedBox(
              height:150,
              width:double.infinity,
              child:LottieAnimationWidget(jsonData:'assets/img/robot.json'),
          ),
          Container(

              width:double.infinity,
              padding: const EdgeInsets.only(left:20,right:20),
              child:Center(
                  child: Text('We are not delivering here at the moment.Please try again different location or try again later',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).colorScheme.background.withOpacity(0.5))))
              )
          )
        ]
    ));
  }
}

