//import 'package:banking_app/utilities/themeColors.dart';
//import 'package:banking_app/utilities/themeStyles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../generated/l10n.dart';
import '../Widget/card_in_page.dart';
import '../Widget/other_details_divider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key key}) : super(key: key);


  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).transaction_details, style:Theme.of(context).textTheme.displayMedium),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 32.0, bottom: 8.0),
                child: Row(
                  children: [
                    Text(S.of(context).transaction,style: Theme.of(context).textTheme.displayMedium
                        ),
                  ],
                ),
              ),
              const CardInPage(),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 32.0, bottom: 8.0),
                child: Row(
                  children: [
                    Text(S.of(context).details,style: Theme.of(context).textTheme.displayMedium ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SvgPicture.asset('assets/icons/bankTransfer-icon.svg'),
                    ),
                    Text(S.of(context).bank_transfer,
                        style: Theme.of(context).textTheme.titleSmall
                        ),
                  ],
                ),
              ),
              const OtherDetailsDivider(),

              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).status, style: TextStyle(color:Theme.of(context).disabledColor,fontWeight: FontWeight.w500)),
                    const SizedBox(height: 5.0),
                    Text(S.of(context).your_amount_is_debited,
                        style: Theme.of(context).textTheme.titleSmall
                        )
                  ],
                ),
              ),
              const OtherDetailsDivider(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).transaction_id,
                        style: TextStyle(color:Theme.of(context).disabledColor,fontWeight: FontWeight.w500)
                    ),
                    const SizedBox(height: 5.0),
                    Text('14',
                        style: Theme.of(context).textTheme.titleSmall
                        ),
                  ],
                ),
              ),
              const OtherDetailsDivider(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).date,
                        style: TextStyle(color:Theme.of(context).disabledColor,fontWeight: FontWeight.w500)
                    ),
                    const SizedBox(height: 5.0),
                    Text('12.01.21',
                        style: Theme.of(context).textTheme.titleSmall
                    ),
                  ],
                ),
              ),
              const OtherDetailsDivider(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).status,
                        style: TextStyle(color:Theme.of(context).disabledColor,fontWeight: FontWeight.w500)
                        ),
                    const SizedBox(height: 5.0),
                    Text(S.of(context).success,
                        style: Theme.of(context).textTheme.titleSmall
                    ),
                  ],
                ),
              ),
              const OtherDetailsDivider(),



            ],
          ),

        ],
      ),
    );
  }
}


class ThemeColors {
  static Color lightGrey = const Color(0xffE8E8E9);
  static Color black = const Color(0xff14121E);
  static Color grey = const Color(0xFF8492A2);
}