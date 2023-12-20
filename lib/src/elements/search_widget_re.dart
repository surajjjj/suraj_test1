import 'package:flutter/material.dart';
import '../models/product_details2.dart';
import '../models/restaurant_product.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/product_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import '../../generated/l10n.dart';
import '../models/vendor.dart';
import 'restaurant_product_box.dart';

// ignore: must_be_immutable
class SearchResultWidgetRe extends StatefulWidget {
  final  List<RestaurantProduct> itemDetails;
  Vendor shodDetails;

  SearchResultWidgetRe({Key key, this.itemDetails, this.shodDetails}) : super(key: key);

  @override
  SearchResultWidgetReState createState() => SearchResultWidgetReState();
}

class SearchResultWidgetReState extends StateMVC<SearchResultWidgetRe> {
  ProductController _con;
  List<ProductDetails2> itemList = <ProductDetails2>[];
  SearchResultWidgetReState() : super(ProductController()) {
    _con = controller;
  }

  stt.SpeechToText _speech;
  bool _isListening = false;
  List<ProductDetails2> productList = <ProductDetails2>[];
  List<ProductDetails2> tempList = <ProductDetails2>[];
  TextEditingController searchTextController;
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    searchTextController = TextEditingController();

    for (var element in widget.itemDetails) {
      productList.addAll(element.productdetails);
    }
    itemList = productList;
    tempList = productList;
  }

  @override
  Widget build(BuildContext context) {
    return  Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
          minimum: const EdgeInsets.only(top: 40),
          child: SafeArea(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Row(
                      children:[
                       InkWell(
                            onTap:(){
                              Navigator.pop(context);
                            },
                            child:const Icon(Icons.arrow_back)
                        ),
                        Expanded(
                            child:Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius:BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,color: Theme.of(context).disabledColor.withOpacity(0.4)
                                  )
                              ),
                              child: TextField(
                                cursorColor: Colors.black,
                                controller: searchTextController,
                                onChanged: (e){


                                  setState((){
                                    // itemList = _con.rTypeProductSearch(itemList, e);

                                    itemList  = tempList
                                        .where((u) =>
                                    (u.product_name.toLowerCase().contains(e.toLowerCase())) ||
                                        (u.id.toLowerCase().contains(e.toLowerCase())))
                                        .toList();
                                  });

                                },

                                autofocus:true,
                                style: Theme.of(context).textTheme.titleSmall,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(12),

                                  hintText: S.of(context).what_are_you_looking_for,
                                  hintStyle: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(fontSize: 14)),

                                  suffixIcon: Wrap(
                                      children:[
                                        IconButton(
                                          icon: const Icon(Icons.mic),
                                          color: Theme.of(context).hintColor,
                                          onPressed: () {
                                            _isListening = false;
                                            showClipper();
                                          },
                                        ),

                                      ]
                                  ),


                                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                  enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                                ),
                              ),
                            )
                        ),
                      ]
                  ),

               /*   Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: searchTextController,
                      onChanged: (e) {


                        setState((){
                          // itemList = _con.rTypeProductSearch(itemList, e);

                          itemList  = tempList
                              .where((u) =>
                          (u.product_name.toLowerCase().contains(e.toLowerCase())) ||
                              (u.id.toLowerCase().contains(e.toLowerCase())))
                              .toList();
                        });

                      },
                      autofocus: true,
                      style: Theme.of(context).textTheme.bodyText1,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        hintText: S.of(context).what_are_you_looking_for,
                        hintStyle: Theme.of(context).textTheme.caption.merge(const TextStyle(fontSize: 14)),
                        prefixIcon: Icon(Icons.search, color: Theme.of(context).hintColor),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.mic),
                          color: Theme.of(context).hintColor,
                          onPressed: () {
                            _isListening = false;
                            ShowClipper();
                          },
                        ),
                        border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.3))),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1))),
                      ),
                    ),
                  ),*/
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: itemList.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            ProductDetails2 suggestion = itemList.elementAt(index);
                            return RestaurantProductBox(choice: suggestion, con: _con,km: widget.shodDetails.distance, shopDetails: widget.shodDetails);
                          },
                        ),
                        const SizedBox(height: 20),

                      ],
                    ),
                  ),
                ],
              ),
            ),)),
    );


  }
  callback(){

  }



  void showClipper() {
    String text = S.of(context).press_the_button_and_start_speaking;
    Future<void> future =  showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: const Color(0xff737373),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      color: Theme.of(context).primaryColorLight,
                    ),
                    Expanded(
                      // this is my own class which extendsCustomClipper
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top:20, left: 10, right: 10),

                                child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                  const SizedBox(height: 10),
                                  Text(
                                    'Listening',
                                    style: Theme.of(context).textTheme.displayMedium.merge(const TextStyle(fontWeight: FontWeight.w400)),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:10,left: 15, right: 15,),
                                    child: AvatarGlow(
                                      animate: _isListening,
                                      glowColor: Colors.green,
                                      endRadius: 50.0,
                                      duration: const Duration(milliseconds: 2000),
                                      repeatPauseDuration: const Duration(milliseconds: 100),
                                      repeat: true,
                                      child: FloatingActionButton(
                                        onPressed: () async {
                                          if (!_isListening) {
                                            bool available = await _speech.initialize(
                                              onStatus: (val) {

                                              },

                                            );
                                            if (available) {
                                              setState(() => _isListening = true);
                                              _speech.listen(
                                                onResult: (val) => setState(() {
                                                  text = val.recognizedWords;

                                                  if (val.hasConfidenceRating && val.confidence > 0) {

                                                    setState(() => _isListening = false);
                                                    _speech.stop();

                                                    searchTextController.text = text;
                                                    Navigator.pop(context);
                                                  }

                                                }),
                                              );
                                            }
                                          } else {
                                            setState(() => _isListening = false);
                                            _speech.stop();
                                          }
                                        },
                                        child: Icon(_isListening ? Icons.mic : Icons.mic_none,color: Theme.of(context).primaryColorLight,),
                                      ),
                                    ),
                                  ),
                                ]),

                              ),
                            ),

                          ],
                        ),
                      ),

                    ),
                  ],
                )
            );
          });
        });
    future.then((void value) => {
      setState((){

        itemList  = tempList
            .where((u) =>
        (u.product_name.toLowerCase().contains(text.toLowerCase())) ||
            (u.id.toLowerCase().contains(text.toLowerCase())))
            .toList();
      }),

    });
  }
}
