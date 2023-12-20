import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';

class WalletGridWidget extends StatefulWidget {
  const WalletGridWidget({Key key}) : super(key: key);

  @override
  State<WalletGridWidget> createState() => _WalletGridWidgetState();
}

class _WalletGridWidgetState extends State<WalletGridWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 16,right:16,top:15),
        padding: const EdgeInsets.only(top:20,bottom: 20,left:8,right:8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(
              color: Theme.of(context).disabledColor.withOpacity(0.13),
              spreadRadius: 1,
              blurRadius: 6)],
          color: Theme.of(context).primaryColor,
        ),
        child:Wrap(
          children: [
            Div(
                colS:3,
                colM:3,
                colL:3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Container(
                        height: 44.0,
                        width: 44.0,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: const Center(
                            child:Icon(Icons.present_to_all_rounded,
                            color: Colors.green,
                            )
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top:8),
                          child:Text('Send',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(fontWeight: FontWeight.w700)),
                          )
                      ),

                    ]
                )
            ),
            Div(
                colS:3,
                colM:3,
                colL:3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Container(
                        height: 44.0,
                        width: 44.0,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: const Center(
                            child:Icon(Icons.monetization_on_outlined,
                              color: Colors.orange,
                            )
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top:8),
                          child:Text('Transfer',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(fontWeight: FontWeight.w700)),
                          )
                      ),

                    ]
                )
            ),
            Div(
                colS:3,
                colM:3,
                colL:3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Container(
                        height: 44.0,
                        width: 44.0,
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: const Center(
                            child:Icon(Icons.account_box_outlined,
                              color: Colors.pink,
                            )
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top:8),
                          child:Text('Passbook',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(fontWeight: FontWeight.w700)),
                          )
                      ),

                    ]
                )
            ),
            Div(
                colS:3,
                colM:3,
                colL:3,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Container(
                        height: 44.0,
                        width: 44.0,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(22.0),
                        ),
                        child: const Center(
                            child:Icon(Icons.more_vert_rounded,
                              color: Colors.blue,
                            )
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top:8),
                          child:Text('More',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleSmall.merge(const TextStyle(fontWeight: FontWeight.w700)),
                          )
                      ),

                    ]
                )
            )
          ],
        )
    );
  }
}
