import 'package:flutter/material.dart';

import '../components/appbar.dart';
import '../components/cards.dart';
import '../components/recent_transactions.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key key}) : super(key: key);

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: Column(
          children: [
            const Appbar(),
            const CardsList(),
           // const WalletGridWidget(),

            RecentTransactions(),
          ],
        ),
      )
    );
  }
}
