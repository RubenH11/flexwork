import "package:flexwork/helpers/floorSketcher.dart";
import "package:flutter/material.dart";
import "dart:math" as math;
import "../../models/floors.dart";
import "package:tuple/tuple.dart";

class NewSpaceNotifier extends ChangeNotifier {
  var _identifier = "";
  double _xTopLeft = 0;
  double _yTopLeft = 0;
  double _xTopRight = 12;
  double _yTopRight = 0;
  double _xBottomLeft = 0;
  double _yBottomLeft = 18;
  double _xBottomRight = 12;
  double _yBottomRight = 18;
  // List<Tuple2<double, double>> coordinates = [];
  var currAngle = 0.0;
  static const int _MAX_X = 321;
  static const int _MAX_Y = 144;

  // -------------- PUBLIC ------------------
  String getIdentifier(){
    return _identifier;
  }

  void setIdentifier(String identifier){
    _identifier = identifier;
  }

  //V
  void setCoordinate({required double x, required double y}) {
    // print("== newSpaceNotifer: set coord");


    final xTopRightOffset = _xTopRight - _xTopLeft;
    final yTopRightOffset = _yTopRight - _yTopLeft;
    final xBottomRightOffset = _xBottomRight - _xTopLeft;
    final yBottomRightOffset = _yBottomRight - _yTopLeft;
    final xBottomLeftOffset = _xBottomLeft - _xTopLeft;
    final yBottomLeftOffset = _yBottomLeft - _yTopLeft;

    if (x != null &&
        _isWithinBounds(x, _yTopLeft) &&
        _isWithinBounds(x + xTopRightOffset, _yTopRight) &&
        _isWithinBounds(x + xBottomLeftOffset, _yBottomLeft) &&
        _isWithinBounds(x + xBottomRightOffset, _yBottomRight)) {
      _xTopLeft = x;
      _xTopRight = x + xTopRightOffset;
      _xBottomLeft = x + xBottomLeftOffset;
      _xBottomRight = x + xBottomRightOffset;
    }
    if (y != null &&
        _isWithinBounds(_xTopLeft, y) &&
        _isWithinBounds(_xTopRight, _yTopRight + yTopRightOffset) &&
        _isWithinBounds(_xBottomLeft, _yBottomLeft + yBottomLeftOffset) &&
        _isWithinBounds(_xBottomRight, _yBottomRight + yBottomRightOffset)) {
      _yTopLeft = y;
      _yTopRight = y + yTopRightOffset;
      _yBottomLeft = y + yBottomLeftOffset;
      _yBottomRight = y + yBottomRightOffset;
    }
    notifyListeners();
  }

  //V
  double getXCoordinate() {
    // print("== newSpaceNotifer: get x");
    return _xTopLeft;
  }

  //V
  double getYCoordinate() {
    // print("== newSpaceNotifer: get y");
    return _yTopLeft;
  }

  //V
  bool offsetCoordinates({required double x, required double y}) {
    // print("== newSpaceNotifer: offset coord");
    var newTopLeft = {"x": _xTopLeft, "y": _yTopLeft};
    var newTopRight = {"x": _xTopRight, "y": _yTopRight};
    var newBottomLeft = {"x": _xBottomLeft, "y": _yBottomLeft};
    var newBottomRight = {"x": _xBottomRight, "y": _yBottomRight};

    if (x != 0 && (currAngle < -0.001 || currAngle > 0.001)) {
      print("1");
      newTopLeft = _rotateOffset(newTopLeft, currAngle, x);
      newTopRight = _rotateOffset(newTopRight, currAngle, x);
      newBottomLeft = _rotateOffset(newBottomLeft, currAngle, x);
      newBottomRight = _rotateOffset(newBottomRight, currAngle, x);
    }
    else if(x != 0){
      print("2");
      newTopLeft.addAll({"x": _xTopLeft + x});
      newTopRight.addAll({"x": _xTopRight + x});
      newBottomLeft.addAll({"x": _xBottomLeft + x});
      newBottomRight.addAll({"x": _xBottomRight + x});
    }

    if (y != 0 && (currAngle < -0.001 || currAngle > 0.001)) {
      print("3");
      newTopLeft = _rotateOffset(newTopLeft, currAngle + math.pi / 2, y);
      newTopRight = _rotateOffset(newTopRight, currAngle + math.pi / 2, y);
      newBottomLeft = _rotateOffset(newBottomLeft, currAngle + math.pi / 2, y);
      newBottomRight = _rotateOffset(newBottomRight, currAngle + math.pi / 2, y);
    }
    else if(y != 0){
      print("4");
      newTopLeft.addAll({"y": _yTopLeft + y});
      newTopRight.addAll({"y": _yTopRight + y});
      newBottomLeft.addAll({"y": _yBottomLeft + y});
      newBottomRight.addAll({"y": _yBottomRight + y});
    }

    if (_isWithinBounds(newTopLeft["x"]!, newTopLeft["y"]!) &&
        _isWithinBounds(newTopRight["x"]!, newTopRight["y"]!) &&
        _isWithinBounds(newBottomLeft["x"]!, newBottomLeft["y"]!) &&
        _isWithinBounds(newBottomRight["x"]!, newBottomRight["y"]!)) {
      _xTopLeft = newTopLeft["x"]!;
      _yTopLeft = newTopLeft["y"]!;
      _xTopRight = newTopRight["x"]!;
      _yTopRight = newTopRight["y"]!;
      _xBottomLeft = newBottomLeft["x"]!;
      _yBottomLeft = newBottomLeft["y"]!;
      _xBottomRight = newBottomRight["x"]!;
      _yBottomRight = newBottomRight["y"]!;
      notifyListeners();
      return true;
    }
    return false;
  }

  //V
  bool setWidth(double width) {
    print("== newSpaceNotifer: set width to $width");

    final newTopRight =
        _rotateOffset({"x": _xTopLeft, "y": _yTopLeft}, currAngle, width);
    final newBottomRight =
        _rotateOffset({"x": _xBottomLeft, "y": _yBottomLeft}, currAngle, width);

    if (_isWithinBounds(newTopRight["x"]!, newTopRight["y"]!) &&
        _isWithinBounds(newBottomRight["x"]!, newBottomRight["y"]!)) {
      _xTopRight = newTopRight["x"]!;
      _yTopRight = newTopRight["y"]!;
      _xBottomRight = newBottomRight["x"]!;
      _yBottomRight = newBottomRight["y"]!;
      _printCoords("after width is set");
      notifyListeners();
      return true;
    }
    return false;
  }

  double getWidth() {
    // print("== newSpaceNotifer: get width");
    final xDifference = _xTopRight - _xTopLeft;
    final yDifference = _yTopLeft - _yTopRight;

    return math.sqrt(xDifference * xDifference + yDifference * yDifference);
  }

  //V
  bool setHeight(double height) {
    // print("== newSpaceNotifer: set height");
    currAngle = getAngleRadians();

    final newBottomLeft = _rotateOffset(
        {"x": _xTopLeft, "y": _yTopLeft}, currAngle + math.pi / 2, height);
    final newBottomRight = _rotateOffset(
        {"x": _xTopRight, "y": _yTopRight}, currAngle + math.pi / 2, height);

    if (_isWithinBounds(newBottomLeft["x"]!, newBottomLeft["y"]!) &&
        _isWithinBounds(newBottomRight["x"]!, newBottomRight["y"]!)) {
      _xBottomLeft = newBottomLeft["x"]!;
      _yBottomLeft = newBottomLeft["y"]!;
      _xBottomRight = newBottomRight["x"]!;
      _yBottomRight = newBottomRight["y"]!;
      notifyListeners();
      return true;
    }
    return false;
  }

  double getHeight() {
    // print("== newSpaceNotifer: get height");
    final xDifference = _xBottomLeft - _xTopLeft;
    final yDifference = _yBottomLeft - _yTopLeft;
    return math.sqrt(xDifference * xDifference + yDifference * yDifference);
  }

  //V
  bool setAngle(double angle) {
    // print("== newSpaceNotifer: set angle");
    final topRightcoords = _rotateAlongPivot(
        _degreesToRadians(angle) - getAngleRadians(),
        _xTopLeft,
        _yTopLeft,
        _xTopRight,
        _yTopRight);
    final bottomRightCoords = _rotateAlongPivot(
        _degreesToRadians(angle) - getAngleRadians(),
        _xTopLeft,
        _yTopLeft,
        _xBottomRight,
        _yBottomRight);
    final bottomLeftCoords = _rotateAlongPivot(
        _degreesToRadians(angle) - getAngleRadians(),
        _xTopLeft,
        _yTopLeft,
        _xBottomLeft,
        _yBottomLeft);

    if (_isWithinBounds(topRightcoords["x"]!, topRightcoords["y"]!) &&
        _isWithinBounds(bottomRightCoords["x"]!, bottomRightCoords["y"]!) &&
        _isWithinBounds(bottomLeftCoords["x"]!, bottomLeftCoords["y"]!)) {
      _xTopRight = topRightcoords["x"]!;
      _yTopRight = topRightcoords["y"]!;
      _xBottomRight = bottomRightCoords["x"]!;
      _yBottomRight = bottomRightCoords["y"]!;
      _xBottomLeft = bottomLeftCoords["x"]!;
      _yBottomLeft = bottomLeftCoords["y"]!;
      currAngle = getAngleRadians();
      notifyListeners();
      return true;
    }
    return false;
  }

  double getAngleDegrees() {
    // print("== newSpaceNotifer: get angle degrees");
    return (currAngle * 180 / math.pi).abs();
  }

  double getAngleRadians() {
    // print("== newSpaceNotifer: get angle radians");
    return -math.atan((_yTopLeft - _yTopRight) / (_xTopRight - _xTopLeft));
  }

  double _degreesToRadians(double degrees) {
    return (degrees * math.pi / 180);
  }

  //V
  bool _isWithinBounds(double x, double y) {
    return (x <= _MAX_X && x >= 0) && (y <= _MAX_Y && y >= 0);
  }

  Path getPath() {
    // print("== newSpaceNotifer: get path");
    return Path()
      ..moveTo(_xTopLeft, _yTopLeft)
      ..lineTo(_xTopRight, _yTopRight)
      ..lineTo(_xBottomRight, _yBottomRight)
      ..lineTo(_xBottomLeft, _yBottomLeft)
      ..lineTo(_xTopLeft, _yTopLeft);
  }

  bool isValid(Floors floor) {
    final outterWalls = FloorSketcher.getOutterWalls();

    late final innerWalls;
    switch (floor) {
      case Floors.f9:
        innerWalls = FloorSketcher.getFloor9InnerWalls();
        break;
      case Floors.f10:
        innerWalls = FloorSketcher.getFloor10InnerWalls();
        break;
      case Floors.f11:
        innerWalls = FloorSketcher.getFloor11InnerWalls();
        break;
      case Floors.f12:
        innerWalls = FloorSketcher.getFloor12InnerWalls();
        break;
    }

    final padding = 0.5;
    //outside outterWalls
    if (!outterWalls.contains(Offset(_xTopLeft+padding, _yTopLeft+padding)) ||
        !outterWalls.contains(Offset(_xTopRight-padding, _yTopRight+padding)) ||
        !outterWalls.contains(Offset(_xBottomLeft+padding, _yBottomLeft-padding)) ||
        !outterWalls.contains(Offset(_xBottomRight-padding, _yBottomRight-padding))) {
      return false;
    }
    if (!outterWalls.contains(Offset(_xTopLeft+padding, _yTopLeft+padding)) ||
        !outterWalls.contains(Offset(_xTopRight-padding, _yTopRight+padding)) ||
        !outterWalls.contains(Offset(_xBottomLeft+padding, _yBottomLeft-padding)) ||
        !outterWalls.contains(Offset(_xBottomRight-padding, _yBottomRight-padding))) {
      return false;
    }
    final innerWallsMetrics = innerWalls.computeMetrics();
    for (var pointMetric in innerWallsMetrics) {
      final lengthOfLine = pointMetric.length;
      // print("inner wall with length of $lengthOfLine");
      for (var offset = 0.0; offset < lengthOfLine; offset++) {
        final currPointToCheck = pointMetric.getTangentForOffset(offset)!.position;
        if(_pointIsWithinNewSpace(currPointToCheck, padding)){
          return false;
        }
      }
    }
    return true;
  }

  bool _pointIsWithinNewSpace(Offset point, double padding){
    final newSpace = Path()
      ..moveTo(_xTopLeft+padding, _yTopLeft+padding)
      ..lineTo(_xTopRight-padding, _yTopRight+padding)
      ..lineTo(_xBottomRight-padding, _yBottomRight-padding)
      ..lineTo(_xBottomLeft+padding, _yBottomLeft-padding)
      ..lineTo(_xTopLeft+padding, _yTopLeft+padding);
    return newSpace.contains(point);
  }


  // --------------- PRIVATE -----------------
  //V
  Map<String, double> _rotateAlongPivot(
      double angleInRadians, double xPivot, double yPivot, double x, double y) {
    // print("== newSpaceNotifer: rotate along pivot");

    // Translate to pivot pointdsdsds
    double movedX = x - xPivot;
    double movedY = y - yPivot;

    double movedAndRotatedX =
        movedX * math.cos(angleInRadians) - movedY * math.sin(angleInRadians);
    double movedAndRotatedY =
        movedX * math.sin(angleInRadians) + movedY * math.cos(angleInRadians);

    // Translate back from pivot point
    double newX = movedAndRotatedX + xPivot;
    double newY = movedAndRotatedY + yPivot;

    return {"x": newX, "y": newY};
  }

  //V
  Map<String, double> _rotateOffset(
      Map<String, double> coords, double angleRadians, double offset) {
    // print("== newSpaceNotifer: rotate offset");
    final newCoords = {
      "x": coords["x"]! + math.cos(angleRadians) * offset,
      "y": coords["y"]! + math.sin(angleRadians) * offset,
    };
    // print(
    //     "rotate offset of $offset with angle of ${angleRadians * 180 / math.pi}");
    // print("  from $coords to $newCoords");
    return newCoords;
  }

  void _printCoords(String title) {
    print(" ");
    print(" ------- Coords: $title ----------");
    print("TopLeft: ($_xTopLeft, $_yTopLeft)");
    print("TopRight: ($_xTopRight, $_yTopRight)");
    print("BottomLeft: ($_xBottomLeft, $_yBottomLeft)");
    print("BottomRight: ($_xBottomRight, $_yBottomRight)");
    print("current angle: $currAngle");
    print(" --------------- $title -----------");
  }
}
