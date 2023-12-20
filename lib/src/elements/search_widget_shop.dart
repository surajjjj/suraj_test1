import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controllers/product_controller.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import '../../generated/l10n.dart';
import 'custom_clipper.dart';

class SearchResultShopWidget extends StatefulWidget {
  final String heroTag;
  final String pageType;
  const SearchResultShopWidget({Key key, this.heroTag, this.pageType}) : super(key: key);

  @override
  SearchResultShopState createState() => SearchResultShopState();
}

class SearchResultShopState extends StateMVC<SearchResultShopWidget> with SingleTickerProviderStateMixin {

  ProductController _con;

  SearchResultShopState() : super(ProductController()) {
    _con = controller;
  }

  stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child:SafeArea(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
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
                          child:Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextField(
                              onSubmitted: (text) {
                                _con.saveSearch(text);
                              },

                              autofocus: true,
                              style: Theme.of(context).textTheme.titleSmall,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(12),
                                hintText: S.of(context).what_are_you_looking_for,
                                hintStyle: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(fontSize: 14)),
                                prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
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
                          )
                      ),
                    ]
                ),


                /** widget.pageType !='insideshop' ?Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.green,
                    isScrollable: true,
                    indicatorColor: Colors.transparent,
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                    ),
                    labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    ),
                    tabs: <Widget>[
                    Text(S.of(context).item),
                    Text(S.of(context).shop),

                    ],
                    ),
                    ):Container(),
                    widget.pageType !='insideshop' ? Expanded(
                    child: TabBarView(
                    controller: _tabController,

                    children: <Widget>[

                    Container(
                    child: SearchItem(),
                    ),
                    Container(
                    child: SpotlightWidget(),
                    ),


                    ],
                    ),
                    ):Container() */


                /*Expanded(
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    itemCount: _con.auto_suggestion.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      AutoSuggestion _suggestion = _con.auto_suggestion.elementAt(index);
                      return Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                print(1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).dividerColor,
                                ))),
                                child: ListTile(
                                  leading: const Icon(Icons.search),
                                  title: Text(
                                    _suggestion.text,
                                    style: Theme.of(context).textTheme.subtitle2.merge(TextStyle(fontWeight: FontWeight.w600)),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.call_made,
                                      textDirection: TextDirection.rtl,
                                    ),
                                    color: Theme.of(context).hintColor,
                                    onPressed: () {
                                      _con.saveSearch(_suggestion.text);
                                    },
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),

                ],
              ),
            ),*/
              ],
            ),
          ),
        ));
  }

  // ignore: non_constant_identifier_names
  void ShowClipper() {
    String text = S.of(context).press_the_button_and_start_speaking;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.35,
              color: const Color(0xff737373),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                    color: Theme.of(context).primaryColorLight,
                  ),
                  Expanded(
                    child: ClipPath(
                      clipper: CustomShape(), // this is my own class which extendsCustomClipper
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                                    const SizedBox(height: 10),
                                    Text(
                                      text,
                                      style: Theme.of(context).textTheme.displayMedium.merge(const TextStyle(fontWeight: FontWeight.w400)),
                                      textAlign: TextAlign.center,
                                    )
                                  ]),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 5),
                                child: AvatarGlow(
                                  animate: _isListening,
                                  glowColor: Colors.green,
                                  endRadius: 75.0,
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
                                                _con.saveSearch(text);
                                              }
                                            }),
                                          );
                                        }
                                      } else {
                                        setState(() => _isListening = false);
                                        _speech.stop();
                                      }
                                    },
                                    child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }
}
