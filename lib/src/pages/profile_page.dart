import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import 'shop_all_list.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final googleSignIn = GoogleSignIn();
  //FacebookLogin facebookLogin = FacebookLogin();
  final userData = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var lightBlueColor = Colors.lightBlueAccent.withOpacity(0.15);

    return Scaffold(
      body:   Stack(
          children:[
            Container(
              width: double.infinity,
              height: size.height * 0.4,
              decoration: const BoxDecoration(
                  image:DecorationImage(
                      image:AssetImage('assets/img/cover1.jpg',
                      ),
                      fit: BoxFit.fill
                  )
              ),
              child:Container(
                padding: const EdgeInsets.only( left: 10.0),
                child:Column(
                  children:[
                    Container(
                      margin: const EdgeInsets.only(top:30),
                      child:Row(
                      children: <Widget>[

                        const SizedBox(width: 10.0),
                        Text(S.of(context).profile,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                        ),
                      ],
                    ),),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children:[
                          Container(
                            margin: const EdgeInsets.only(top:30),
                            height: 90.0,
                            width: 90.0,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: GestureDetector(
                              onTap: () {
                                // Imagepickerbottomsheet();
                              },

                              child: currentUser.value.loginVia=='GMail' ?CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  backgroundImage: NetworkImage(userData.photoURL)

                              ):CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: currentUser.value.image != 'no_image' &&  currentUser.value.image != null
                                    ? NetworkImage(currentUser.value.image)
                                    : const AssetImage(
                                  'assets/img/userImage.png',
                                ),
                              ),
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.only(top:10,left:10,right:10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        currentUser.value.name,
                                        style: Theme.of(context).textTheme.headlineSmall,
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(currentUser.value.email,
                                          style:Theme.of(context).textTheme.titleSmall
                                      ),
                                    ],
                                  ),

                                ],
                              )
                          ),

                        ]
                    ),


                  ]
                )
              ),
            ),
            Container(

              margin: EdgeInsets.only(top:size.height * 0.36),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top:10,),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)
                          )),

                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: const EdgeInsets.only(left: 25,top:20),
                                child:Text(S.of(context).menu,style:Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).primaryColorDark)))
                            ),

                            ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top:10,bottom:30),
                              shrinkWrap: true,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/Pages', arguments: 2);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[

                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Icon(
                                              Feather.home,size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                        ),
                                        Expanded(
                                          child:Text(
                                              S.of(context).home,
                                              style: Theme.of(context).textTheme.titleSmall
                                          ),
                                        ),

                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Navigator.of(context).pushNamed('/edit_profile');
                                    setState(() {
                                      currentUser.value;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child:Icon(Feather.settings,size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                        ),
                                        Expanded(child:Text(
                                            S.of(context).settings,
                                            style: Theme.of(context).textTheme.titleSmall

                                        ),),
                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Navigator.of(context).pushNamed('/wallet');
                                    setState(() {
                                      currentUser.value;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child:Icon(  Icons.wallet,size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                        ),
                                        Expanded(child:Text(
                                            S.of(context).wallet,
                                            style: Theme.of(context).textTheme.titleSmall

                                        ),),
                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Navigator.of(context).pushNamed('/Languages');

                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child:Icon(  Icons.translate,size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                        ),
                                        Expanded(child:Text(
                                            S.of(context).language,
                                            style: Theme.of(context).textTheme.titleSmall

                                        ),),
                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),
                                InkWell(
                                  onTap: () async{
                                    var whatsapp =setting.value.customerSupport;
                                    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=Hi ${setting.value.appName}";
                                    // ignore: deprecated_member_use
                                    // android , web
                                    // ignore: deprecated_member_use
                                    if(await canLaunch(whatsappURlAndroid)){
                                      // ignore: deprecated_member_use
                                      await launch(whatsappURlAndroid);
                                    }else{
                                    Helper.toaster('Oops','"whatsapp no installed','error');
                                    
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Icon( Icons.help, size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                        ),
                                        Expanded(child:Text(
                                            S.of(context).support_chat,
                                            style: Theme.of(context).textTheme.titleSmall

                                        ),),
                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),

                                InkWell(
                                  onTap: () {

                                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      return  ShopAllList(pageTitle: 'Favorite Store', type: 'favorite_store',coverImage: 'assets/img/cover1.jpg',);
                                    }));

                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Icon( Icons.store_outlined, size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                        ),
                                        Expanded(
                                          child:Text(
                                              S.of(context).my_favorite_store,
                                              style: Theme.of(context).textTheme.titleSmall

                                          ),),
                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/policy',arguments: 'Privacy Policy');
                                    // Navigator.of(context).pushNamed('/Pages', arguments: 4);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Icon( Icons.privacy_tip_outlined, size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                        ),
                                        Expanded(child:Text(
                                            S.of(context).privacy_policy,
                                            style: Theme.of(context).textTheme.titleSmall

                                        ),),
                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/policy',arguments: 'Return Policy');
                                    // Navigator.of(context).pushNamed('/Pages', arguments: 4);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child: Icon( Icons.assignment_return_outlined, size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                        ),
                                        Expanded(child: Text(
                                            S.of(context).return_policy,
                                            style: Theme.of(context).textTheme.titleSmall

                                        ),),
                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),

                                InkWell(
                                  onTap: () {
                                    if (Theme.of(context).brightness == Brightness.dark) {
                                      // setBrightness(Brightness.light);
                                      setting.value.brightness.value = Brightness.light;
                                    } else {
                                      setting.value.brightness.value = Brightness.dark;
                                      //  setBrightness(Brightness.dark);
                                    }
                                    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                                    setting.notifyListeners();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child:Icon(Feather.cloud_lightning, size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),
                                        ),
                                        Expanded(child:Text(
                                            Theme.of(context).brightness == Brightness.dark ? S.of(context).light_mode : S.of(context).dark_mode,
                                            style: Theme.of(context).textTheme.titleMedium
                                        ),),
                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (currentUser.value.apiToken != null) {
                                      if(currentUser.value.loginVia=='Fb') {
                                        //FacebookAuth.instance.logOut();
                                      }
                                      if(currentUser.value.loginVia=='GMail') {
                                        googleSignIn.disconnect();
                                        FirebaseAuth.instance.signOut();
                                      }

                                      logout().then((value) async {
                                        if(currentUser.value.loginVia=='GMail') {
                                          await googleSignIn.disconnect();
                                          await FirebaseAuth.instance.signOut();
                                        }


                                        // ignore: use_build_context_synchronously
                                        toaster('Success !','${S.of(context).logout} ${S.of(context).successfully}','success');

                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false, arguments: 1);
                                      });
                                    } else {
                                      Navigator.of(context).pushNamed('/Login');
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 25,top:13,right:10),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin :const EdgeInsets.only(right:18),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: lightBlueColor,
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                          child:Icon(Feather.log_out, size:20,
                                              color: Theme.of(context).primaryColorDark
                                          ),),
                                        Expanded(child:Text(
                                            S.of(context).logout,
                                            style: Theme.of(context).textTheme.titleMedium
                                        ),),
                                        IconButton(onPressed: (){},
                                            iconSize: 17,
                                            color: Theme.of(context).disabledColor,
                                            icon:const Icon(Icons.arrow_forward_ios_outlined)
                                        )

                                      ],
                                    ),

                                  ),
                                ),



                                const SizedBox(height:50)



                              ],
                            )



                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )


          ]
      ),

    );
  }


  toaster(title, message, type){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: type=='success'?Colors.green:
        type=='error'?Colors.red:Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

}


