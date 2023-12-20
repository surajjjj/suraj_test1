
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'stores.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../models/mastercategory_model.dart';
//ignore: must_be_immutable
class Category extends StatefulWidget {
  List<MasterCategoryModel> categoryList;

  Category({Key key, this.categoryList}) : super(key: key);



  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category>  with SingleTickerProviderStateMixin {

  AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this,);
  }
  final bool visible= false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size =MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
          children:[
            Container(
              width: double.infinity,
              height: 160,
              decoration: const BoxDecoration(
                  image:DecorationImage(
                      image:AssetImage('assets/img/cover3.jpg',
                      ),
                      fit: BoxFit.fill
                  )
              ),
              child:Container(
                padding: const EdgeInsets.only( left: 10.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      color:Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 10.0),
                    Text(S.of(context).category,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium.merge(TextStyle(color:Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
              ),
            ),
            Container(

              margin: const EdgeInsets.only(top:120),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top:10,),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),)),

                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(top:15,left:20,right:20,bottom: 20),
                              child:Wrap(
                                  runSpacing: 20,
                                  children:List.generate(widget.categoryList.length, (index) {
                                    MasterCategoryModel categoryData = widget.categoryList.elementAt(index);
                                    return Div(
                                        colS:4,
                                        colM:size.width > 769 ? 2 : 4,
                                        colL:size.width > 769 ? 2 : 4,
                                        child:Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height:size.width > 769 ? 110 :80,width:size.width > 769 ? 110 :80,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                    return Stores( pageTitle:  categoryData.title,
                                                      coverImage: categoryData.coverImage,previewImage: categoryData.previewImage,
                                                      pageType: 'category',
                                                      id: categoryData.id,
                                                      subcategoryStatus: categoryData.subCategoryView,
                                                    );
                                                  }));
                                                },
                                                child:  CircleAvatar(
                                                  backgroundImage:  NetworkImage(categoryData.previewImage),
                                                  radius: 80.0,
                                                ),


                                              ),
                                            ),
                                            const SizedBox(height:5),

                                            Text(categoryData.title,
                                                textAlign: TextAlign.center,
                                                style:Theme.of(context).textTheme.titleSmall)
                                          ],
                                        )
                                    );
                                  })
                              ),


                            ),




                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )


          ]
      ),

    );
  }
}