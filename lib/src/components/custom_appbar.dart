
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../elements/search_results_widget.dart';
import '../../generated/l10n.dart';
import '../elements/shopping_cart_button_widget.dart';
import '../helpers/helper.dart';
import '../repository/settings_repository.dart';
import '../repository/user_repository.dart';


//ignore: must_be_immutable
class CustomAppBar extends StatelessWidget {
  Size size;
  Function loadUser;
  CustomAppBar({Key key,this.loadUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(

    body:PreferredSize(
      preferredSize: const Size.fromHeight(200),
      child: Container(
        alignment: Alignment.topLeft,
         decoration:  BoxDecoration(
            image: DecorationImage(
            image: setting.value.customHeader?NetworkImage(setting.value.headerBgImage):const ExactAssetImage('assets/img/top_desing_2.png'),
            fit: BoxFit.cover,
          ),
          
        ),
        
        child: SafeArea(
          child:Padding(
            padding: const EdgeInsets.only(top:10,left:10,right:10),
child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            
            children: <Widget>[
              const SizedBox(height:20),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text(
                          setting.value.appName,
                          overflow: TextOverflow.ellipsis,maxLines: 1,
                          style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(height: 1.2,color:setting.value.customHeader?Helper.getColorFromHex(setting.value.headerColor):Theme.of(context).colorScheme.primary))
                      ),
                     InkWell(
                        onTap: (){
                           Navigator.of(context).pushNamed('/set_location',arguments: loadUser);
                        },
                        child: Text(
                            currentUser.value.latitude== null || currentUser.value.longitude == null ?S.of(context).select_your_address: currentUser.value.selected_address,
                            overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.titleLarge.merge(TextStyle(color:setting.value.customHeader?Helper.getColorFromHex(setting.value.headerColor):Theme.of(context).colorScheme.primary))
                        ),
                      )
                    ]
                  )
                )
              ),
              Wrap(
                children:[
                  Container(
                    margin: const EdgeInsets.only(right:15),
                    child:GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchResultWidget()));
                      },
                      child: Icon(
                        EvaIcons.search,
                        color: setting.value.customHeader?Helper.getColorFromHex(setting.value.headerColor):Theme.of(context).colorScheme.primary.withOpacity(0.9),
                      ),
                    ),
                  ),
                 ShoppingCartButtonWidget(iconColor: setting.value.customHeader?Helper.getColorFromHex(setting.value.headerColor):Theme.of(context).colorScheme.background.withOpacity(0.5), labelColor: Theme.of(context).splashColor),


                ]
              )
            ],
          ),
            ),
          
        ),
      ),
    ),
    );
  }

}
