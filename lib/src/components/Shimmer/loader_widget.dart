import 'dart:async';
import 'package:flutter/material.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({
    Key key,
  }) : super(key: key);

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  bool loading = true;

  @override
  void initState() {
    Timer(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        loading
            ? SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                ),
              )
            : const SizedBox(),
        Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            height: MediaQuery.of(context).size.height / 5,
          ),

        ])),
      ],
    );
  }
}
