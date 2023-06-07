import "package:flexwork/helpers/floorSketcher.dart";
import "package:flexwork/models/workspace.dart";
import "package:flutter/material.dart";
import "dart:math" as math;
import "../../models/floors.dart";
import "package:tuple/tuple.dart";

class NewSpaceNotifier extends Workspace {
  //coordinates are clockwise

  //NewSpaceNotifier({required super.id, required super.floor, required super.coordinates, required super.identifier, required super.nickname, required super.type, required super.numMonitors, required super.numWhiteboards, required super.numScreens, required super.blockedMoments}, this._floor);

  NewSpaceNotifier({
    required super.floor,
    super.coordinates,
    super.identifier,
    super.nickname,
    super.type,
    super.numMonitors,
    super.numWhiteboards,
    super.numScreens,
    super.blockedMoments,
  })  : _coordinates = coordinates,
        _currAngle = 90.0,
        super(id: 0, color: Colors.black, changeNotifyBasics: false) {
    if (_coordinates.length > 1) {
      _currAngle = _getAngleBetweenCoords(
        Tuple2(_coordinates[0].item1, _coordinates[0].item2),
        Tuple2(_coordinates[1].item1, _coordinates[1].item2),
      );
    }
  }

  List<Tuple2<double, double>> _coordinates;
  double _currAngle;
  bool hasConflict = false;

  final _defaultAngle = 90 * math.pi / 180;
  // var _currAngle = 90.0;
  static const int _MAX_X = 321;
  static const int _MAX_Y = 144;

  // -------------- PUBLIC ------------------

  // Workspace finalize(int id) {
  //   return Workspace(
  //     id: id,
  //     floor: getFloor(),
  //     blockedMoments: getBlockedMoments(),
  //     coordinates: _coordinates,
  //     identifier: getIdentifier(),
  //     nickname: getNickname(),
  //     numMonitors: getNumMonitors(),
  //     numScreens: getNumScreens(),
  //     numWhiteboards: getNumWhiteboards(),
  //     type: getType(),
  //     color: getColor(),
  //     changeNotifyBasics: false,
  //   );
  // }

  @override
  List<Tuple2<double, double>> getCoords() {
    return [..._coordinates];
  }

  @override
  Path getPath() {
    // print("== newSpaceNotifer: get path");
    if (_coordinates.length <= 2) {
      print(
          "ERROR: in getPath() in newSpaceNotifier. There were not enough coords");
    }
    // start path
    final path = Path()..moveTo(_coordinates[0].item1, _coordinates[0].item2);

    // traverse path
    for (var i = 1; i < _coordinates.length; i++) {
      print("  ${_coordinates[i]}");
      path.lineTo(_coordinates[i].item1, _coordinates[i].item2);
    }
    // complete path
    path.lineTo(_coordinates[0].item1, _coordinates[0].item2);
    return path;
  }

  bool setOneCoord(
      {required double x, required double y, required numOfCoord}) {
    final set = _setOneCoordinate(x: x, y: y, numOfCoord: numOfCoord);
    if (set == null) {
      return false;
    }
    _coordinates[numOfCoord] = set;
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
    if (numOfCoord < 0 || numOfCoord > _coordinates.length) {
      return null;
    }
    final coord = Tuple2(x, y);
    if (!_isWithinBounds(coord)) {
      return null;
    }
    return coord;
  }

  void addCoordinateFromLast() {
    final numCoords = _coordinates.length;
    _coordinates.add(_coordinates[numCoords - 1]);
    notifyListeners();
  }

  void deleteCoordinate(int numOfCoord) {
    _coordinates.removeAt(numOfCoord);
    notifyListeners();
  }

  //V
  bool setCoordinate(double x, double y) {
    final set = _setCoordinate(x, y);
    if (set == null) {
      return false;
    }
    _coordinates = set;
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
    final origin = _coordinates[0];

    for (var coord in _coordinates) {
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
    return _coordinates[numOfCoord ?? 0].item1;
  }

  //V
  double getYCoordinate({int? numOfCoord}) {
    // print("== newSpaceNotifer: get y");
    return _coordinates[numOfCoord ?? 0].item2;
  }

  //V
  bool offsetCoordinates(
      {required double horizontal, required double vertical}) {
    // print("== newSpaceNotifer: offset coord");
    List<Tuple2<double, double>> newCoords = [];

    if (horizontal != 0) {
      // print("horizontal is called while angle = $_currAngle");
      for (var coord in _coordinates) {
        final newCoord = _rotateOffset(coord, _currAngle, horizontal);
        if (!_isWithinBounds(newCoord)) {
          return false;
        }
        newCoords.add(newCoord);
      }
    }
    if (vertical != 0) {
      // print("vertical is called while angle = $_currAngle");
      for (var coord in _coordinates) {
        final newCoord = _rotateOffset(coord, _currAngle + 90, vertical);
        if (!_isWithinBounds(newCoord)) {
          return false;
        }
        newCoords.add(newCoord);
      }
    }
    _coordinates = newCoords;
    notifyListeners();
    return true;
  }

  bool setWidth(double width) {
    // print("== newSpaceNotifer: set width to $width");
    final set = _setWidth(width);
    if (set == null) {
      return false;
    }
    _coordinates = set;
    notifyListeners();
    return true;
  }

  bool attemptSetWidth(double width) {
    // print("== newSpaceNotifer: attempt set width to $width");
    final attempt = _setWidth(width);
    if (attempt == null) {
      return false;
    }
    return true;
  }

  //V
  // Note: this can only be applied to spaces with 4 coordinates
  List<Tuple2<double, double>>? _setWidth(double width) {
    final topLeft = _coordinates[0];
    final bottomLeft = _coordinates[3];

    final newTopRight = _rotateOffset(topLeft, _currAngle, width);
    final newBottomRight = _rotateOffset(bottomLeft, _currAngle, width);

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
    final xDifference = _coordinates[1].item1 - _coordinates[0].item1;
    final yDifference = _coordinates[0].item2 - _coordinates[1].item2;

    return math.sqrt(xDifference * xDifference + yDifference * yDifference);
  }

  bool setHeight(double height) {
    // print("== newSpaceNotifer: set height to $height");
    final set = _setHeight(height);
    if (set == null) {
      return false;
    }
    _coordinates = set;
    notifyListeners();
    return true;
  }

  bool attemptSetHeight(double height) {
    // print("== newSpaceNotifer: attempt set height to $height");
    final attempt = _setHeight(height);
    if (attempt == null) {
      return false;
    }
    return true;
  }

  //V
  List<Tuple2<double, double>>? _setHeight(double height) {
    final topLeft = _coordinates[0];
    final topRight = _coordinates[1];

    final newBottomLeft = _rotateOffset(topLeft, _currAngle + 90, height);
    final newBottomRight = _rotateOffset(topRight, _currAngle + 90, height);

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
    final xDifference = _coordinates[3].item1 - _coordinates[0].item1;
    final yDifference = _coordinates[3].item2 - _coordinates[0].item2;
    return math.sqrt(xDifference * xDifference + yDifference * yDifference);
  }

  bool setAngleInDegrees(double angle) {
    final set = _setAngle(angle);
    if (set == null) {
      return false;
    }
    _coordinates = set;
    _currAngle = _getAngleBetweenCoords(_coordinates[0], _coordinates[1]);
    notifyListeners();
    return true;
  }

  bool attemptSetAngleInDegrees(double angle) {
    // final normalizedAngle = angle % 360;
    // print(
    //     "== newSpaceNotifer: ATTEMPT set angel in degrees to $normalizedAngle from $angle");
    final attempt = _setAngle(angle);
    if (attempt == null) {
      return false;
    }
    return true;
  }

  bool attemptSetAngleRadians(double angle) {
    // print("== newSpaceNotifer: attempt set angle in radians to $angle");
    return attemptSetAngleInDegrees(_radiansToDegrees(angle));
  }

  bool setAngleInRadians(double angle) {
    // print("== newSpaceNotifer: set angle in radians to $angle");
    return setAngleInDegrees(_radiansToDegrees(angle));
  }

  //V
  List<Tuple2<double, double>>? _setAngle(double angle) {
    // print("== newSpaceNotifer: set angle with $angle");
    final normalizedAngle = (angle + 90) % 360;
    final pivot = _coordinates[0];
    final newCoords = [pivot];

    final angleOfCurrentSpace = _getAngleBetweenCoords(pivot, _coordinates[1]);
    if (angleOfCurrentSpace > normalizedAngle - 0.00001 &&
        angleOfCurrentSpace < normalizedAngle + 0.00001) {
      // print("angle is the same: $angleOfCurrentSpace == $normalizedAngle");
      return null;
    }

    // print("\n -- \n");

    for (var i = 1; i < _coordinates.length; i++) {
      final coord = _coordinates[i];
      // print("about to rotate $coord along $pivot");
      final newAngle = normalizedAngle - angleOfCurrentSpace;
      // print("which means this new angle should be $newAngle");

      final newCoord = _rotateAlongPivot(
        newAngle,
        pivot,
        coord,
      );
      // print("resulting in $newCoord");

      if (!_isWithinBounds(newCoord)) {
        return null;
      }
      newCoords.add(newCoord);
    }
    return newCoords;
  }

  double getAngleDegrees() {
    return (_currAngle - 90) % 360;
  }

  bool isValid(Floors floor, List<Workspace> workspaces) {
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

    for (var coord in _coordinates) {
      if (!outterWalls.contains(Offset(coord.item1, coord.item2))) {
        // print("not within outter walls");
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
          // print("on top of inner walls");
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
        for (var otherWorkspace in workspaces) {
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
        _getAngleBetweenCoords(_coordinates[0], _getCenter());
    final firstNewCoord =
        _rotateOffset(_coordinates[0], firstPaddingAngle, padding);
    newSpaceWoPadding.moveTo(firstNewCoord.item1, firstNewCoord.item2);

    for (var i = 1; i < _coordinates.length; i++) {
      final paddingAngle =
          _getAngleBetweenCoords(_coordinates[i], _getCenter());
      final newCoord = _rotateOffset(_coordinates[i], paddingAngle, padding);
      newSpaceWoPadding.lineTo(newCoord.item1, newCoord.item2);
    }
    newSpaceWoPadding.lineTo(firstNewCoord.item1, firstNewCoord.item2);
    return newSpaceWoPadding;
  }

  double _getAngleBetweenCoords(
      Tuple2<double, double> from, Tuple2<double, double> to) {
    double xDifference = to.item1 - from.item1;
    double yDifference = from.item2 - to.item2;

    double radians = math.atan2(xDifference, yDifference);
    double degrees = _radiansToDegrees(radians) % 360;
    return degrees;
  }

  Tuple2<double, double> _getCenter() {
    var sumX = 0.0;
    var sumY = 0.0;

    for (var coord in _coordinates) {
      sumX += coord.item1;
      sumY += coord.item2;
    }

    return Tuple2(sumX / _coordinates.length, sumY / _coordinates.length);
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
  Tuple2<double, double> _rotateAlongPivot(double angle,
      Tuple2<double, double> pivot, Tuple2<double, double> coordToRotate) {
    // print("== newSpaceNotifer: rotate along pivot");

    final angleInRadians = _degreesToRadians(angle);

    // Translate to pivot point
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
      Tuple2<double, double> coord, double angle, double offset) {
    late final double newX;
    late final double newY;

    final normalizedAngle = angle % 360;

    print("rotateOffset angle: $normalizedAngle");

    // light calculation for 90 degree angles
    if (normalizedAngle > 90 - 0.0000000000001 &&
        normalizedAngle < 90 + 0.0000000000001) {
      print("light calculation at normalizedAngle: $normalizedAngle");
      newX = coord.item1 + offset;
      newY = coord.item2;
    } else if (normalizedAngle > 180 - 0.0000000000001 &&
        normalizedAngle < 180 + 0.0000000000001) {
      print("light calculation at normalizedAngle: $normalizedAngle");
      newX = coord.item1;
      newY = coord.item2 + offset;
    } else if (normalizedAngle > 270 - 0.0000000000001 &&
        normalizedAngle < 270 + 0.0000000000001) {
      print("light calculation at normalizedAngle: $normalizedAngle");
      newX = coord.item1 - offset;
      newY = coord.item2;
    } else if (normalizedAngle > -0.0000000000001 &&
        normalizedAngle < 0.0000000000001) {
      print("light calculation at normalizedAngle: $normalizedAngle");
      newX = coord.item1;
      newY = coord.item2 - offset;
    }
    // more complex calculation for more complex normalizedAngles
    else if (normalizedAngle > 0 && normalizedAngle < 90) {
      print("complex calculation with normalizedAngle between 0-90");
      newX =
          coord.item1 + math.sin(_degreesToRadians(normalizedAngle)) * offset;
      newY =
          coord.item2 - math.cos(_degreesToRadians(normalizedAngle)) * offset;
    } else if (normalizedAngle > 90 && normalizedAngle < 180) {
      print("complex calculation with normalizedAngle between 90-180");
      newX = coord.item1 +
          math.cos(_degreesToRadians(normalizedAngle - 90)) * offset;
      newY = coord.item2 +
          math.sin(_degreesToRadians(normalizedAngle - 90)) * offset;
    } else if (normalizedAngle > 180 && normalizedAngle < 270) {
      print("complex calculation with normalizedAngle between 180-270");
      newX = coord.item1 -
          math.sin(_degreesToRadians(normalizedAngle - 180)) * offset;
      newY = coord.item2 +
          math.cos(_degreesToRadians(normalizedAngle - 180)) * offset;
    } else {
      print("complex calculation with normalizedAngle between 270-360");
      newX = coord.item1 -
          math.cos(_degreesToRadians(normalizedAngle - 270)) * offset;
      newY = coord.item2 -
          math.sin(_degreesToRadians(normalizedAngle - 270)) * offset;
    }

    return Tuple2(newX, newY);
  }

  void _printCoords(String title) {
    print(" ");
    print(" ------- Coords: $title ----------");
    for (var i = 0; i < _coordinates.length; i++) {
      print("$i: (${_coordinates[i].item1}, ${_coordinates[i].item2})");
    }
    print("current angle: $_currAngle");
    print(" --------------- $title -----------");
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  double _radiansToDegrees(double radians) {
    return radians * 180 / math.pi;
  }
}
