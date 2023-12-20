import 'package:flutter/material.dart';
import '../models/slide.dart';

class FixedBannerWidget extends StatefulWidget {
 final List<Slide> fixedSlider;
  const FixedBannerWidget({Key key, this.fixedSlider}) : super(key: key);


  @override
  State<FixedBannerWidget> createState() => _FixedBannerWidgetState();
}

class _FixedBannerWidgetState extends State<FixedBannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children:List.generate(widget.fixedSlider.length, (index) {
          Slide slider = widget.fixedSlider.elementAt(index);
          return index==0?InkWell(
            onTap: (){

            },
            child: Container(
                margin: const EdgeInsets.only(bottom:10),
                child:Container(
                    padding:const EdgeInsets.only(left:15,right:15),
                    height:100,width:double.infinity,
                    child:  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child:Image.network(slider.image,
                        fit: BoxFit.fill,
                      ),)
                )
            ),
          ):Container();
        })


    );
  }
}
