
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../../generated/l10n.dart';

// ignore: must_be_immutable
class TermsPopup extends StatefulWidget{
  String content;
  TermsPopup({Key key, this.content}) : super(key: key);
  @override
  TermsPopupState createState() => TermsPopupState();
}

class TermsPopupState extends StateMVC<TermsPopup> {




  @override
  Widget build(BuildContext context) {
    var size =  MediaQuery.of(context).size;
    return Responsive(
      alignment: WrapAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Div(
              colS: 12,
              colM: 8,
              colL: 6,
              child: Dialog(

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)
                ),

                elevation: 0,
                backgroundColor: Colors.transparent,
                child: _buildChild(context),
                insetPadding: EdgeInsets.only(
                  top:size.height * 0.3,
                  left: size.width * 0.09,
                  right: size.width * 0.09,
                  bottom: size.width * 0.2,
                ),
              ),
            )
          ],
        )

      ],
    );
  }

  _buildChild(BuildContext context) =>
      Container(
        height: 300,
        width: double.infinity,
        padding: const EdgeInsets.only(bottom:15),
        decoration: BoxDecoration(
            color: Theme
                .of(context)
                .primaryColor,
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(12))
        ),

        child: SingleChildScrollView(
            child:Column(

          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),




                ]
            ),

            Text(S.of(context).terms_and_conditions,style:Theme.of(context).textTheme.displayMedium),
            Container(
                padding: const EdgeInsets.only(top:10,left:20,right:20),
                child:Text(widget.content,
                     style: Theme.of(context).textTheme.bodySmall,
                )
            )






          ],
        )
        ),
      );


}