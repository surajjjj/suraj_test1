
import 'package:flutter/material.dart';
import '../components/recent_transactions.dart';

class WalletTransactionHistory extends StatefulWidget {
  const WalletTransactionHistory({Key key}) : super(key: key);

  @override
  State<WalletTransactionHistory> createState() => _WalletTransactionHistoryState();
}

class _WalletTransactionHistoryState extends State<WalletTransactionHistory> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            RecentTransactions(PageType: 'full'),
          ],
        ),
      )
    );
  }
}
