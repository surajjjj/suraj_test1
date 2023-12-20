import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../models/main_category.dart';
import 'search_results_widget.dart';


class SearchBarWidget extends StatefulWidget {
  final ValueChanged onClickFilter;
  final Color iconColor;
  final Color labelColor;
  final MainCategoryModel shopTypeList;
  final GlobalKey<ScaffoldState> parentScaffoldKey;
  const SearchBarWidget({Key key, this.iconColor, this.shopTypeList,
    this.labelColor, this.onClickFilter,this.parentScaffoldKey}) : super(key: key);
  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
          return SearchResultWidget(parentScaffoldKey: widget.parentScaffoldKey,);
        }));
      },
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
            color: const Color(0xFFaeaeae).withOpacity(0.1),

            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12, left: 0),
              child: Icon(Icons.search, color:Theme.of(context).hintColor,),
            ),
            Expanded(
              child: Text(
                S.of(context).what_are_you_looking_for,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: Theme.of(context).textTheme.bodySmall.merge(const TextStyle(fontSize: 12)),
              ),
            ),
            InkWell(
                onTap:(){
                  widget.onClickFilter('e');
                },
                child:Icon(Icons.filter_list,size:22,
                  color: Theme.of(context).hintColor,
                )
            ),


          ],
        ),
      ),
    );
  }
}
