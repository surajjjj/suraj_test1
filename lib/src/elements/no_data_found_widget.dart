import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Container(
        height: MediaQuery.of(context).size.height / 5,
      ),
      const Image(
        image: AssetImage(
          'assets/img/no_data_found.png',
        ),
        height: 200,
        width: 500,
      ),
      Padding(
          padding: const EdgeInsets.only(right: 0),
          child: Text(S.of(context).no_data_found, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge)),
    ]));
  }
}
