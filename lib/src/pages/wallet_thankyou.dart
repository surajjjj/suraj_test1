import 'package:flutter/material.dart';
import 'dart:async';
import '../../generated/l10n.dart';

// ignore: must_be_immutable
class WThankyou extends StatefulWidget {
  const WThankyou({Key key,}) : super(key: key);

  @override
  WThankyouState createState() => WThankyouState();
}

class WThankyouState extends State<WThankyou> with SingleTickerProviderStateMixin {
  // AudioPlayer advancedPlayer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
    //loadMusic();

  }



  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {


      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.3),
            child: Text(
              S.of(context).thank_you,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.only(
              left: 40,
              right: 40,
            ),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.7),
            child: const Text(
              'Your amount is topup successfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
