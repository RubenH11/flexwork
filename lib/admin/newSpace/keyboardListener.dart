import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "dart:async";
import "package:provider/provider.dart";
import '../../models/newSpaceNotifier.dart';
import 'rectMenu.dart';
import "./content.dart";
import "../../widgets/layout.dart";
import "../../models/floors.dart";
import "../../widgets/customElevatedButton.dart";
import "./menuInfiniteCoords.dart";

class NewSpaceKeyboardListener extends StatefulWidget {
  final Floors floor;
  final FocusNode focusNode;
  const NewSpaceKeyboardListener({required this.floor, required this.focusNode,
  super.key});

  @override
  State<NewSpaceKeyboardListener> createState() => _KeyboardListenerState();
}

class _KeyboardListenerState extends State<NewSpaceKeyboardListener> {
  var isRectangularSpace = true;

  var _upDebounce = Timer(Duration(milliseconds: 0), () {});

  var _rightDebounce = Timer(Duration(milliseconds: 0), () {});

  var _leftDebounce = Timer(Duration(milliseconds: 0), () {});

  var _downDebounce = Timer(Duration(milliseconds: 0), () {});

  var _upAlreadyPressed = false;

  var _leftAlreadyPressed = false;

  var _rightAlreadyPressed = false;

  var _downAlreadyPressed = false;

  @override
  void initState() {
    widget.focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _upDebounce.cancel();
    _rightDebounce.cancel();
    _leftDebounce.cancel();
    _downDebounce.cancel();
    super.dispose();
  }

  void _handleKeyEvent(NewSpaceNotifier newSpace, RawKeyEvent keyEvent) {
    if(FocusManager.instance.primaryFocus is IgnoreOthersFocusnode){
      return;
    }
    
    final numMiliSecondsBeforeHoldDown = 200;
    // print("key pressed");
    if (keyEvent is RawKeyDownEvent) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.keyW &&
          !_upAlreadyPressed) {
        newSpace.offsetCoordinates(horizontal: 0, vertical: -1);
        _upAlreadyPressed = true;
        _upDebounce = Timer(
            Duration(milliseconds: numMiliSecondsBeforeHoldDown),
            () => _handleUpHoldDownEvent(newSpace));
      }
      if (keyEvent.logicalKey == LogicalKeyboardKey.keyD &&
          !_rightAlreadyPressed) {
        newSpace.offsetCoordinates(horizontal: 1, vertical: 0);
        _rightAlreadyPressed = true;
        _rightDebounce = Timer(
            Duration(milliseconds: numMiliSecondsBeforeHoldDown),
            () => _handleRightHoldDownEvent(newSpace));
      }
      if (keyEvent.logicalKey == LogicalKeyboardKey.keyA &&
          !_leftAlreadyPressed) {
        newSpace.offsetCoordinates(horizontal: -1, vertical: 0);
        _leftAlreadyPressed = true;
        _leftDebounce = Timer(
            Duration(milliseconds: numMiliSecondsBeforeHoldDown),
            () => _handleLeftHoldDownEvent(newSpace));
      }
      if (keyEvent.logicalKey == LogicalKeyboardKey.keyS &&
          !_downAlreadyPressed) {
        newSpace.offsetCoordinates(horizontal: 0, vertical: 1);
        _downAlreadyPressed = true;
        _downDebounce = Timer(
            Duration(milliseconds: numMiliSecondsBeforeHoldDown),
            () => _handleDownHoldDownEvent(newSpace));
      }
    } else if (keyEvent is RawKeyUpEvent) {
      if (keyEvent.logicalKey == LogicalKeyboardKey.keyW) {
        _upAlreadyPressed = false;
        _upDebounce.cancel();
      }
      if (keyEvent.logicalKey == LogicalKeyboardKey.keyD) {
        _rightAlreadyPressed = false;
        _rightDebounce.cancel();
      }
      if (keyEvent.logicalKey == LogicalKeyboardKey.keyA) {
        _leftAlreadyPressed = false;
        _leftDebounce.cancel();
      }
      if (keyEvent.logicalKey == LogicalKeyboardKey.keyS) {
        _downAlreadyPressed = false;
        _downDebounce.cancel();
      }
    }
  }

  void _handleUpHoldDownEvent(NewSpaceNotifier newSpace) {
    if (_upAlreadyPressed) {
      newSpace.offsetCoordinates(horizontal: 0, vertical: -1);
    }
    _upDebounce = Timer(
        Duration(milliseconds: 5), () => _handleUpHoldDownEvent(newSpace));
  }

  void _handleRightHoldDownEvent(NewSpaceNotifier newSpace) {
    if (_rightAlreadyPressed) {
      newSpace.offsetCoordinates(horizontal: 1, vertical: 0);
    }
    _rightDebounce = Timer(
        Duration(milliseconds: 5), () => _handleRightHoldDownEvent(newSpace));
  }

  void _handleLeftHoldDownEvent(NewSpaceNotifier newSpace) {
    if (_leftAlreadyPressed) {
      newSpace.offsetCoordinates(horizontal: -1, vertical: 0);
    }
    _leftDebounce = Timer(
        Duration(milliseconds: 5), () => _handleLeftHoldDownEvent(newSpace));
  }

  void _handleDownHoldDownEvent(NewSpaceNotifier newSpace) {
    if (_downAlreadyPressed) {
      newSpace.offsetCoordinates(horizontal: 0, vertical: 1);
    }
    _downDebounce = Timer(
        Duration(milliseconds: 5), () => _handleDownHoldDownEvent(newSpace));
  }

  void update() {
    setState(() {});
  }

  var isValid = true;

  @override
  Widget build(BuildContext context) {
    print("build newSpace");
    final newSpace = Provider.of<NewSpaceNotifier>(context);
    isValid = newSpace.isValid(widget.floor);

    return RawKeyboardListener(
      focusNode: widget.focusNode,
      onKey: (keyEvent) => _handleKeyEvent(newSpace, keyEvent),
      child: NewSpaceContent(isValid: isValid, moveFocusNode: widget.focusNode),
    );
  }
}

class IgnoreOthersFocusnode extends FocusNode{}
