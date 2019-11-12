import 'package:flutter/material.dart';

typedef Widget AnimationPageBuilder(BuildContext context,
    Animation<double> animation, Animation<double> secondaryAnimation);

class DialogRoute<T> extends PageRoute<T> {
  final Color barrierColor;
  final String barrierLabel;
  final bool maintainState;
  final Duration transitionDuration;
  final AnimationPageBuilder builder;

  DialogRoute({
    this.barrierColor = const Color(0x44FFFFFF),
    this.barrierLabel = "full",
    this.maintainState = true,
    this.transitionDuration = const Duration(milliseconds: 300),
    @required this.builder,
  }) : assert(barrierColor != Colors.transparent,
            "The barrierColor must not be transparent.");

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context, animation, secondaryAnimation);
  }
}

class FullScreenRoute<T> extends DialogRoute<T> {
  FullScreenRoute({WidgetBuilder builder})
      : super(builder: (ctx, a, s) => fullScreenBuilder(ctx, builder, a, s));

  static Widget fullScreenBuilder(
    BuildContext context,
    WidgetBuilder builder,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: builder(context),
        );
      },
    );
  }
}
