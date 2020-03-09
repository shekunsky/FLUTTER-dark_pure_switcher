import 'dart:ui';
import 'package:flutter/material.dart';
import 'dark_pure_mode_switcher_state.dart';

class DarkPurePainter extends CustomPainter {
  final double animationStep;
  final DarkPureModeSwitcherState sliderState;

  final double heightToRadiusRatio;
  final Color pureColor;
  final Color darkColor;

  DarkPurePainter(this.animationStep, this.sliderState,
      {this.darkColor, this.pureColor, this.heightToRadiusRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height / 2;
    final width = size.width;
    final radius = height * heightToRadiusRatio;
    final paintDark = _paintBuilder(darkColor);
    final paintPure = _paintBuilder(pureColor);

    if (sliderState == DarkPureModeSwitcherState.on) {
      final r = radius + (width - radius) * animationStep;
      _paintBackground(canvas, size, paintDark);
      _paintAnimationCircle(canvas, r, height, paintPure, width - height);
      _paintBackground(canvas, size, _paintBuilder(pureColor));
      _paintCircle(canvas, radius, height, paintDark, height);
    } else {
      final r = radius + (width - radius) * (1 - animationStep);
      _paintBackground(canvas, size, paintPure);
      _paintAnimationCircle(canvas, r, height, paintDark, height);
      _paintBackground(canvas, size, paintDark);
      _paintCircle(canvas, radius, height, paintPure, width - height);
    }
  }

  @override
  bool shouldRepaint(DarkPurePainter oldDelegate) => true;

  void _paintBackground(Canvas canvas, Size size, Paint paintSun) {
    final radiusCircle = size.height / 2;

    final path = Path()
      ..moveTo(radiusCircle, 0)
      ..lineTo(size.width - radiusCircle, 0)
      ..arcToPoint(Offset(size.width - radiusCircle, size.height),
          radius: Radius.circular(radiusCircle), clockwise: true)
      ..lineTo(radiusCircle, size.height)
      ..arcToPoint(Offset(radiusCircle, 0),
          radius: Radius.circular(radiusCircle), clockwise: true);

    canvas.drawPath(path, paintSun);
  }

  void _paintCircle(
      Canvas canvas, double radius, double height, Paint paint, double offset) {
    canvas.drawCircle(Offset(offset, height), radius, paint);
  }

  void _paintAnimationCircle(
      Canvas canvas, double radius, double height, Paint paint, double offset) {
    final circularPath = Path()
      ..addOval(
          Rect.fromCircle(center: Offset(offset, height), radius: radius));
    canvas.clipPath(circularPath, doAntiAlias: false);
  }

  Paint _paintBuilder(Color color) => Paint()
    ..color = color
    ..style = PaintingStyle.fill;
}
