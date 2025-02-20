import 'package:flutter/material.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget Function(BuildContext) builder;
  @override
  final RouteSettings settings;

  SlidePageRoute({required this.builder, required this.settings})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              builder(context),
          settings: settings,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(
                    1.0, 0.0), // Change the Offset to change direction
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
