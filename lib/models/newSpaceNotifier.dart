import "package:flexwork/helpers/firebaseService.dart";
import "package:flexwork/helpers/floorSketcher.dart";
import "package:flexwork/models/workspace.dart";
import "package:flutter/material.dart";
import "dart:math" as math;
import "../../models/floors.dart";
import "package:tuple/tuple.dart";

class NewSpaceNotifier extends ChangeNotifier {
  var _identifier = "";

  //coordinates are clockwise
  late Workspace workspace;

  NewSpaceNotifier(Floors floor) {
    workspace = Workspace(
      [
        const Tuple2(0, 0),
        const Tuple2(12, 0),
        const Tuple2(12, 18),
        const Tuple2(0, 18),
      ],
      "",
      floor,
    );
  }

  final _defaultAngle = 90 * math.pi / 180;
  var _currAngle = 90 * math.pi / 180;
  static const int _MAX_X = 321;
  static const int _MAX_Y = 144;

  // -------------- PUBLIC ------------------
  String getIdentifier() {
    return _identifier;
  }

  void setIdentifier(String identifier) {
    _identifier = identifier;
  }

  List<Tuple2<double, double>> getCoords() {
    return [...workspace.getCoords()];
  }

  Floors getFloor() {
    return workspace.getFloor();
  }

  bool setOneCoord(
      {required double x, required double y, required numOfCoord}) {
    final set = _setOneCoordinate(x: x, y: y, numOfCoord: numOfCoord);
    if (set == null) {
      return false;
    }
    workspace.setOneCoord(numOfCoord: numOfCoord, coord: set);
    notifyListeners();
    return true;
  }

  bool attemptSetOneCoord(
      {required double x, required double y, required numOfCoord}) {
    final attempt = _setOneCoordinate(x: x, y: y, numOfCoord: numOfCoord);
    if (attempt == null) {
      return false;
    }
    return true;
  }

  Tuple2<double, double>? _setOneCoordinate(
      {required double x, required double y, required numOfCoord}) {
    if (numOfCoord < 0 || numOfCoord > workspace.getCoords().length) {
      return null;
    }
    final coord = Tuple2(x, y);
    if (!_isWithinBounds(coord)) {
      return null;
    }
    return coord;
  }

  void addCoordinateFromLast() {
    workspace.addCoordinateFromLast();
    notifyListeners();
  }

  void deleteCoordinate(int numOfCoord) {
    workspace.deleteCoordinate(numOfCoord);
    notifyListeners();
  }

  //V
  bool setCoordinate(double x, double y) {
    final set = _setCoordinate(x, y);
    if (set == null) {
      return false;
    }
    workspace.setCoords(set);
    notifyListeners();
    return true;
  }

  bool attemptSetCoordinate(double x, double y) {
    final attempt = _setCoordinate(x, y);
    if (attempt == null) {
      return false;
    }
    return true;
  }

  List<Tuple2<double, double>>? _setCoordinate(double x, double y) {
    // print("== newSpaceNotifer: set coord");
    List<Tuple2<double, double>> newCoords = [];
    final origin = workspace.getCoords()[0];

    for (var coord in workspace.getCoords()) {
      final xOffset = coord.item1 - origin.item1;
      final yOffset = coord.item2 - origin.item2;
      final newCoord = Tuple2(x + xOffset, y + yOffset);
      if (!_isWithinBounds(newCoord)) {
        return null;
      }
      newCoords.add(newCoord);
    }
    return newCoords;
  }

  //V
  double getXCoordinate({int? numOfCoord}) {
    // print("== newSpaceNotifer: get x");
    return workspace.getCoords()[numOfCoord ?? 0].item1;
  }

  //V
  double getYCoordinate({int? numOfCoord}) {
    // print("== newSpaceNotifer: get y");
    return workspace.getCoords()[numOfCoord ?? 0].item2;
  }

  //V
  bool offsetCoordinates({required double x, required double y}) {
    print("== newSpaceNotifer: offset coord");
    List<Tuple2<double, double>> newCoords = [];

    // if angle is negligable
    if (_currAngle > _defaultAngle - 0.001 &&
        _currAngle < _defaultAngle + 0.001) {
      print("angle was negligable at $_currAngle");
      for (var coord in workspace.getCoords()) {
        final newCoord = Tuple2(coord.item1 + x, coord.item2 + y);
        if (!_isWithinBounds(newCoord)) {
          return false;
        }
        newCoords.add(newCoord);
      }
      workspace.setCoords(newCoords);
      notifyListeners();
      return true;
    }
    print("angle was not negligable at $_currAngle");
    // if there is an angle and an x offset
    if (x != 0) {
      for (var coord in workspace.getCoords()) {
        final newCoord = _rotateOffset(coord, _currAngle, x);
        if (!_isWithinBounds(newCoord)) {
          return false;
        }
        newCoords.add(newCoord);
      }
    }
    // if there is an angle and a y offset
    if (y != 0) {
      for (var coord in workspace.getCoords()) {
        final newCoord = _rotateOffset(coord, _currAngle + math.pi / 2, y);
        if (!_isWithinBounds(newCoord)) {
          return false;
        }
        newCoords.add(newCoord);
      }
    }
    workspace.setCoords(newCoords);
    notifyListeners();
    return true;
  }

  bool setWidth(double width) {
    print("== newSpaceNotifer: set width to $width");
    final set = _setWidth(width);
    if (set == null) {
      return false;
    }
    workspace.setCoords(set);
    notifyListeners();
    return true;
  }

  bool attemptSetWidth(double width) {
    print("== newSpaceNotifer: attempt set width to $width");
    final attempt = _setWidth(width);
    if (attempt == null) {
      return false;
    }
    return true;
  }

  //V
  // Note: this can only be applied to spaces with 4 coordinates
  List<Tuple2<double, double>>? _setWidth(double width) {
    final topLeft = workspace.getCoords()[0];
    final topRight = workspace.getCoords()[1];
    final bottomRight = workspace.getCoords()[2];
    final bottomLeft = workspace.getCoords()[3];
    late final Tuple2<double, double> newTopRight;
    late final Tuple2<double, double> newBottomRight;

    // if angle is negligable
    if (_currAngle > _defaultAngle - 0.001 &&
        _currAngle < _defaultAngle + 0.001) {
      newTopRight = Tuple2(topLeft.item1 + width, topRight.item2);
      newBottomRight = Tuple2(bottomLeft.item1 + width, bottomRight.item2);
    } else {
      newTopRight = _rotateOffset(topLeft, _currAngle, width);
      newBottomRight = _rotateOffset(bottomLeft, _currAngle, width);
    }

    if (!_isWithinBounds(newTopRight) || !_isWithinBounds(newBottomRight)) {
      return null;
    }
    return [
      topLeft,
      newTopRight,
      newBottomRight,
      bottomLeft,
    ];
  }

  // Note: this can only be applied to spaces with 4 coordinates
  double getWidth() {
    // print("== newSpaceNotifer: get width");
    final xDifference =
        workspace.getCoords()[1].item1 - workspace.getCoords()[0].item1;
    final yDifference =
        workspace.getCoords()[0].item2 - workspace.getCoords()[1].item2;

    return math.sqrt(xDifference * xDifference + yDifference * yDifference);
  }

  bool setHeight(double height) {
    print("== newSpaceNotifer: set height to $height");
    final set = _setHeight(height);
    if (set == null) {
      return false;
    }
    workspace.setCoords(set);
    notifyListeners();
    return true;
  }

  bool attemptSetHeight(double height) {
    print("== newSpaceNotifer: attempt set height to $height");
    final attempt = _setHeight(height);
    if (attempt == null) {
      return false;
    }
    return true;
  }

  //V
  List<Tuple2<double, double>>? _setHeight(double height) {
    final topLeft = workspace.getCoords()[0];
    final topRight = workspace.getCoords()[1];
    final bottomRight = workspace.getCoords()[2];
    final bottomLeft = workspace.getCoords()[3];
    late final Tuple2<double, double> newBottomLeft;
    late final Tuple2<double, double> newBottomRight;

    // if angle is negligable
    if (_currAngle > _defaultAngle - 0.001 &&
        _currAngle < _defaultAngle + 0.001) {
      newBottomLeft = Tuple2(bottomLeft.item1, topLeft.item2 + height);
      newBottomRight = Tuple2(bottomRight.item1, topRight.item2 + height);
    } else {
      newBottomLeft = _rotateOffset(topLeft, _currAngle + math.pi / 2, height);
      newBottomRight =
          _rotateOffset(bottomLeft, _currAngle + math.pi / 2, height);
    }

    if (!_isWithinBounds(newBottomLeft) || !_isWithinBounds(newBottomRight)) {
      return null;
    }
    return [
      topLeft,
      topRight,
      newBottomRight,
      newBottomLeft,
    ];
  }

  double getHeight() {
    // print("== newSpaceNotifer: get height");
    final xDifference =
        workspace.getCoords()[3].item1 - workspace.getCoords()[0].item1;
    final yDifference =
        workspace.getCoords()[3].item2 - workspace.getCoords()[0].item2;
    return math.sqrt(xDifference * xDifference + yDifference * yDifference);
  }

  bool setAngleInDegrees(double angle) {
    print("== newSpaceNotifer: set angel in degrees to $angle");
    return setAngleInRadians(angle * math.pi / 180);
  }

  bool attemptSetAngleInDegrees(double angle) {
    print("== newSpaceNotifer: attempt set angel in degrees to $angle");
    return attemptSetAngleRadians(angle * math.pi / 180);
  }

  bool attemptSetAngleRadians(double angle) {
    print("== newSpaceNotifer: attempt set angel in radians to $angle");
    final attempt = _setAngleInRadians(angle);
    if (attempt == null) {
      return false;
    }
    return true;
  }

  bool setAngleInRadians(double angle) {
    print("== newSpaceNotifer: set angel in radians to $angle");
    final set = _setAngleInRadians(angle);
    if (set == null) {
      return false;
    }
    workspace.setCoords(set);
    _currAngle = _getAngleBetweenCoords(
        workspace.getCoords()[0], workspace.getCoords()[1]);
    // print("during set angle: ${_currAngle * 180 / math.pi}");
    notifyListeners();
    return true;
  }

  //V
  List<Tuple2<double, double>>? _setAngleInRadians(double angle) {
    // print("== newSpaceNotifer: set angle");
    final pivot = workspace.getCoords()[0];
    final List<Tuple2<double, double>> newCoords = [workspace.getCoords()[0]];

    final angleOfCurrentSpace =
        _getAngleBetweenCoords(pivot, workspace.getCoords()[1]);
    if (angleOfCurrentSpace == angle + 0.5 * math.pi) {
      return null;
    }

    for (var i = 1; i < workspace.getCoords().length; i++) {
      final coord = workspace.getCoords()[i];
      final newAngle = angle + 0.5 * math.pi - angleOfCurrentSpace;

      final newCoord = _rotateAlongPivot(
        newAngle,
        pivot,
        coord,
      );

      if (!_isWithinBounds(newCoord)) {
        return null;
      }
      newCoords.add(newCoord);
    }
    return newCoords;
  }

  double getAngleDegrees() {
    // print("== newSpaceNotifer: get angle degrees");
    // print("getting angle in degrees. It is ${_currAngle * 180 / math.pi}");
    final toDegrees = (_currAngle * 180 / math.pi).abs();

    return toDegrees - 90;
  }

  Path getPath() {
    // print("== newSpaceNotifer: get path");
    if (workspace.getCoords().length <= 2) {
      print(
          "ERROR: in getPath() in newSpaceNotifier. There were not enough coords");
    }
    // start path
    final path = Path()
      ..moveTo(workspace.getCoords()[0].item1, workspace.getCoords()[0].item2);
    // traverse path
    for (var i = 1; i < workspace.getCoords().length; i++) {
      path.lineTo(
          workspace.getCoords()[i].item1, workspace.getCoords()[i].item2);
    }
    // complete path
    path.lineTo(workspace.getCoords()[0].item1, workspace.getCoords()[0].item2);
    return path;
  }

  bool isValid() {
    final outterWalls = FloorSketcher.getOutterWalls();

    late final Path innerWalls;
    switch (workspace.getFloor()) {
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

    for (var coord in workspace.getCoords()) {
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

    // for all segments in newSpace
    for (var newSpacepointMetric in newSpaceWoPadding.computeMetrics()) {
      // for all point in this segment
      for (var offset = 0.0; offset < newSpacepointMetric.length; offset++) {
        final currPointToCheck =
            newSpacepointMetric.getTangentForOffset(offset)!.position;
        // for all other workspaces
        for (var otherWorkspace in FirebaseService().getWorkspaces()) {
          final otherWorkspacePath = otherWorkspace.getPath();
          if (otherWorkspacePath.contains(currPointToCheck)) {
            return false;
          }
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
        _getAngleBetweenCoords(workspace.getCoords()[0], _getCenter());
    final firstNewCoord =
        _rotateOffset(workspace.getCoords()[0], firstPaddingAngle, padding);
    newSpaceWoPadding.moveTo(firstNewCoord.item1, firstNewCoord.item2);

    for (var i = 1; i < workspace.getCoords().length; i++) {
      final paddingAngle =
          _getAngleBetweenCoords(workspace.getCoords()[i], _getCenter());
      final newCoord =
          _rotateOffset(workspace.getCoords()[i], paddingAngle, padding);
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

    for (var coord in workspace.getCoords()) {
      sumX += coord.item1;
      sumY += coord.item2;
    }

    return Tuple2(sumX / workspace.getCoords().length,
        sumY / workspace.getCoords().length);
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
    for (var i = 0; i < workspace.getCoords().length; i++) {
      print(
          "$i: (${workspace.getCoords()[i].item1}, ${workspace.getCoords()[i].item2})");
    }
    print("current angle: $_currAngle");
    print(" --------------- $title -----------");
  }
}
