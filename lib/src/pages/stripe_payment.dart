import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import '../controllers/stripe_controller.dart';
import '../repository/order_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:webview_flutter/webview_flutter.dart';



// ignore: must_be_immutable
class StripePaymentWidget extends StatefulWidget {

  const StripePaymentWidget({Key key, }) : super(key: key);
  @override
  StripePaymentWidgetState createState() => StripePaymentWidgetState();
}

class StripePaymentWidgetState extends StateMVC<StripePaymentWidget> {
  StripeController _con;
  StripePaymentWidgetState() : super(StripeController()) {
    _con = controller;
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
        backgroundColor: Colors.transparent,


        elevation: 0,
        centerTitle: true,
        title: Text(
          'Stripe',
          style: Theme.of(context).textTheme.headlineLarge.merge(const TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Stack(
        children: <Widget>[
          WebView(
              initialUrl: _con.url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController controller) {
                _con.webView = controller;
              },
              onPageStarted: (String url) {
                setState(() {
                  _con.url = url;
                });
                // ignore: deprecated_member_use
                if (url == "${GlobalConfiguration().getString('api_base_url')}Stripe/success") {
                  _con.bookOrder(currentCheckout.value);
                }
              },
              onPageFinished: (String url) {
                setState(() {
                  _con.progress = 1;
                });
              }),
          _con.progress < 1
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
