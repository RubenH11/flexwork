import "package:flexwork/helpers/floorSketcher.dart";
import "package:flutter/material.dart";
import "dart:math" as math;
import "../../models/floors.dart";
import "package:tuple/tuple.dart";

class NewSpaceNotifier extends ChangeNotifier {
  var _identifier = "";

  //coordinates are clockwise
  List<Tuple2<double, double>> coordinates = [
    const Tuple2(0, 0),
    const Tuple2(12, 0),
    const Tuple2(12, 18),
    const Tuple2(0, 18),
  ];
  final defaultAngle = 90 * math.pi/180;
  var currAngle = 90 * math.pi/180;
  static const int _MAX_X = 321;
  static const int _MAX_Y = 144;

  // -------------- PUBLIC ------------------
  String getIdentifier() {
    return _identifier;
  }

  void setIdentifier(String identifier) {
    _identifier = identifier;
  }

  //V
  bool setCoordinate(double x, double y) {
    // print("== newSpaceNotifer: set coord");
    List<Tuple2<double, double>> newCoords = [];
    final origin = coordinates[0];

    for (var coord in coordinates) {
      final xOffset = coord.item1 - origin.item1;
      final yOffset = coord.item2 - origin.item2;
      final newCoord = Tuple2(x + xOffset, y + yOffset);
      if (!_isWithinBounds(newCoord)) {
        return false;
      }
      newCoords.add(newCoord);
    }
    coordinates = newCoords;
    notifyListeners();
    return true;
  }

  //V
  double getXCoordinate() {
    // print("== newSpaceNotifer: get x");
    return coordinates[0].item1;
  }

  //V
  double getYCoordinate() {
    // print("== newSpaceNotifer: get y");
    return coordinates[0].item2;
  }

  //V
  bool offsetCoordinates({required double x, required double y}) {
    print("== newSpaceNotifer: offset coord");
    List<Tuple2<double, double>> newCoords = [];

    // if angle is negligable
    if (currAngle > defaultAngle - 0.001 && currAngle < defaultAngle + 0.001) {
      print("angle was negligable at $currAngle");
      for (var coord in coordinates) {
        final newCoord = Tuple2(coord.item1 + x, coord.item2 + y);
        if (!_isWithinBounds(newCoord)) {
          return false;
        }
        newCoords.add(newCoord);
      }
      coordinates = newCoords;
      notifyListeners();
      return true;
    }
    print("angle was not negligable at $currAngle");
    // if there is an angle and an x offset
    if (x != 0) {
      for (var coord in coordinates) {
        final newCoord = _rotateOffset(coord, currAngle, x);
        if (!_isWithinBounds(newCoord)) {
          return false;
        }
        newCoords.add(newCoord);
      }
    }
    // if there is an angle and a y offset
    if (y != 0) {
      for (var coord in coordinates) {
        final newCoord = _rotateOffset(coord, currAngle + math.pi / 2, y);
        if (!_isWithinBounds(newCoord)) {
          return false;
        }
        newCoords.add(newCoord);
      }
    }
    coordinates = newCoords;
    notifyListeners();
    return true;
  }

  //V
  // Note: this can only be applied to spaces with 4 coordinates
  bool setWidth(double width) {
    print("== newSpaceNotifer: set width to $width");

    final topLeft = coordinates[0];
    final topRight = coordinates[1];
    final bottomRight = coordinates[2];
    final bottomLeft = coordinates[3];
    late final Tuple2<double, double> newTopRight;
    late final Tuple2<double, double> newBottomRight;

    // if angle is negligable
    if (currAngle > defaultAngle - 0.001 && currAngle < defaultAngle + 0.001) {
      newTopRight = Tuple2(topLeft.item1 + width, topRight.item2);
      newBottomRight = Tuple2(bottomLeft.item1 + width, bottomRight.item2);
    } else {
      newTopRight = _rotateOffset(topLeft, currAngle, width);
      newBottomRight = _rotateOffset(bottomLeft, currAngle, width);
    }

    if (!_isWithinBounds(newTopRight) || !_isWithinBounds(newBottomRight)) {
      return false;
    }
    coordinates = [
      topLeft,
      newTopRight,
      newBottomRight,
      bottomLeft,
    ];
    notifyListeners();
    return true;
  }

  // Note: this can only be applied to spaces with 4 coordinates
  double getWidth() {
    // print("== newSpaceNotifer: get width");
    final xDifference = coordinates[1].item1 - coordinates[0].item1;
    final yDifference = coordinates[0].item2 - coordinates[1].item2;

    return math.sqrt(xDifference * xDifference + yDifference * yDifference);
  }

  //V
  bool setHeight(double height) {
    // print("== newSpaceNotifer: set height");

    final topLeft = coordinates[0];
    final topRight = coordinates[1];
    final bottomRight = coordinates[2];
    final bottomLeft = coordinates[3];
    late final Tuple2<double, double> newBottomLeft;
    late final Tuple2<double, double> newBottomRight;

    // if angle is negligable
    if (currAngle > defaultAngle - 0.001 && currAngle < defaultAngle + 0.001) {
      newBottomLeft = Tuple2(bottomLeft.item1, topLeft.item2 + height);
      newBottomRight = Tuple2(bottomRight.item1, topRight.item2 + height);
    } else {
      newBottomLeft = _rotateOffset(topLeft, currAngle + math.pi / 2, height);
      newBottomRight =
          _rotateOffset(bottomLeft, currAngle + math.pi / 2, height);
    }

    if (!_isWithinBounds(newBottomLeft) || !_isWithinBounds(newBottomRight)) {
      return false;
    }
    coordinates = [
      topLeft,
      topRight,
      newBottomRight,
      newBottomLeft,
    ];
    notifyListeners();
    return true;
  }

  double getHeight() {
    // print("== newSpaceNotifer: get height");
    final xDifference = coordinates[3].item1 - coordinates[0].item1;
    final yDifference = coordinates[3].item2 - coordinates[0].item2;
    return math.sqrt(xDifference * xDifference + yDifference * yDifference);
  }

  //V
  bool setAngle(double angleInRadians) {
    print("== newSpaceNotifer: set angle");
    final pivot = coordinates[0];
    final List<Tuple2<double, double>> newCoords = [coordinates[0]];

    final angleOfCurrentSpace = _getAngleBetweenCoords(pivot, coordinates[1]);
    if (angleOfCurrentSpace == angleInRadians + 0.5 * math.pi) {
      return false;
    }

    for (var i = 1; i < coordinates.length; i++) {
      final coord = coordinates[i];
      final angle = angleInRadians + 0.5*math.pi - angleOfCurrentSpace;

      final newCoord = _rotateAlongPivot(
        angle,
        pivot,
        coord,
      );

      if (!_isWithinBounds(newCoord)) {
        return false;
      }
      newCoords.add(newCoord);
    }
    coordinates = newCoords;
    currAngle = _getAngleBetweenCoords(coordinates[0], coordinates[1]);
    // print("during set angle: ${currAngle * 180 / math.pi}");
    notifyListeners();
    return true;
  }

  double getAngleDegrees() {
    // print("== newSpaceNotifer: get angle degrees");
    // print("getting angle in degrees. It is ${currAngle * 180 / math.pi}");
    final toDegrees = (currAngle * 180 / math.pi).abs();

    return toDegrees - 90;
  }

  Path getPath() {
    // print("== newSpaceNotifer: get path");
    if (coordinates.length <= 2) {
      print(
          "ERROR: in getPath() in newSpaceNotifier. There were not enough coords");
    }
    // start path
    final path = Path()..moveTo(coordinates[0].item1, coordinates[0].item2);
    // traverse path
    for (var i = 1; i < coordinates.length; i++) {
      path.lineTo(coordinates[i].item1, coordinates[i].item2);
    }
    // complete path
    path.lineTo(coordinates[0].item1, coordinates[0].item2);
    return path;
  }

  bool isValid(Floors floor) {
    final outterWalls = FloorSketcher.getOutterWalls();

    late final Path innerWalls;
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

    for (var coord in coordinates) {
      if (!outterWalls.contains(Offset(coord.item1, coord.item2))) {
        print("not within outter walls");
        return false;
      }
    }

    final newSpaceWoPadding = _getShrunkPath();
    final innerWallsMetrics = innerWalls.computeMetrics();
    for (var pointMetric in innerWallsMetrics) {
      for (var offset = 0.0; offset < pointMetric.length; offset = offset + 1) {
        final currPointToCheck =
            pointMetric.getTangentForOffset(offset)!.position;

        if (_pointIsWithinNewSpace(currPointToCheck, newSpaceWoPadding)) {
          print("on top of inner walls");
          return false;
        }
      }
    }
    return true;
  }

  // --------------- PRIVATE -----------------

  Path _getShrunkPath() {
    const padding = 1.0;
    var newSpaceWoPadding = Path();
    final firstPaddingAngle =
        _getAngleBetweenCoords(coordinates[0], _getCenter());
    final firstNewCoord =
        _rotateOffset(coordinates[0], firstPaddingAngle, padding);
    newSpaceWoPadding.moveTo(firstNewCoord.item1, firstNewCoord.item2);

    for (var i = 1; i < coordinates.length; i++) {
      final paddingAngle = _getAngleBetweenCoords(coordinates[i], _getCenter());
      final newCoord = _rotateOffset(coordinates[i], paddingAngle, padding);
      newSpaceWoPadding.lineTo(newCoord.item1, newCoord.item2);
    }
    newSpaceWoPadding.lineTo(firstNewCoord.item1, firstNewCoord.item2);
    return newSpaceWoPadding;
  }

  double _getAngleBetweenCoords(
      Tuple2<double, double> from, Tuple2<double, double> to) {
    final xDifference = to.item1 - from.item1;
    final yDifference = to.item2 - from.item2;
    final angle = math.atan2(yDifference, xDifference) + math.pi / 2;
    return angle >= 0 ? angle : (2 * math.pi) + angle;
  }

  Tuple2<double, double> _getCenter() {
    var sumX = 0.0;
    var sumY = 0.0;

    for (var coord in coordinates) {
      sumX += coord.item1;
      sumY += coord.item2;
    }

    return Tuple2(sumX / coordinates.length, sumY / coordinates.length);
  }

  double _degreesToRadians(double degrees) {
    return (degrees * math.pi / 180);
  }

  bool _isWithinBounds(Tuple2<double, double> coord) {
    return (coord.item1 <= _MAX_X && coord.item1 >= 0) &&
        (coord.item2 <= _MAX_Y && coord.item2 >= 0);
  }

  bool _pointIsWithinNewSpace(Offset offset, Path newSpacePath) {
    var coord = Tuple2(offset.dx, offset.dy);
    // final paddingAngle = _getAngleBetweenCoords(coord, _getCenter());
    // coord = _rotateOffset(coord, paddingAngle, padding);
    return newSpacePath.contains(Offset(coord.item1, coord.item2));
  }

  //V
  Tuple2<double, double> _rotateAlongPivot(double angleInRadians,
      Tuple2<double, double> pivot, Tuple2<double, double> coordToRotate) {
    // print("== newSpaceNotifer: rotate along pivot");

    // Translate to pivot pointdsdsds
    final movedCoord = Tuple2(
        coordToRotate.item1 - pivot.item1, coordToRotate.item2 - pivot.item2);

    final movedAndRotatedX = movedCoord.item1 * math.cos(angleInRadians) -
        movedCoord.item2 * math.sin(angleInRadians);
    final movedAndRotatedY = movedCoord.item1 * math.sin(angleInRadians) +
        movedCoord.item2 * math.cos(angleInRadians);

    // Translate back from pivot point
    final newCoord =
        Tuple2(movedAndRotatedX + pivot.item1, movedAndRotatedY + pivot.item2);

    return newCoord;
  }

  //V
  Tuple2<double, double> _rotateOffset(
      Tuple2<double, double> coord, double angleRadians, double offset) {
    late final double newX;
    late final double newY;

    if (angleRadians > 0 && angleRadians < 0.5 * math.pi) {
      // print("0-90");
      newX = coord.item1 + math.sin(angleRadians) * offset;
      newY = coord.item2 - math.cos(angleRadians) * offset;
    } else if (angleRadians > 0.5 * math.pi && angleRadians < math.pi) {
      // print("90-180");
      newX = coord.item1 + math.cos(angleRadians - 0.5 * math.pi) * offset;
      newY = coord.item2 + math.sin(angleRadians - 0.5 * math.pi) * offset;
    } else if (angleRadians > math.pi && angleRadians < 1.5 * math.pi) {
      // print("180-270");
      newX = coord.item1 - math.sin(angleRadians - math.pi) * offset;
      newY = coord.item2 + math.cos(angleRadians - math.pi) * offset;
    } else {
      // print("270-360");
      newX = coord.item1 - math.sin(angleRadians - 1.5 * math.pi) * offset;
      newY = coord.item2 - math.cos(angleRadians - 1.5 * math.pi) * offset;
    }

    return Tuple2(newX, newY);
  }

  void _printCoords(String title) {
    print(" ");
    print(" ------- Coords: $title ----------");
    for (var i = 0; i < coordinates.length; i++) {
      print("$i: (${coordinates[i].item1}, ${coordinates[i].item2})");
    }
    print("current angle: $currAngle");
    print(" --------------- $title -----------");
  }
}
