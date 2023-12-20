
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../elements/search_results_widget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart';
import 'profile_page.dart';
import '../helpers/helper.dart';
import '../pages/home.dart';
import 'orders.dart';
import 'shop_all_list.dart';

// ignore: must_be_immutable
class PagesWidget extends StatefulWidget  {
  dynamic currentTab;

  Widget currentPage = const HomeWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  PagesWidget({Key key,
    this.currentTab,
  }) : super(key: key);
  @override
  PagesWidgetState createState() {
    return PagesWidgetState();
  }
}

class PagesWidgetState extends StateMVC<PagesWidget>{
  @override
  initState() {
    super.initState();
    _selectTab(widget.currentTab);

  }



  @override
  void didUpdateWidget(PagesWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage =  ShopAllList(pageTitle: S.of(context).favourite_store, type: 'favorite_store',coverImage: 'assets/img/cover1.jpg',);
          break;
        case 1:
          widget.currentPage = SearchResultWidget(parentScaffoldKey: widget.scaffoldKey,pageType: 'bottom');
          break;
        case 2:
          widget.currentPage = HomeWidget(parentScaffoldKey: widget.scaffoldKey,selectTab: _selectTab);
          break;
        case 3:
          widget.currentPage = OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 4:
          widget.currentPage = const ProfilePage();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,

      child: Scaffold(
        key: widget.scaffoldKey,


        body: Stack(
          children:[
            widget.currentPage,
            Align(
                alignment: Alignment.bottomCenter,
              child:Theme(
                data: Theme.of(context)
                    .copyWith(canvasColor: Colors.transparent),
                child:  Container(
                  margin: const EdgeInsets.all(10),
                  height: size.width * .155,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],

                    borderRadius: BorderRadius.circular(50),
                  ),
                  child:  CustomNavigationBar(
                    iconSize: 20.0,
                    selectedColor: widget.currentTab!=2?Theme.of(context).primaryColorDark:Colors.transparent,
                    strokeColor: const Color(0x30040307),
                    unSelectedColor: const Color(0xffacacac),
                    borderRadius: const Radius.circular(50),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
                    currentIndex: widget.currentTab,
                    elevation: 0,
                    items: [
                      CustomNavigationBarItem(
                          icon: Icon(EvaIcons.heart,color:widget.currentTab==0? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.background.withOpacity(0.6)),
                          // ignore: deprecated_member_use
                          title: Text(S.of(context).favourite,
                              style: TextStyle(color:widget.currentTab==0? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.background.withOpacity(0.6))
                          )
                      ),
                      CustomNavigationBarItem(
                          icon: Icon(EvaIcons.search,color:widget.currentTab==1? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.background.withOpacity(0.6)),
                          title: Text( S.of(context).search,
                              style: TextStyle(color:widget.currentTab==1? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.background.withOpacity(0.6))
                          )
                      ),
                      CustomNavigationBarItem(
                        icon: const Image(image:AssetImage('assets/img/logo.png'),
                          width:40,height:40,
                        ),
                        title: Text(S.of(context).home,
                            style: TextStyle(color:widget.currentTab==2? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.background.withOpacity(0.6))
                        ),
                      ),
                      CustomNavigationBarItem(

                          icon:  Icon(EvaIcons.shoppingBagOutline,color:widget.currentTab==3? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.background.withOpacity(0.6)),
                          title: Text( S.of(context).my_orders,
                              style: TextStyle(color:widget.currentTab==3? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.background.withOpacity(0.6))
                          )
                      ),
                      CustomNavigationBarItem(
                          icon: Icon(EvaIcons.personOutline,color:widget.currentTab==4? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.background.withOpacity(0.6)),
                          title: Text(S.of(context).profile,
                              style: TextStyle(color:widget.currentTab==4? Theme.of(context).primaryColorDark : Theme.of(context).colorScheme.background.withOpacity(0.6))
                          )
                      ),
                    ],

                    onTap: (int i) {
                    if (currentUser.value.apiToken != null || i==1 || i ==2) {
                      _selectTab(i);
                     }else {
                      Navigator.of(context).pushNamed('/Login');
                    }
                    },
                  ),
                ),
              )
            )
          ]
        )



      ),
    );
  }

}







