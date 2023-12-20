import 'package:flutter/material.dart';
import '../pages/payment_wallet.dart';
import '../helpers/helper.dart';
import '../models/recharge.dart';
import '../models/wallet_transactions.dart';
import '../models/wallet.dart';
import '../repository/wallet_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class WalletController extends ControllerMVC {
  List<Wallet> walletList = <Wallet>[];
  List<WalletTransactions> walletTransactionList = <WalletTransactions>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  Recharge rechargeData = Recharge();
  // ignore: non_constant_identifier_names
  GlobalKey<FormState> RechargeFormKey;
  OverlayEntry loader;
  WalletController() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    RechargeFormKey = GlobalKey<FormState>();
    listenForWallet();
    loader = Helper.overlayLoader(context);
  }


  Future<void> listenForWallet() async {
    final Stream<Wallet> stream = await getWallet();
    stream.listen((Wallet walletAmount) {
      setState(() => walletList.add(walletAmount));


    }, onError: (a) {

    }, onDone: () {});
  }

  Future<void> listenForWalletTransaction() async {
    final Stream<WalletTransactions> stream = await getTransaction('recent');
    stream.listen((WalletTransactions walletAmount) {
      setState(() => walletTransactionList.add(walletAmount));


    }, onError: (a) {

    }, onDone: () {});
  }


  recharge(amount){

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentWalletPage(amount: amount,)));
   /** if (amount!='') {
      
      rechargeData.user_id = currentUser.value.id;
      rechargeData.type = 'credit';
      rechargeData.amount = amount;
      Overlay.of(context).insert(loader);
      SendRecharge(rechargeData).then((value) {

        if (value == true) {
          Navigator.of(context).pushReplacementNamed('/WThankyou');
        } else {
          // ignore: deprecated_member_use
          scaffoldKey?.currentState?.showSnackBar(SnackBar(
            content: Text('Error'),
          ));
        }
      }).catchError((e) {
        loader.remove();
        // ignore: deprecated_member_use
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text('Enter your amount'),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    } */
  }



}
