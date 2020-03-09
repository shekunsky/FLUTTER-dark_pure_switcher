library dark_pure_switcher;

import 'package:flutter/material.dart';
import 'dark_pure_mode_switcher_controler.dart';
import 'dark_pure_mode_switcher_state.dart';
import 'dark_pure_mode_switcher_painter.dart';

typedef ValueChanged = Function(DarkPureModeSwitcherState state);

class DarkPureSwitcher extends StatefulWidget {
  static const double widthDefault = 60; //Default width for switcher
  static const double heightDefault = 30; //Default height for switcher
  static const DarkPureModeSwitcherState stateDefault =
      DarkPureModeSwitcherState.on; //Default state for switcher
  static const double heightToRadiusRatioDefault = 0.70;

  static const Color pureColorDefault = Color.fromARGB(255, 224, 224, 224);
  static const Color darkColorDefault = Color.fromARGB(255, 44, 44, 44);

  final double width;
  final double height;
  final double heightToRadiusRatio;
  final DarkPureModeSwitcherState state;
  final Color pureColor;
  final Color darkColor;
  final ValueChanged valueChanged;

  DarkPureSwitcher(
      {@required this.valueChanged,
      this.state = stateDefault,
      this.width = widthDefault,
      this.height = heightDefault,
      this.pureColor = pureColorDefault,
      this.darkColor = darkColorDefault,
      this.heightToRadiusRatio = heightToRadiusRatioDefault}) {
    assert(_colorIsValid(pureColor));
    assert(_colorIsValid(darkColor));
    assert(_heightToRadiusIsValid(heightToRadiusRatio));
    assert(_sizeIsValid(width, height));
  }

  @override
  _DarkPureSwitcherState createState() => _DarkPureSwitcherState();

  bool _sizeIsValid(double width, double height) {
    assert(width != null, 'Width argument was null.');
    assert(height != null, 'Height argument was null.');
    assert(width > height,
        'Width argument should be greater than height argument.');
    return true;
  }

  bool _colorIsValid(Color color) {
    assert(color != null, 'Color argument was null.');
    return true;
  }

  bool _heightToRadiusIsValid(double heightToRadius) {
    assert(heightToRadius != null, 'Height to radius argument was null.');
    assert(heightToRadius > 0 && heightToRadius < 1,
        'Height to radius argument Must be in the range 0 to 1');
    return true;
  }
}

class _DarkPureSwitcherState extends State<DarkPureSwitcher>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  DarkPureModeSwitcherController _slideController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _slideController =
        DarkPureModeSwitcherController(vsync: this, state: widget.state)
          ..addListener(() => setState(() {}));
    _setSwitcherState();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: GestureDetector(
        onTap: () {
          _updateSwitcherState();
          widget.valueChanged(_slideController.state);
        },
        onHorizontalDragUpdate: _updateStateOnHorizontalDrag,
        child: Container(
          height: widget.height,
          width: widget.width,
          child: CustomPaint(
            painter: DarkPurePainter(
                _slideController.progress, _slideController.state,
                darkColor: widget.darkColor,
                pureColor: widget.pureColor,
                heightToRadiusRatio: widget.heightToRadiusRatio),
          ),
        ),
      ),
    );
  }

  void _updateSwitcherState() {
    if (_slideController.state == DarkPureModeSwitcherState.on) {
      _slideController.setOffState();
    } else {
      _slideController.setOnState();
    }
    setState(() {});
    _slideController.prevState = _slideController.state;
  }

  void _setSwitcherState() {
    if (_slideController.state == DarkPureModeSwitcherState.on) {
      _slideController.setOnState();
    } else {
      _slideController.setOffState();
    }
    setState(() {});
  }

  void _updateStateOnHorizontalDrag(DragUpdateDetails details) {
    if (details.delta.dx > 0) {
      // swiping in right direction
      _slideController.setOnState();
    } else {
      // swiping in left direction
      _slideController.setOffState();
    }
    setState(() {});
    if (_slideController.prevState != _slideController.state) {
      widget.valueChanged(_slideController.state);
      _slideController.prevState = _slideController.state;
    }
  }
}
