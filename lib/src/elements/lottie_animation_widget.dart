import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
//ignore: must_be_immutable
class LottieAnimationWidget extends StatefulWidget {
   String jsonData;

   LottieAnimationWidget({Key key, this.jsonData}) : super(key: key);


  @override
  State<LottieAnimationWidget> createState() => _LottieAnimationWidgetState();
}

class _LottieAnimationWidgetState extends State<LottieAnimationWidget>  with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int cont = 0;
  int targetCount = 10;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        cont++;
        if (cont < 10) {
          _controller.reset();
          _controller.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Lottie.asset(widget.jsonData,
      controller: _controller,
      animate: true,
      onLoaded: (composition) {
        _controller.duration = composition.duration;
        _controller.forward();
      },
    );
  }
}