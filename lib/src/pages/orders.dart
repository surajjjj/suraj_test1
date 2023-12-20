import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import '../components/Shimmer/orders_shimmer_widget.dart';
import '../controllers/order_controller.dart';

import 'package:mvc_pattern/mvc_pattern.dart';
import '../elements/no_shop_found_widget.dart';
import '../elements/order_item_widget.dart';
import '../elements/shopping_cart_button_widget.dart';
import '../../generated/l10n.dart';
import '../models/order_list.dart';

class OrdersWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  const OrdersWidget({Key key, this.parentScaffoldKey}) : super(key: key);

  @override
  OrdersWidgetState createState() => OrdersWidgetState();
}

class OrdersWidgetState extends StateMVC<OrdersWidget> {

  OrderController _con;

  OrdersWidgetState() : super(OrderController()) {
    _con = controller;
  }

  @override
  void initState() {
   _con.listenForOrders();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).my_orders,
          style: Theme.of(context).textTheme.displayMedium
        ),
        actions: <Widget>[
          ShoppingCartButtonWidget(iconColor: Theme.of(context).colorScheme.background.withOpacity(0.5), labelColor:Theme.of(context).primaryColorLight),
        ],
      ),
      body: AnimationList(
             duration: 2100,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: <Widget>[
                   Row(
                     children:[
                       Expanded(
                           child:Container(
                             margin: const EdgeInsets.all(12),
                             decoration: BoxDecoration(
                                 color: Theme.of(context).primaryColor,
                                 borderRadius:BorderRadius.circular(15),
                                 border: Border.all(
                                     width: 1,color: Theme.of(context).disabledColor.withOpacity(0.4)
                                 )
                             ),
                             child: TextField(
                               cursorColor: Colors.black,
                               onChanged: (e){

                                 setState((){
                                   // itemList = _con.rTypeProductSearch(itemList, e);

                                   _con.tempOrders  = _con.orders
                                       .where((u) =>
                                   (u.vendorName.toLowerCase().contains(e.toLowerCase())) ||
                                       (u.sale_code.toLowerCase().contains(e.toLowerCase())))
                                       .toList();
                                 });

                               },
                               style: Theme.of(context).textTheme.bodyMedium,
                               decoration: InputDecoration(
                                 contentPadding: const EdgeInsets.all(12),

                                 hintText: S.of(context).search_by_restaurant,
                                 hintStyle: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(fontSize: 14)),

                                 suffixIcon: Wrap(
                                     children:[
                                       IconButton(
                                         icon: const Icon(Icons.mic),
                                         color: Theme.of(context).hintColor,
                                         onPressed: () {

                                         },
                                       ),

                                     ]
                                 ),


                                 focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                 enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                               ),
                             ),
                           )
                       ),
                     ]
                   ),
                    _con.notFound?NoShopFoundWidget(value: 0.03,):Container(
                              padding: const EdgeInsets.only(top:10,bottom: 100),
                              child:
                                  _con.tempOrders.isEmpty
                                  ? const OrdersShimmerWidget()
                                  :ListView.separated(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                primary: false,
                                itemCount:_con.tempOrders.length,
                                itemBuilder: (context, index) {
                                  OrderList orderList = _con.tempOrders.elementAt(index);
                                  return OrderItemWidget(
                                    orderDetails: orderList,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 15);
                                },
                              ),),
                  ],
                ),


    );
  }
}


