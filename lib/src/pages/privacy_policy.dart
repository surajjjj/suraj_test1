import 'package:flutter/material.dart';
import '../helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../controllers/settings_controller.dart';
import '../components/Shimmer/rectangular_loader_widget.dart';
// ignore: must_be_immutable
class PrivacyPolicy extends StatefulWidget {
  String policy;
  int id;
  PrivacyPolicy({Key key, this.policy, this.id}) : super(key: key);

  @override
  PrivacyPolicyState createState() => PrivacyPolicyState();
}

class PrivacyPolicyState extends StateMVC<PrivacyPolicy> {
  SettingsController _con;

  PrivacyPolicyState() : super(SettingsController()) {
    _con = controller;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.policy == 'Terms and Conditions') {
      _con.listenForPolicy(1);
    } else if (widget.policy == 'Privacy Policy') {
      _con.listenForPolicy(2);
    } else if (widget.policy == 'Return Policy') {
      _con.listenForPolicy(3);
    } else if (widget.policy == 'About Us') {
      _con.listenForPolicy(4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _con.scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.background
          ),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          title: Text(
            widget.policy=='Terms and Conditions'?S.of(context).terms_and_conditions:
            widget.policy=='Privacy Policy'? S.of(context).privacy_policy:
            widget.policy=='Return Policy'? S.of(context).return_policy:
            widget.policy,
            textAlign: TextAlign.center,
            style:  Theme.of(context).textTheme.displayMedium,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                (_con.policyList.isEmpty)
                    ? const RectangularLoaderWidget()
                    : Padding(
                        padding: const EdgeInsets.only(top:10,left:20,right:20),
                        child: Helper.applyHtml(context, _con.policyList[0].policy)
                      )
              ],
            ),
          ),
        ));
  }
}
