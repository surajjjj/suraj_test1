import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import '../helpers/helper.dart';

class ForceUpdate extends StatefulWidget {
  const ForceUpdate({Key key}) : super(key: key);


  @override
  State<ForceUpdate> createState() => _ForceUpdateState();
}

class _ForceUpdateState extends State<ForceUpdate>  with SingleTickerProviderStateMixin {



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  Future<void> checkForUpdate() async {

    InAppUpdate.checkForUpdate().then((info) {
      setState(() {

      });
      InAppUpdate.performImmediateUpdate().then((_) {
        setState(() {

        });
      }).catchError((e) {

        showSnack(e.toString());
      });
    }).catchError((e) {

      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: Helper.of(context).onWillPop,

    child:Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/update.png'), fit: BoxFit.cover)),
          ),

         

          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment:Alignment.center,
                  padding: const EdgeInsets.only(left:25,right: 25),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(

                      'New update is available',
                      style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        "The current version of this application is no longer supported. We apologize for any inconvenience we may have caused you",
                        style:Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),),

                SizedBox(
                  height: size.height * 0.1,
                ),






                Container(
                  height:49,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  // ignore: deprecated_member_use
                  child: ElevatedButton(
                    onPressed: () async {
                      checkForUpdate();
                    },

                    style:ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                        'Update Now',
                        style:Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight,fontWeight: FontWeight.bold,))

                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    MaterialButton(
                      onPressed:(){},
                      focusColor: Colors.transparent,
                      child: const Text("Thanks!",),
                    ),


                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),

        ],
      ),
    ));
  }


}
