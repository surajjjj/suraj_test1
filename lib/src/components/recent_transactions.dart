
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../Widget/transaction_card.dart';
import '../controllers/wallet_controller.dart';
import '../helpers/helper.dart';
import '../models/wallet_transactions.dart';

// ignore: must_be_immutable
class RecentTransactions extends StatefulWidget {
  // ignore: non_constant_identifier_names
  String PageType;
  // ignore: non_constant_identifier_names
  RecentTransactions({Key key, this.PageType}) : super(key: key);
  @override
  RecentTransactionsState createState() => RecentTransactionsState();
}

class RecentTransactionsState extends StateMVC<RecentTransactions> {

  WalletController _con;

  RecentTransactionsState() : super(WalletController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _con.listenForWalletTransaction();

  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0,top:20,bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [


               widget.PageType=='full'? Text(S.of(context).recent_transactions, style: Theme.of(context).textTheme.displayMedium):  Text('Recent Transaction', style: Theme.of(context).textTheme.displayMedium),


              ],
            ),
          ),
          Flexible(
            flex: 1,
            child:ListView.separated(
              shrinkWrap: true,
              itemCount:   _con.walletTransactionList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index){
                WalletTransactions walletData =  _con.walletTransactionList.elementAt(index);
                return
                  TransactionCard(
                    transactionId: walletData.transactions_id,
                    date: walletData.date,
                    color: walletData.type== 'Cr' ?Colors.green:Colors.red,
                    letter: walletData.type=='Cr'?'CR':'DR',
                    title: walletData.type=='Cr'?S.of(context).credit:S.of(context).debited,
                    subTitle: walletData.type=='Cr'?S.of(context).your_amount_is_credited:S.of(context).your_amount_is_debited,
                    price: Helper.pricePrint(walletData.amount),
                  );
    },
    separatorBuilder: (context, index) {
    return   Divider(
      color: Colors.grey.withOpacity(0.5),
      thickness: 0.5,
      endIndent: 16.0,
      indent: 16.0,
    );
    },

            ),
          )
        ],
      ),
    );
  }
}
