import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart' as repository;
import '../repository/user_repository.dart';
import 'otp.dart';
class MobileLogin extends StatefulWidget {
  const MobileLogin({Key key}) : super(key: key);


  @override
  // ignore: library_private_types_in_public_api
  _MobileLoginState createState() => _MobileLoginState();
}



class SmsAutoFill {
  static SmsAutoFill _singleton;
  static const MethodChannel _channel = MethodChannel('sms_autofill');
  final StreamController<String> _code = StreamController.broadcast();

  factory SmsAutoFill() => _singleton ??= SmsAutoFill._();

  SmsAutoFill._() {
    _channel.setMethodCallHandler(_didReceive);
  }

  Future<void> _didReceive(MethodCall method) async {
    if (method.method == 'smscode') {
      _code.add(method.arguments);
    }
  }

  Stream<String> get code => _code.stream;

  Future<String> get hint async {
    final String hint = await _channel.invokeMethod('requestPhoneHint');


    return hint;
  }

  Future<void> get listenForCode async {
    await _channel.invokeMethod('listenForCode');
  }

  Future<void> unregisterListener() async {
    await _channel.invokeMethod('unregisterListener');
  }


}
class _MobileLoginState extends StateMVC<MobileLogin>  with SingleTickerProviderStateMixin {
  final SmsAutoFill _autoFill = SmsAutoFill();
  final TextEditingController _controllerPhone = TextEditingController();
  String dailCode = setting.value.dailCode;
  String initialCountry = setting.value.isoCode;
  PhoneNumber number = PhoneNumber(isoCode: setting.value.isoCode);
  UserController _con;
  final _firebaseAuth = FirebaseAuth.instance;
  _MobileLoginState() : super(UserController()) {
    _con = controller;
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool showLoading = false;
  String verificationId;
  String countryCode;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    animationController.repeat();
    if(GetPlatform.isAndroid){
      _askPhoneHint();
    }

  }
  @override
  void dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }



  Future<void> _askPhoneHint() async {
    String hint = await _autoFill.hint;

    try {

      var prefix = hint.split(setting.value.dailCode);
      _controllerPhone.text = prefix[1];
    } catch (e){

      // ignore: deprecated_member_use

    }


  }



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _con.scaffoldKeyState,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: size.height,width:size.width,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/loginbg1.jpg'), fit: BoxFit.cover)),

          ),
          Positioned(
            top: size.height * 0.18,
            child:Align(
              alignment: Alignment.center,
              child:SizedBox(

                  height:90,width:90,
                  child:Image.asset('assets/img/logo.png',
                    fit:BoxFit.fill,
                  )
              ),
            )
          ),



          Form(
              key: _con.loginFormKey,
              child:   Center(
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(left:15,right:15,bottom:15),
                        padding: const EdgeInsets.all(16),
                        decoration:BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 10,
                                offset: const Offset(0, 7),
                              ),
                            ],
                            color:Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(7)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              setting.value.loginText,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                               S.of(context).login,
                                style:Theme.of(context).textTheme.titleSmall.merge(const TextStyle(color:Colors.grey))
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [



                                Expanded(
                                  child:SizedBox(

                                  child:  InternationalPhoneNumberInput(
                                    textFieldController:  _controllerPhone,
                                    onInputChanged: (PhoneNumber number) {

                                      setState(() {
                                        dailCode = number.dialCode;
                                      });
                                    },
                                    initialValue: number,
                                    onInputValidated: (bool value) {

                                    },
                                    selectorConfig: const SelectorConfig(
                                      selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                    ),
                                    ignoreBlank: false,

                                    cursorColor: Theme.of(context).primaryColorDark,
                                    inputDecoration: InputDecoration(

                                      focusedBorder:  UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context).primaryColorDark,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(

                                        borderSide: BorderSide(
                                          color: Theme.of(context).disabledColor,
                                          width: 1.0,
                                        ),
                                      ),

                                    ),

                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        .merge(TextStyle(color: Theme.of(context).colorScheme.background)),
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        .merge(TextStyle(color: Theme.of(context).colorScheme.background)),
                                    // initialValue: number,
                                    // textFieldController: controller,
                                    formatInput: false,

                                    onSaved: (PhoneNumber number) {

                                    },
                                  ),
                                ))
                              ],
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                          SizedBox(
                              height: 45,
                              width: double.infinity,
                              // ignore: deprecated_member_use
                              child: ElevatedButton(
                                onPressed: () async {

                                  if(_controllerPhone.text!='') {

                                    Overlay.of(context).insert(_con.loader);
                                    await _auth.verifyPhoneNumber(
                                      phoneNumber: '+$dailCode${_controllerPhone.text}',
                                      verificationCompleted: (
                                          phoneAuthCredential) async {
                                        Helper.hideLoader(_con.loader);
                                      },
                                      verificationFailed: (verificationFailed) async {
                                        Helper.hideLoader(_con.loader);
                                        // ignore: deprecated_member_use
                                     _con.toaster('Oops !',verificationFailed.message,'error');
                                      },
                                      codeSent: (verificationId, resendingToken) async {
                                        this.verificationId = verificationId;
                                        Helper.hideLoader(_con.loader);
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (context) =>
                                                Otp(
                                                  verificationId: verificationId,
                                                  mobileNo: '$dailCode${_controllerPhone
                                                      .text}',)));
                                      },
                                      codeAutoRetrievalTimeout: (
                                          verificationId) async {},
                                    );
                                  } else {
                                    _con.toaster('Oops !','Please enter your number','error');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.secondary,

                                    textStyle: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).colorScheme.primary))
                                ),
                              /*  style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary,),
                                ), */
                                child: Text(
                                    S.of(context).login,


                                ),
                              ),
                            ),
                            const SizedBox(height:30),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 60),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Expanded(
                                      child: Divider(
                                        color: Theme.of(context).dividerColor,
                                        thickness: 1.2,
                                      )),
                                  Text(
                                    " ${S.of(context).or}  ",
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Expanded(
                                      child: Divider(
                                        color: Theme.of(context).dividerColor,
                                        thickness: 1.2,
                                      )),
                                ],
                              ),
                            ),


                            const SizedBox(
                              height: 25,
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Container(
                                    padding: const EdgeInsets.only(left:10,right:10),
                                    child:Wrap(
                                        children:[

                                          Div(
                                            colS:3,
                                            colM:3,
                                            colL:3,
                                            child:MaterialButton(
                                              height: 45,
                                              minWidth: 45,
                                              elevation: 0,
                                              focusElevation: 0,
                                              splashColor: Theme.of(context).primaryColor,
                                              padding: EdgeInsets.zero,
                                              hoverElevation: 0,

                                              shape: const CircleBorder(),
                                              focusColor:  Theme.of(context).primaryColor,
                                              color:Theme.of(context).primaryColor,
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.grey[300]
                                                    )
                                                ),
                                                child: Image.asset('assets/img/g_logo.png',width: 35,
                                                  height: 35,
                                                ),
                                              ),
                                              onPressed: () {
                                                _con.googleLogin();
                                              },
                                            ),

                                          ),
                                          GetPlatform.isIOS?Div(
                                            colS:4,
                                            colM:4,
                                            colL:4,
                                            child:RawMaterialButton(
                                              onPressed: () async{
                                                signInWithApple();


                                              },
                                              elevation: 5.0,
                                              fillColor: Theme.of(context).primaryColor,
                                              padding: const EdgeInsets.all(8.0),
                                              shape: const CircleBorder(),
                                              child: Image.asset('assets/img/apple_logo.png',
                                                width:30,height:30,
                                              ),
                                            ),

                                          ): Div(colS:1,
                                            colM:1,
                                            colL:1,child: Container(),),
                                        1==2 ? Div(
                                            colS:3,
                                            colM:3,
                                            colL:3,
                                            child:MaterialButton(
                                              height: 45,
                                              minWidth: 45,
                                              elevation: 0,
                                              focusElevation: 0,
                                              splashColor: Theme.of(context).primaryColor,
                                              padding: EdgeInsets.zero,
                                              hoverElevation: 0,

                                              shape: const CircleBorder(),
                                              focusColor:  Theme.of(context).primaryColor,
                                              color:Theme.of(context).primaryColor,
                                              child: Container(
                                                height: 45,
                                                width: 45,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.grey[300]
                                                    )
                                                ),
                                                child: Image.asset('assets/img/facebook.png',width: 35,
                                                  height: 35,
                                                ),
                                              ),
                                              onPressed: () {
                                                _con.handleLogin();
                                              },
                                            ),

                                          ):Div(colS:1,
                                          colM:1,
                                          colL:1,child: Container(),),




                                        ]
                                    ),
                                  ),

                                ]
                            ),
                            Container(
                                padding: const EdgeInsets.only(top:10),
                                child:Column(
                                    children:[
                                      Text(S.of(context).by_continuing_you_agree_to_our,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Wrap(
                                          children:[
                                            InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pushNamed('/policy',arguments: 'Terms and Conditions');
                                                },
                                                child:Container(
                                                  padding: const EdgeInsets.only(right:3),
                                                  child:Text('${S.of(context).terms_and_conditions},',
                                                      style:Theme.of(context).textTheme.bodySmall
                                                  ),
                                                )
                                            ),

                                            InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pushNamed('/policy',arguments: 'Privacy Policy');

                                                },
                                                child:Text('${S.of(context).privacy_policy},',
                                                    style:Theme.of(context).textTheme.bodySmall
                                                )
                                            ),
                                            InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pushNamed('/policy',arguments: 'Return Policy');
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.only(right:3),
                                                  child:Text('${S.of(context).return_policy},',style:Theme.of(context).textTheme.bodySmall
                                                  ),
                                                )
                                            ),
                                          ]
                                      ),

                                    ]
                                )
                            ),






                          ],
                        ),
                      )
                    ],
                  )
              )
          ),
        ],
      ),
    );
  }



  // ignore: missing_return
  Future<User> signInWithApple({List<Scope> scopes = const []}) async {

    try {
      // 1. perform the sign-in request
      final result = await TheAppleSignIn.performRequests(
          [AppleIdRequest(requestedScopes: scopes)]);
      // 2. check the result
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
            String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          // ignore: use_build_context_synchronously
          Overlay.of(context).insert(_con.loader);
          final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
          final firebaseUser = userCredential.user;
          _con.registerData.name = firebaseUser.displayName;
          _con.registerData.phone = firebaseUser.phoneNumber;
          _con.registerData.email_id = firebaseUser.email;
          _con.registerData.loginType = 'smart';
          _con.registerData.regVia    = 'Apple';
          repository.smartLogin(_con.registerData).then((value) {

            if (value.auth == true) {
              _con.toaster('${S.of(context).login} !','${S.of(context).login}${S.of(context).successfully}','success');

              if(currentUser.value.latitude!=0.0 && currentUser.value.longitude!=0.0) {
                _con.gettoken();

                Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
              }else{
                Navigator.of(context).pushReplacementNamed('/location');
              }
            } else {
              _con.toaster('${S.of(context).login} !','Sorry! Your account is blocked','error');
              // ignore: deprecated_member_use

            }
          }).catchError((e) {
            _con.loader.remove();
            // ignore: deprecated_member_use
            _con.toaster('${S.of(context).login} !',S.of(context).this_email_account_exists,'error');

          }).whenComplete(() {
            Helper.hideLoader(_con.loader);
          });

          return firebaseUser;
        case AuthorizationStatus.error:
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );

        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
        default:
          throw UnimplementedError();
      }
    }  catch (e) {
      // TODO: Show alert here
   
    }


  }


}

