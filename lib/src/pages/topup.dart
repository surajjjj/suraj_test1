import 'package:flutter/material.dart';
import '../components/light_color.dart';
import '../components/title_text.dart';
import '../controllers/wallet_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({Key key}) : super(key: key);

  @override
  TopUpPageState createState() => TopUpPageState();
}

class TopUpPageState extends StateMVC<TopUpPage> {
  final TextEditingController textEditingController = TextEditingController();
  WalletController _con;
  TopUpPageState() : super(WalletController()) {
    _con = controller;
  }
  var _value = "";
  Align _buttonWidget() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            height: MediaQuery.of(context).size.height * .48,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    children: <Widget>[
                      _countButton("1"),
                      _countButton("2"),
                      _countButton("3"),
                      _countButton("4"),
                      _countButton("5"),
                      _countButton("6"),
                      _countButton("7"),
                      _countButton("8"),
                      _countButton("9"),
                      _icon(Icons.arrow_back_ios_sharp,false),
                      _countButton("0"),
                      _icon(Icons.backspace, false),
                    ],
                  ),
                ),
                _transferButton()
              ],
            )));
  }
  setText(String value) async {


    setState(() {
      _value += value;
      textEditingController.text = _value;
    });
  }

  Widget _transferButton() {
    return InkWell(
      onTap: (){
      _con.recharge(textEditingController.text);

        //_con.showToast("This is demo version", gravity: Toast.BOTTOM, duration: Toast.LENGTH_SHORT);
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: Wrap(
            children: <Widget>[
              Transform.rotate(
                angle: 70,
                child: const Icon(
                  Icons.swap_calls,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              TitleText(
                text: S.of(context).transfer,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          )),
    );
  }

  Widget _icon(IconData icon, bool isBackground) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: (){
                if (_value != null && _value.isNotEmpty) {
                  setState(() {
                    _value = _value.substring(0, _value.length - 1);
                    textEditingController.text = _value;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: isBackground
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Icon(icon),
              ),
            ),

          ],
        ));
  }

  Widget _countButton(String text) {
    return Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
            onTap: () {
              setText(text);
            },
            child: Container(
              alignment: Alignment.center,
              color: Theme.of(context).primaryColor,
              child: Text(
                text,style:Theme.of(context).textTheme.headlineSmall
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,

        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration:const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/img/wallet_card.png'),
              fit: BoxFit.cover
              )
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).topup_your_wallet,
                      style: Theme.of(context).textTheme.titleMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary))
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 210,
                        padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                            color: LightColor.navyBlue2,
                            borderRadius:
                            BorderRadius.all(Radius.circular(15))),
                        child: TextFormField(
                            enabled: false,
                         controller:  textEditingController,
                         style:Theme.of(context).textTheme.headlineMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary))
                        )),
                    const Expanded(
                      flex: 2,
                      child: SizedBox(),
                    )
                  ],
                ),
              ),

              Positioned(
                  left: 0,
                  top: 40,
                  child: Row(
                    children: <Widget>[
                      BackButton(color: Theme.of(context).colorScheme.primary,),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: (){


                        },
                        child: TitleText(
                          text: S.of(context).transfer,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    ],
                  )),
              _buttonWidget(),
            ],
          ),
        ));
  }
}