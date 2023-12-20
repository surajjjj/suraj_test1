import 'package:flutter/material.dart';

import '../elements/my_introview.dart';





class IntroScreen extends StatefulWidget {
  const IntroScreen({Key key}) : super(key: key);



  @override
  // ignore: library_private_types_in_public_api
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {





  @override
  void initState() {
    super.initState();

  }

  goTONextPage(){

    Navigator.of(context).pushReplacementNamed('/Login');
  }
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyIntroView(
          pages: <Widget>[
            Image.asset("assets/img/intro_screen_1.jpg", fit: BoxFit.fill),
            Image.asset("assets/img/intro_screen_2.png", fit: BoxFit.fill),
            Image.asset("assets/img/intro_screen3.jpg", fit: BoxFit.fill),
          ],
          onIntroCompleted: () {
            Navigator.of(context).pushReplacementNamed('/location');

            // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
            //To the navigation stuff here
          },
        )
    );
  }
}
