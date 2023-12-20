// ignore: must_be_immutable

import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../Widget/custom_divider_view.dart';
import '../components/constants.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart';

//ignore: must_be_immutable
class TaxPopupWidget extends StatefulWidget {

  double tax;
  double packing;
  TaxPopupWidget({Key key, this.tax,this.packing}) : super(key: key);
  @override
  State<TaxPopupWidget> createState() => _TaxPopupWidgetState();
}

class _TaxPopupWidgetState extends State<TaxPopupWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
      insetPadding: EdgeInsets.only(
        top: size.height * 0.09,
        left: size.width * 0.08,
        right: size.width * 0.08,
        bottom: size.width * 0.09,
      ),
    );
  }

  _buildChild(BuildContext context) => SingleChildScrollView(
    child: Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Container(
            padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:const EdgeInsets.only(bottom:10),
                    child: Text(
                      '${setting.value.appName}Gst and Restaurant Charges',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          .merge(TextStyle(color: greyColor1)),
                    ),
                  ),
                  const CustomDividerView(
                    dividerHeight: 1.5,
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10,bottom:10),
                      child: Wrap(
                        children: [
                          Div(
                            colS: 9,
                            colM: 9,
                            colL: 9,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Restaurant packaging charges',
                                    style:Theme.of(context).textTheme.titleSmall
                                ),
                              ],
                            ),
                          ),
                          Div(
                            colS: 3,
                            colM: 3,
                            colL: 3,
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text(Helper.pricePrint(widget.packing.toString()),
                                      style:Theme.of(context).textTheme.titleSmall
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  const CustomDividerView(
                    dividerHeight: 1.5,
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10,bottom:10),
                      child: Wrap(
                        children: [
                          Div(
                            colS: 9,
                            colM: 9,
                            colL: 9,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Taxes',
                                    style:Theme.of(context).textTheme.titleSmall
                                ),
                              ],
                            ),
                          ),
                          Div(
                            colS: 3,
                            colM: 3,
                            colL: 3,
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text(Helper.pricePrint(widget.tax.toString()),
                                      style:Theme.of(context).textTheme.titleSmall
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                  const CustomDividerView(
                    dividerHeight: 1.5,
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 10,bottom:10),
                      child: Wrap(
                        children: [
                          Div(
                            colS: 9,
                            colM: 9,
                            colL: 9,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Total',
                                    style:Theme.of(context).textTheme.titleSmall
                                ),
                              ],
                            ),
                          ),
                          Div(
                            colS: 3,
                            colM: 3,
                            colL: 3,
                            child: Container(
                              margin: const EdgeInsets.only(left: 5),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text(Helper.pricePrint((widget.tax+widget.packing).toString()),
                                      style:Theme.of(context).textTheme.titleSmall
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),

                  Container(
                    margin: const EdgeInsets.only(right: 5),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: transparent,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(
                            transparent),
                        elevation:
                        MaterialStateProperty.all(0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OKAY',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              .merge(TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              height: 1.1,
                              fontWeight:
                              FontWeight.w700))),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    ),
  );
}

