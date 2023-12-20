
import 'package:flutter/material.dart';
import '../components/light_color.dart';
import '../helpers/helper.dart';
import '../models/wallet.dart';
import '../../generated/l10n.dart';
// ignore: must_be_immutable
class CreditCard extends StatefulWidget {
  CreditCard({Key key, this.card}) : super(key: key);
  Wallet card;
  @override
  State<CreditCard> createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left:15,right:15),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Container(
            width: size.width,
            height:190,
            decoration:const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/img/wallet_card.png'))
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        S.of(context).total_balance,
                        style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color:Theme.of(context).colorScheme.primary))
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          Helper.pricePrint(widget.card.balance),

                            style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w800,
                                color: LightColor.yellow2
                            )
                        ),

                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed('/topUp');
                      },
                      child: Container(
                          width: 85,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(12)),
                              border: Border.all(color: Colors.white, width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add,
                                color: Theme.of(context).colorScheme.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Text(S.of(context).topup,
                                  style: TextStyle(color:Theme.of(context).colorScheme.primary)
                              ),
                            ],
                          )),
                    )
                  ],
                ),

              ],
            ),
          )),
    );
  }
}




