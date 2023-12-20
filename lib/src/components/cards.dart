// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../controllers/wallet_controller.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../Widget/credit_card.dart';
import '../../generated/l10n.dart';

import 'Shimmer/home_slider_loader_widget.dart';
import '../models/wallet.dart';
class CardsList extends StatefulWidget {
  const CardsList({Key key}) : super(key: key);

  @override
  _CardsListState createState() => _CardsListState();
}

class _CardsListState extends StateMVC<CardsList> {
  WalletController _con;
  _CardsListState() : super(WalletController()) {
    _con = controller;

  }




  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top:10,left: 15.0, right: 15.0, bottom: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(S.of(context).your_cards, style: Theme.of(context).textTheme.displayMedium),

            ],
          ),
        ),
      _con.walletList == null || _con.walletList.isEmpty
            ? const HomeSliderLoaderWidget()
            :SizedBox(
        height:190,
          child: PageView.builder(
            itemCount: _con.walletList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              Wallet walletData = _con.walletList.elementAt(index);
              return  CreditCard(card: walletData);
            },
          ),
        ),


      ],
    );
  }
}


