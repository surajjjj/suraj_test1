import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/address.dart';
import '../models/registermodel.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;
import '../repository/user_repository.dart';
import '../../generated/l10n.dart';

class UserController extends ControllerMVC {
  UserLocal user = UserLocal();
  RegisterModel registerData = RegisterModel();
  bool hidePassword = true;
  Address addressData = Address();
  bool loading = false;
  String otpNumber;

  Map _userObj = {};
  final googleSignIn = GoogleSignIn();
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  GlobalKey<ScaffoldState> scaffoldKeyState;
  TextEditingController emailController;
  TextEditingController phoneController;
  OverlayEntry loader;
  // ignore: non_constant_identifier_names
  RegisterModel register_data = RegisterModel();

  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = GlobalKey<FormState>();
    scaffoldKey = GlobalKey<ScaffoldState>();
    scaffoldKeyState = GlobalKey<ScaffoldState>();
    emailController = TextEditingController();
    phoneController = TextEditingController();

    //  listenForAddress();

  }





  handleLogin(){
    Overlay.of(context).insert(loader);
  /*  FacebookAuth.instance.login(
        permissions: ["public_profile", "email"]).then((value) {
      FacebookAuth.instance.getUserData().then((userData) {

        setState(() {
          _userObj = userData;
        });

        registerData.name = _userObj["name"];

        registerData.phone = _userObj["phone"];
        registerData.email_id = _userObj["email"];
        registerData.loginType = 'smart';
        registerData.regVia    = 'Fb';
        registerData.img       = _userObj["picture"]["data"]["url"];

        repository.smartLogin(registerData).then((value) {

          if (value.auth == true) {
            toaster('${S.of(context).register} ${S.of(context).successfully} !','Your info update successfully','success');

            if(currentUser.value.latitude!=0.0 && currentUser.value.longitude!=0.0) {
              gettoken();

             // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
            }else{
              Navigator.of(context).pushReplacementNamed('/location');
            }
          } else {
            // ignore: deprecated_member_use

            toaster('${S.of(context).login} !','Sorry! Your account is blocked','error');
          }
        }).catchError((e) {
          Helper.hideLoader(loader);
        }).whenComplete(() {
          Helper.hideLoader(loader);
        });
      }).onError((error, stackTrace)  {
        Helper.hideLoader(loader);
        toaster('Oops !',S.of(context).this_email_account_exists,'error');
      });
  });
 */


  }

  gettoken() {


    FirebaseMessaging.instance.getToken().then((deviceid) {

      var table = 'user${currentUser.value.id}';
      FirebaseFirestore.instance.collection('devToken').doc(table).set({'devToken': deviceid, 'userId': currentUser.value.id}).catchError((e) {


      }).then((value) {

      });
    });
  }

  void saveAddress(){
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();

      setState(() => currentUser.value.address.add(addressData));

      setCurrentUserUpdate(currentUser.value);
      Navigator.pop(context,true);
    }
  }

  void register() async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      repository.currentUser.value.email = register_data.email_id;
      repository.currentUser.value.phone = register_data.phone;
      repository.currentUser.value.name = register_data.name;
      register_data.regVia = repository.currentUser.value.loginVia;
      currentUser.value.description = register_data.description;
      repository.setCurrentUserUpdate(currentUser.value);
      Overlay.of(context).insert(loader);
      repository.register(register_data).then((value) {
        //toaster('${S.of(context).success} !','Your info update successfully','success');

        Navigator.pop(context, true);
      }).catchError((e) {
        loader.remove();
       // toaster('${S.of(context).error} !',S.of(context).this_email_account_exists,'error');

      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }








  Future googleLogin() async {

    Overlay.of(context).insert(loader);
    final user = await googleSignIn.signIn();
    if (user == null) {
      debugPrint('error');
      Helper.hideLoader(loader);
      return;
    } else {

      final googleAuth = await user.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );


      await FirebaseAuth.instance.signInWithCredential(credential);


      final userData = FirebaseAuth.instance.currentUser;
      registerData.name = userData.displayName;
     // registerData.phone = userData.phoneNumber;
      registerData.email_id = user.email;
      registerData.loginType = 'smart';
      registerData.regVia    = 'GMail';
      registerData.img       = userData.photoURL;


      repository.smartLogin(registerData).then((value) {

        if (value.auth == true) {


          if(currentUser.value.latitude!=0.0 && currentUser.value.longitude!=0.0) {

           toaster('${S.of(context).login} !','${S.of(context).login}${S.of(context).successfully}','success');
            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
          }else{
            Navigator.of(context).pushReplacementNamed('/location');
          }
        } else {
          toaster('${S.of(context).login} !','Sorry! Your account is blocked','error');
        }
      }).catchError((e) {

        loader.remove();

      }).whenComplete(() {
        gettoken();
        Helper.hideLoader(loader);
      });
    }
  }



  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {


    try {
      Overlay.of(context).insert(loader);
      final authCredential =
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);



      if(authCredential?.user != null){


        registerData.name = authCredential.user.displayName;
        registerData.phone = authCredential.user.phoneNumber;
        registerData.email_id = authCredential.user.email;
        registerData.loginType = 'smart';
        registerData.regVia    = 'Phone';
        repository.smartLogin(registerData).then((value) {

          if (value.auth == true) {


            toaster('${S.of(context).login} !','${S.of(context).login}${S.of(context).successfully}','success');
            if(currentUser.value.latitude!=0.0 && currentUser.value.longitude!=0.0) {
              gettoken();

              Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
            }else{
              Navigator.of(context).pushReplacementNamed('/location');
            }
          } else {
            toaster('${S.of(context).login} !','Sorry! Your account is blocked','error');
          }
        }).catchError((e) {
          loader.remove();
        }).whenComplete(() {
          Helper.hideLoader(loader);
        });
      }

    } on FirebaseAuthException catch (e) {

      Helper.hideLoader(loader);
      // ignore: deprecated_member_use
      /*scaffoldKey?.currentState?.showSnackBar((SnackBar(content: Text(e.message))));*/
     toaster('${S.of(context).login} !',e.message,'error');
    }
  }













 /* Future loginWithfacebook(FacebookLoginResult result) async {

    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential =
    FacebookAuthProvider.credential(accessToken.token);
    var a = await FirebaseAuth.instance.signInWithCredential(credential);
    Overlay.of(context).insert(loader);

    registerData.name = a.user.displayName;
    registerData.phone = a.user.phoneNumber;
    registerData.email_id = a.user.email;
    registerData.loginType = 'smart';
    registerData.regVia    = 'Fb';
    registerData.img       = a.user.photoURL;


    repository.smartLogin(registerData).then((value) {

      if (value.auth == true) {

        showToast("${S.of(context).register} ${S.of(context).successfully}", gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
        if(currentUser.value.latitude!=0.0 && currentUser.value.longitude!=0.0) {
          gettoken();

          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
        }else{
          Navigator.of(context).pushReplacementNamed('/location');
        }
      } else {
        // ignore: deprecated_member_use
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).this_email_account_exists),
        ));
      }
    }).catchError((e) {
      loader.remove();
      // ignore: deprecated_member_use
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.of(context).this_email_account_exists),
      ));
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });



    } */

  Future<void> listenForCheckValue(table, col, para, type) async {

    checkValue(table, col, para).then((value) {
      if(value){
        if(type=='Email'){
          setState(() => emailController.text = '');
          // ignore: deprecated_member_use
         /* scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text(S.of(context).this_email_account_exists),
          ));*/
        }
      }
    }).catchError((e) {

    }).whenComplete(() {

    });
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
