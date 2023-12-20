
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../controllers/user_controller.dart';
import '../elements/lottie_animation_widget.dart';
// ignore: must_be_immutable
class Otp extends StatefulWidget {

  String verificationId;
  String mobileNo;
  Otp({Key key,
    this.verificationId,
    this.mobileNo,
  }) : super(key: key);
  @override
  OtpState createState() => OtpState();
}

class OtpState extends StateMVC<Otp> {
  final TextEditingController _controllerOTPPhone = TextEditingController();

  UserController _con;
  OtpState() : super(UserController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return KeyboardDismissOnTap(
        child
            :Scaffold(

            resizeToAvoidBottomInset: true,
            body: Container(
              decoration: BoxDecoration(
                color:  Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0)
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: SafeArea(
                                  child:Padding(
                                    padding: const EdgeInsets.only(bottom:2,),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            padding: const EdgeInsets.only(bottom:2,left:4,right:8),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                IconButton(
                                                    icon: Icon(Icons.arrow_back,size: 30, color: Theme.of(context).colorScheme.background),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }
                                                ),


                                              ],
                                            )
                                        ),
                                        SizedBox(
                                            width: 230,height: size.height * 0.3,
                                            child: LottieAnimationWidget(jsonData:'assets/img/otp_verify.json'),
                                        )
                                      ],
                                    ),),
                                ),
                              ),
                              Column(children: [
                                Container(
                                  padding: EdgeInsets.only(top:size.height * 0.05,left:20,right:20),
                                  child: Text('OTP Verification',
                                    style: Theme.of(context).textTheme.headlineMedium,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top:20,left:40,right:40),
                                  child:   Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child:  RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(text: 'We will send you one time password on this ',
                                              style: Theme.of(context).textTheme.bodySmall,

                                              children: [
                                                TextSpan(
                                                    text: 'Mobile Number',
                                                    style:  Theme.of(context).textTheme.bodySmall
                                                )
                                              ]),
                                        ),
                                      )
                                    ],
                                  ),



                                ),
                                Container(
                                    padding: const EdgeInsets.only(top:20,left:40,right:40),
                                    child: Text(
                                        widget.mobileNo,
                                        style: Theme.of(context).textTheme.titleMedium.merge(const TextStyle(fontWeight: FontWeight.w900))
                                    )
                                ),
                                Wrap(
                                  children: [
                                    OTPTextField(
                                      length: 6,
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      textFieldAlignment: MainAxisAlignment.spaceAround,
                                      fieldWidth: 40,
                                      otpFieldStyle: OtpFieldStyle(

                                      ),
                                      style: const TextStyle(
                                        fontSize: 20,
                                      ),
                                      fieldStyle: FieldStyle.underline,
                                      onCompleted: (pin) {
                                        _controllerOTPPhone.text = pin;
                                      },
                                    ),
                                  ],
                                ),



                                Container(
                                  margin: const EdgeInsets.only(top:30,left:20,right:20,bottom:10),
                                  height: 54,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color:Theme.of(context).colorScheme.secondary,
                                      /*gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        colors: <Color>[
                                          Theme.of(context).primaryColorDark,
                                          Theme.of(context).focusColor

                                        ],
                                      ),*/
                                      borderRadius: const BorderRadius.all(Radius.circular(10.0))
                                  ),

                                  child:ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                                        elevation: MaterialStateProperty.all(0),
                                        shape:MaterialStateProperty.all(RoundedRectangleBorder( borderRadius: BorderRadius.circular(10)))
                                    ),
                                    onPressed:(){
                                      PhoneAuthCredential phoneAuthCredential =
                                      PhoneAuthProvider.credential(
                                          verificationId: widget.verificationId, smsCode: _controllerOTPPhone.text);

                                      _con.signInWithPhoneAuthCredential(phoneAuthCredential);
                                    },
                                    child:  Text(
                                        'SUBMIT',
                                        style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight,height:1.1))
                                    ),
                                  ),
                                ),
                              ]),
                            ]),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,

                    child:KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
                      return isKeyboardVisible
                          ? const SizedBox()
                          : Container(
                        margin: const EdgeInsets.only(top:10),
                        height: 54,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,

                        ),
                        // ignore: deprecated_member_use
                        child: Container(
                          padding: const EdgeInsets.only(top:5,left:20,right:20),
                          child:   Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child:  RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(text: 'You have an account ?',
                                      style: Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary.withOpacity(0.7))),

                                      children: [
                                        TextSpan(
                                            text: '  Login',
                                            style: Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w900))
                                        )
                                      ]),
                                ),
                              )
                            ],
                          ),),
                      );
                    }),
                  ),

                ],
              ),
            )
        ));
  }
}






