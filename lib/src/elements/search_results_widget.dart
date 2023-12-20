import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../pages/search_item.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import '../../generated/l10n.dart';
import '../Widget/custom_divider_view.dart';
import '../repository/home_repository.dart';
import '../components/Shimmer/category_shimmer_widget.dart';
import 'my_recommended_type_widge.dart';
import '../components/Shimmer/rectangular_loader_widget.dart';
import 'no_shop_found_widget.dart';
import 'search_shop_list_widget.dart';

//ignore: must_be_immutable
class SearchResultWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final String pageType;
        String searchTxt;
  SearchResultWidget({Key key,  this.pageType,this.searchTxt, this.parentScaffoldKey}) : super(key: key);

  @override
  SearchResultWidgetState createState() => SearchResultWidgetState();
}

class SearchResultWidgetState extends StateMVC<SearchResultWidget> with SingleTickerProviderStateMixin {

  HomeController _con;
  SearchResultWidgetState() : super(HomeController()) {
    _con = controller;
  }
  TextEditingController searchTextController;
  stt.SpeechToText _speech;
  bool _isListening = false;
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController();
    _speech = stt.SpeechToText();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    if(widget.searchTxt!=null) {

      searchTextController.text = widget.searchTxt;
      _con.listenForVendorItemSearch(widget.searchTxt);
    }else {
      _con.listenForMasterCategory('search');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: DefaultTabController(
        length: 2,
        child:SafeArea(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      children:[
                        widget.pageType!='bottom'?InkWell(
                            onTap:(){
                              Navigator.pop(context);
                            },
                            child:const Icon(Icons.arrow_back)
                        ):Container(),
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
                                onSubmitted: (e){

                                  _con.listenForVendorItemSearch( e);

                                },

                                autofocus: widget.searchTxt!=''?false:true,
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

                  _con.searchState=='finding'?
                  Expanded(
                    child:SingleChildScrollView(
                      child: Column(
                        children:const [
                          RectangularLoaderWidget()
                        ]
                      ),
                    )
                  )
                      :_con.searchState=='find'?

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.green,
                      isScrollable: true,
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: Colors.grey,
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: <Widget>[
                        Text(S.of(context).item),
                        Text(S.of(context).shop),

                      ],
                    ),
                  ):Container(),
                  _con.searchState=='find'?Expanded(
                    child:Container(
                      margin: const EdgeInsets.only(top:5),
                      child: TabBarView(
                        controller: _tabController,

                        children: <Widget>[

                          _con.itemNotFound?NoShopFoundWidget(value: 0.03,):SearchItem(itemDetails: _con.searchResultData.item,),
                          _con.shopNotFound?NoShopFoundWidget(value: 0.03,):SearchShopListWidget(vendor: _con.searchResultData.vendor,),


                        ],
                      ),
                    )
                  ):Container(),

                 /* recent search start */
                  _con.searchState=='no_data'?Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     recentSearch.value.isNotEmpty? Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children:[
                           Container(
                               padding: const EdgeInsets.only(left:20,right:20),
                               child:Text(S.of(context).recent_searches,
                                 style: Theme.of(context).textTheme.displayMedium,
                               )
                           ),
                         ]
                     ):Container(),
                     recentSearch.value.isNotEmpty?Container(
                         padding: const EdgeInsets.only(top:20,right:20,left:10,bottom:20),
                         child:Wrap(
                             children: List.generate(recentSearch.value.length, (index) {
                               return Container(
                                   padding: const EdgeInsets.only(bottom:12,left:10,),
                                   child:InkWell(
                                       splashColor: Theme.of(context).primaryColor,
                                       focusColor: Theme.of(context).primaryColor,
                                       onTap: (){
                                         _con.listenForVendorItemSearch(recentSearch.value[index].text);
                                       },
                                       child: Container(
                                         padding:const EdgeInsets.all(7),

                                         decoration: BoxDecoration(
                                             borderRadius:BorderRadius.circular(30),
                                             border: Border.all(
                                                 width: 1,color: Theme.of(context).disabledColor.withOpacity(0.4)
                                             )
                                         ),
                                         child: Wrap(
                                           children: [
                                             Icon(
                                                 Icons.cached_outlined,size:18,
                                                 color: Theme.of(context).disabledColor
                                             ),

                                             Container(
                                                 padding: const EdgeInsets.only(top:0,left:5,right:5),
                                                 child:Text(recentSearch.value[index].text,
                                                   style: Theme.of(context).textTheme.bodySmall,
                                                   textAlign: TextAlign.center,
                                                 )
                                             ),
                                           ],
                                         ),
                                       )
                                   ));
                             })
                         )):Container(),
                     const CustomDividerView(),
                     const SizedBox(height:20),
                     Container(
                         padding: const EdgeInsets.only(left:20,right:20),
                         child:Text(S.of(context).popular_cuisines,
                           style: Theme.of(context).textTheme.displayMedium,
                         )
                     ),
                     const SizedBox(height:5),
                     _con.categoryList.isEmpty?const CategoryShimmerWidget() : MyRecommendedTypeWidget(categoryList: _con.categoryList),
                   ],
                 ):Container()


                  /* recent search end */
                ],
              ),
            ),
          )));
  }



  void showClipper() {
    String text = S.of(context).press_the_button_and_start_speaking;
    showModalBottomSheet(
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

                                                    _speech.stop();
                                                    _con.listenForVendorItemSearch( text);
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
  }
}