// ignore: must_be_immutable
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import '../models/variant_group.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:responsive_ui/responsive_ui.dart';
import '../Widget/custom_divider_view.dart';
import '../components/constants.dart';
import '../controllers/product_controller.dart';
import '../helpers/helper.dart';
import '../models/addon.dart';
import '../models/addongroup_model.dart';
import '../models/combination_variant.dart';
import '../models/product_details2.dart';
import '../models/variant.dart';
import '../models/vendor.dart';
import 'package:badges/badges.dart' as badges;

// ignore: must_be_immutable
class VariantAddonsSheet extends StatefulWidget {
  ProductDetails2 product ;
  ProductController con;
  Vendor shopDetails;



  VariantAddonsSheet({Key key, this.product,this.shopDetails, this.con}) : super(key: key);
  @override
  VariantAddonsSheetState createState() => VariantAddonsSheetState();
}

class VariantAddonsSheetState extends StateMVC<VariantAddonsSheet> {

   ProductController _con;
  VariantAddonsSheetState() : super(ProductController()) {
    _con = controller;

  }


  // Declare this variable
  String selectedRadio ;
  String addon;
  bool firstLoad;
  String relation;

  String selectedVariant;
  @override
  void initState() {
    super.initState();
    firstLoad = false;

    _con.finder(widget.product);
    relation = widget.product.defaultVariant;


  }
  int intState = 7;
  bool openState =false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        color: const Color(0xff737373),
        child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(15),topLeft:  Radius.circular(15)),
            ),
            child:Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  decoration: const BoxDecoration(

                    shape: BoxShape.rectangle,

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left:20,top:20),
                          alignment: Alignment.topLeft,
                          child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Container(
                                    padding:const EdgeInsets.only(bottom:7),
                                    child:Text(widget.product.product_name,
                                      style: Theme.of(context).textTheme.titleSmall,
                                    )
                                ),
                                Text(S.of(context).customize_as_per_your_taste,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),

                              ]
                          )
                      ),
                      Container(
                        height: 28,width: 28,

                        margin: const EdgeInsets.only(right: 20,top: 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).disabledColor.withOpacity(0.5),
                              blurRadius: 1.5,
                              spreadRadius:0.1,
                            ),
                          ],
                        ),
                        child: InkWell(
                          child: const Icon(Icons.close,size: 18,),
                          onTap: (){
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),

                const CustomDividerView(
                  dividerHeight: 2,
                ),

                Expanded(
                    child:SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(children: [

                            const SizedBox(height: 10),
                            Padding(
                                padding: const EdgeInsets.only(left: 0, right: 0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  _con.productData.variantGroup.isNotEmpty?Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:List.generate(      _con.productData.variantGroup.length, (index) {
                                        variantGroupModel variantGroupData =      _con.productData.variantGroup.elementAt(index);





                                        return Column(
                                          children: [
                                            Container(
                                              padding:const EdgeInsets.only(left:12,right:12),
                                              child:Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children:[
                                                    Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children:[
                                                          Text(
                                                            variantGroupData.groupName,
                                                            style: Theme.of(context).textTheme.titleLarge,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                          Text('${S.current.select} 1 out of  ${variantGroupData.variant.length} options',
                                                            style: Theme.of(context).textTheme.bodySmall,
                                                          ),
                                                        ]
                                                    ),
                                                    badges.Badge(
                                                      toAnimate: false,
                                                      shape: BadgeShape.square,
                                                      elevation: 0,
                                                      borderSide: BorderSide(width: 1,color:Theme.of(context).dividerColor),
                                                      badgeColor: Colors.grey[100],
                                                      borderRadius: BorderRadius.circular(8),
                                                      badgeContent: Text(S.of(context).required, style: TextStyle(color: Theme.of(context).primaryColorDark)),
                                                    ),

                                                  ]
                                              ),),
                                            variantGroupData.boxType=='tabbox' &&  variantGroupData.relation!='child'?SizedBox(
                                              height:80,
                                              child: ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: variantGroupData.variant.length,
                                                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                                  padding: const EdgeInsets.only(right:10),
                                                  itemBuilder: (context, index) {
                                                    variantModel variant = variantGroupData.variant.elementAt(index);

                                                    return Container(
                                                        margin:const EdgeInsets.only(left:5),
                                                        child:Container(
                                                            margin:const EdgeInsets.only(left:3),
                                                            padding: const EdgeInsets.only(top:10,bottom:5,left:4,),
                                                            child:Container(
                                                              width:size.width * 0.43,
                                                              decoration: BoxDecoration(
                                                                color: variant.selected ? Colors.red[50]:Theme.of(context).primaryColor,
                                                                borderRadius: BorderRadius.circular(10),
                                                              ),
                                                              child: MaterialButton(
                                                                shape: RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: Colors.grey[300],
                                                                        width: 1,
                                                                        style: BorderStyle.solid
                                                                    ),
                                                                    borderRadius: BorderRadius.circular(10)
                                                                ),
                                                                height: 70,
                                                                elevation: 0,
                                                                color:variant.selected ? Colors.red[50]:Theme.of(context).primaryColor,
                                                                child: Center(
                                                                    child:  Row(
                                                                        children:[
                                                                          Expanded(
                                                                            child: Container(
                                                                                padding: const EdgeInsets.only(right:5,left:5),
                                                                                child:Text(variant.variantName,
                                                                                    textAlign: TextAlign.center,
                                                                                    style:TextStyle(fontWeight: 1==2?FontWeight.bold:FontWeight.w500,color:1==2?Colors.white:Theme.of(context).colorScheme.background)
                                                                                )
                                                                            ),
                                                                          ),

                                                                          variant.selected? Container(
                                                                              margin:const EdgeInsets.only(left: 15),
                                                                              child:const Icon(Icons.check_circle,color:Colors.red,size:18)):Container()
                                                                        ]
                                                                    )
                                                                ),
                                                                onPressed: () {

                                                                  for (var l in variantGroupData.variant) {
                                                                    setState(() {
                                                                      l.selected = false;
                                                                    });
                                                                  }
                                                                  variant.selected = true;
                                                                  relation = variant.variantName;
                                                                  _con.variantGlobalName = relation;
                                                                  _con.combinationFinder(widget.product,relation,'userSelect');
                                                                },

                                                              ),)

                                                        )
                                                    );
                                                  }
                                              ),
                                            ):Container()
                                          ],
                                        );

                                      })):Container(),
                                 _con.productData.combinationVariant.isNotEmpty? SizedBox(
                                    height:150,
                                    child:ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:     _con.productData.combinationVariant.length,
                                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                        padding: const EdgeInsets.only(right:10),
                                        itemBuilder: (context, index) {

                                          CombinationVariantModel combination =    _con.productData.combinationVariant.elementAt(index);

                                          return Container(
                                              margin:const EdgeInsets.only(left:5),
                                              child:Container(
                                                  margin:const EdgeInsets.only(left:3),
                                                  padding: const EdgeInsets.only(top:10,bottom:5,left:4,),
                                                  child:InkWell(
                                                    onTap: (){
                                                      for (var l in _con.productData.combinationVariant) {
                                                        setState(() {
                                                          l.selected = false;
                                                        });
                                                      }
                                                      combination.selected = true;
                                                      selectedVariant = combination.variantName;
                                                      _con.keyMatcher = '-${_con.variantGlobalName}-${combination.variantName}';

                                                      _con.variantCalculation(_con.productData,'first');
                                                    },
                                                    child:Container(
                                                        width: size.width * 0.4,
                                                        decoration: BoxDecoration(
                                                          color: combination.selected ? Colors.red[50]:Theme.of(context).primaryColor,
                                                          border: Border.all(
                                                              color: Colors.grey[300],
                                                              width: 1,
                                                              style: BorderStyle.solid
                                                          ),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),

                                                        child:   Container(
                                                            padding: const EdgeInsets.only(top:10,left:10,right:10),
                                                            child:Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children:[
                                                                  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children:[
                                                                        SizedBox(
                                                                            height:50,width:50,
                                                                            child:Image.asset('assets/img/intro1.png')
                                                                        ),
                                                                        combination.selected? const Icon(Icons.check_circle,color:Colors.red,size:18):Container()

                                                                      ]
                                                                  ),

                                                                  Container(
                                                                      padding: const EdgeInsets.only(top:10),
                                                                      child:Text( combination.variantName,
                                                                        style: Theme.of(context).textTheme.titleMedium,
                                                                      )
                                                                  ),
                                                                  Container(
                                                                      padding: const EdgeInsets.only(top:5),
                                                                      child:Text(Helper.pricePrint(combination.salesPrice),
                                                                        style: Theme.of(context).textTheme.bodySmall,
                                                                      )
                                                                  ),

                                                                ]
                                                            ))


                                                    ),)


                                              )
                                          );
                                        }
                                    ),
                                  ):Container(),


                                  _con.productData.addonGroup.isNotEmpty?Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children:List.generate( _con.productData.addonGroup.length, (index) {
                                        AddonGroupModel addonGroup = _con.productData.addonGroup.elementAt(index);
                                        return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              Padding(
                                                padding: const EdgeInsets.only(left: 12,top:10,right:12,bottom:10),
                                                child: Text(
                                                  '* ${addonGroup.name}',
                                                  style: Theme.of(context).textTheme.titleLarge,
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),


                                              Container(
                                                margin:const EdgeInsets.only(left:12,right:12),
                                                padding: const EdgeInsets.only(left:10,bottom: 5),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12.withOpacity(0.2),
                                                      blurRadius: 1,
                                                      spreadRadius: 0.3,
                                                    ),
                                                  ],
                                                ),
                                                child:ListView.separated(
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: addonGroup.addon.length,
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, int index) {

                                                    AddonModel addonData = addonGroup.addon.elementAt(index);

                                                    return    Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                                                      Container(
                                                          margin:const EdgeInsets.only(top:5,right:5),
                                                          decoration:BoxDecoration(
                                                            color: Theme.of(context).primaryColor,
                                                            borderRadius:BorderRadius.circular(3),
                                                            border:Border.all(
                                                                width: 1,
                                                                color: addonData.foodType=='Veg'?Colors.green:Colors.brown
                                                            ),

                                                          ),
                                                          child:Icon(Icons.circle,size:11,color:addonData.foodType=='Veg'?Colors.green:Colors.brown)
                                                      ),
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                if( addonData.selected==true){
                                                                  addonData.selected = false;
                                                                }else{
                                                                  addonData.selected = true;

                                                                }
                                                              });
                                                              _con.variantCalculation( _con.productData,'first');
                                                            },
                                                            child:Container(
                                                                padding:const EdgeInsets.only(left:7,top:4.5),
                                                                child:Text(addonData.name, style: Theme.of(context).textTheme.titleSmall)
                                                            )
                                                        ),
                                                      ),


                                                      Wrap(
                                                        children: [
                                                          Container(
                                                              padding:const EdgeInsets.only(top:14.5),
                                                              child: Text(

                                                                '${Helper.pricePrint(addonData.price)}',
                                                                style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: priceColor1)),

                                                              )
                                                          ),
                                                          Checkbox(
                                                              value: addonData.selected,
                                                              activeColor: Colors.blue,
                                                              onChanged: (val) {


                                                                setState(() {
                                                                  if(val==false) {
                                                                    addonData.selected = false;
                                                                  }else {
                                                                    addonData.selected = true;
                                                                  }
                                                                });

                                                                _con.variantCalculation(_con.productData,'first');
                                                              }),
                                                        ],
                                                      ),

                                                    ]);

                                                  }, separatorBuilder: (BuildContext context, int index) {
                                                  return const SizedBox(height: 5);
                                                },),),
                                            ]
                                        );
                                      })
                                  ):Container(),


                                ])),

                          ]),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child:Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                      child: Wrap(
                          children:[
                            Div(
                              colS:4,
                              colM:4,
                              colL:4,
                              child: InkWell(
                                onTap: () {},
                                child:Container(
                                  width: 110,
                                  height: 49,
                                  margin: const EdgeInsets.only(right:10,top:1),
                                  decoration: BoxDecoration(
                                    color:Theme.of(context).primaryColor,
                                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12.withOpacity(0.2),
                                        blurRadius: 1,
                                        spreadRadius: 0.3,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10,top:10, right: 10,
                                    ),
                                    child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
                                      InkWell(
                                        onTap: () {

                                            _con.variantCalculation( _con.productData,'sub');


                                        },

                                        child: Icon(Icons.remove_circle,color:Theme.of(context).colorScheme.secondary,size:27),

                                      ),
                                      SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.022,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text( _con.productData.qty.toString(), style: Theme
                                            .of(context)
                                            .textTheme
                                            .titleSmall),
                                      ),
                                      SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width * 0.022,
                                      ),
                                      InkWell(
                                        onTap: () {

                                            _con.variantCalculation( _con.productData,'add');

                                        },

                                        child: Icon(Icons.add_circle,color:Theme.of(context).colorScheme.secondary,size:27),

                                      ),
                                    ]),
                                  ),
                                ),

                              ),
                            ),
                            Div(
                              colS:8,
                              colM:8,
                              colL:8,
                              child:ElevatedButton(
                                onPressed: () {

                                  if(_con.productData.variantGroup.isNotEmpty) {
                                    _con.gatewayVariant(
                                        _con.productData,
                                        widget.product.combinationVariant,
                                        widget.shopDetails,
                                        _con.keyMatcher,
                                        _con.productData.totalSteps,
                                         'variant');
                                  }else{
                                    _con.gatewayVariant(
                                        _con.productData,
                                        widget.product.combinationVariant,
                                        widget.shopDetails,
                                        _con.productData.product_name,
                                        _con.productData.totalSteps,'variant');
                                  }



                                },
                                style:ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                                ),
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(
                                    S.of(context).add_item,
                                    style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: Theme.of(context).primaryColorLight)),
                                  ),
                                  Text(' ${Helper.pricePrint( _con.variantTotalAmount)}',
                                      style: Theme.of(context).textTheme.titleSmall.merge(TextStyle(color: Theme.of(context).colorScheme.primary),
                                      )
                                  )
                                ]),
                              ),
                            ),

                          ]
                      )
                  ),
                )
              ],

            )
        ),
      ),
    );
  }
}