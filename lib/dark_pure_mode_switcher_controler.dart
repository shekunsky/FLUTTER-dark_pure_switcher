import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dark_pure_mode_switcher_state.dart';

class DarkPureModeSwitcherController extends ChangeNotifier {
  static const int durationDefault = 350; //Default animation duration (milisec)
  static const double valueStart = 0.0; //Default start value
  static const double valueEnd = 1.0; //Default end value

  final AnimationController controller;
  Animation colorTween;

  DarkPureModeSwitcherState state = DarkPureModeSwitcherState.on;
  DarkPureModeSwitcherState prevState = DarkPureModeSwitcherState.on;

  double get progress => controller.value;

  DarkPureModeSwitcherController({@required TickerProvider vsync, this.state})
      : controller = AnimationController(vsync: vsync) {
    controller.addListener(_onStateUpdate);
    prevState = state;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onStateUpdate() {
    notifyListeners();
  }

  void _startAnimation(double animationTo) {
    controller
      ..duration = const Duration(milliseconds: durationDefault)
      ..animateTo(animationTo);
    notifyListeners();
  }

  void setOnState() {
    _startAnimation(valueStart);
    state = DarkPureModeSwitcherState.on;
  }

  void setOffState() {
    _startAnimation(valueEnd);
    state = DarkPureModeSwitcherState.off;
  }
}
