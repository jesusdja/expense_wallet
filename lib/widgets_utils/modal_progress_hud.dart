import 'package:flutter/material.dart';

class ModalProgressHUD extends StatelessWidget {

  const ModalProgressHUD({
    super.key,
    required this.inAsyncCall,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.progressIndicator = const CircularProgressIndicator(),
    this.offset,
    this.dismissible = false,
    required this.child,
  });

  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final Widget progressIndicator;
  final Offset? offset;
  final bool dismissible;
  final Widget child;


  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (inAsyncCall) {
      Widget layOutProgressIndicator;
      if (offset == null){
        layOutProgressIndicator = Center(child: progressIndicator);
      } else {
        layOutProgressIndicator = Positioned(
          top: offset!.dy,
          left: offset!.dx,
          child: progressIndicator,
        );
      }
      final modal = [
        Opacity(
          opacity: opacity,
          child: ModalBarrier(dismissible: dismissible, color: color),
        ),
        layOutProgressIndicator
      ];
      widgetList += modal;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: widgetList,
      ),
    );
  }
}