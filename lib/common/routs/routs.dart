import 'package:flutter/material.dart';

class NavigationPage extends PageRouteBuilder {
  NavigationPage({
    required this.child,
    Duration duration=const Duration(milliseconds: 300)
    }) : super(
   pageBuilder: (context, animation, secondaryAnimation) => child,
   transitionDuration: duration,
   reverseTransitionDuration: duration,
   transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
    position: animation.drive(Tween<Offset>(begin:const Offset(1, 0),end: Offset.zero)),child: child,)

  );
  final Widget child;
}
