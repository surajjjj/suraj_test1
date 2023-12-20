import 'package:flutter/material.dart';
import '../components/constants.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';
import '../repository/product_repository.dart' as cart_repo;
import '../repository/product_repository.dart';
import '../controllers/cart_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({Key key}) : super(key: key);

  @override
  BottomBarWidgetState createState() => BottomBarWidgetState();
}

class BottomBarWidgetState extends StateMVC<BottomBarWidget> {
  CartController _con;

  BottomBarWidgetState() : super(CartController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: cart_repo.currentCart,

        builder: (context, setting1, _) {


          return currentCart.value.isNotEmpty
              ? Container(
              padding: const EdgeInsets.only(left: 15,top:10,bottom:10, right: 15),
              margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
              decoration: BoxDecoration(
                  color: customeColor1,
                  borderRadius: BorderRadius.circular(18)
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.width * 0.18,

              child: Row(
                children: [

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(text: ' ${currentCart.value.length} ${S.of(context).item} | ',
                                style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight)),
                                children: [
                                  TextSpan(
                                      text: '${Helper.pricePrint(_con.calculateAmount())}',
                                      style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:Theme.of(context).primaryColorLight))
                                  )
                                ]),
                          ),
                          Text('From ${setting.value.appName}',
                            style: Theme.of(context).textTheme.bodySmall.merge(TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(0.8))),
                          )
                        ],
                      ),
                      /*child: Text(
                                '1 Item | ',
                                style: Theme.of(context).textTheme.headline1.merge(TextStyle(color:Theme.of(context).primaryColorLight))
                            )*/
                    ),
                  ),
                  // ignore: deprecated_member_use
                  ElevatedButton(
                    onPressed: () {
                      if (currentUser.value.apiToken != null) {
                        Navigator.of(context).pushNamed('/Checkout');
                      } else {
                        Navigator.of(context).pushNamed('/Login');
                      }
                    },
                    style:ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: transparent, width: 1, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(50)
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      backgroundColor: transparent,
                    ),
                    child: Text(
                      S.of(context).go_cart,
                      style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color: Theme.of(context).primaryColorLight)),
                    ),
                  ),
                ],
              )): Container();

        });
  }
}
