import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;
  bool firstLoad = false;
  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();

    loadData();


  }

  void loadData() {
    double progress = 0;

    _con.progress.addListener(() {
      // ignore:
      for (double progress1 in _con.progress.value.values) {
        progress += progress1;
        if (kDebugMode) {
          print(progress);
        }
      }
      if (progress == 100) {
        try {
          currentUser.value.firstLoad = true;

          if(currentUser.value.auth!=false && currentUser.value.auth!= null){
            if(currentUser.value.latitude!=0.0 && currentUser.value.longitude!=0.0) {
              if(firstLoad==false) {
                setState(() {
                  firstLoad = true;
                });
                //Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                if (setting.value.version == setting.value.appVersion) {

                  if( currentUser.value.locationType=='manual'){
                    Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
                  } else {
                    Navigator.of(context).pushReplacementNamed('/location');
                  }

                }else{
                  Navigator.of(context).pushReplacementNamed('/force_update');
                }

              }
            }else{
              Navigator.of(context).pushReplacementNamed('/location');
            }
          }else {
            Navigator.of(context).pushReplacementNamed('/introscreen');


          }



        // ignore: empty_catches
        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width:double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            image: const DecorationImage(
              image: AssetImage('assets/img/splash1.png',
              ),
              fit: BoxFit.cover,
            )
        ),
        child:Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/logo.png',
                width: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
