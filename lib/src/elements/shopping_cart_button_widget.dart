import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart';
import '../repository/product_repository.dart' as cart_repo;
import '../repository/product_repository.dart';

class ShoppingCartButtonWidget extends StatefulWidget {
  const ShoppingCartButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  ShoppingCartButtonWidgetState createState() => ShoppingCartButtonWidgetState();
}

class ShoppingCartButtonWidgetState extends StateMVC<ShoppingCartButtonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: cart_repo.currentCart,
        builder: (context, setting, _) {
          // ignore: deprecated_member_use
          return InkWell(
            onTap: () {
              if (currentUser.value.apiToken != null) {
                if (currentCart.value.isNotEmpty) {
                  Navigator.of(context).pushNamed('/Checkout');
                } else {
                  Navigator.of(context).pushNamed('/EmptyList');
                }
              } else {
                Navigator.of(context).pushNamed('/Login');
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: <Widget>[
                Icon(
                  Icons.shopping_cart_outlined,
                  color: widget.iconColor,
                  size: 28,
                ),
                Container(

                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(minWidth: 15, maxWidth: 15, minHeight: 15, maxHeight: 15),
                  child: Text(
                    currentCart.value.length.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall.merge(
                          TextStyle(color: Theme.of(context).primaryColorLight, fontSize: 10),
                        ),
                  ),
                ),
              ],
            ),

          );
        });
  }
}
