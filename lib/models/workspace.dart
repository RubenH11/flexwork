import 'package:flexwork/database/firebaseService.dart';
import "package:flexwork/models/reservation.dart";
import "package:tuple/tuple.dart";
import "package:flutter/material.dart";
import "./floors.dart";

class Workspace extends ChangeNotifier {
  String _id;
  final Floors _floor;
  List<Tuple2<double, double>> _coordinates;
  String _identifier;
  String _nickname;
  String _type;
  int _numMonitors;
  int _numWhiteboards;
  int _numScreens;
  List<Tuple2<DateTime, DateTime>> _blockedMoments;
  Color _color;


  Workspace({
    required String id,
    required Floors floor,
    List<Tuple2<double, double>> coordinates = const [
      Tuple2(0.0, 0.0),
      Tuple2(12.0, 0.0),
      Tuple2(12.0, 18.0),
      Tuple2(0.0, 18.0),
    ],
    String identifier = "",
    String nickname = "",
    String type = "Office",
    int numMonitors = 0,
    int numWhiteboards = 0,
    int numScreens = 0,
    List<Tuple2<DateTime, DateTime>> blockedMoments = const [],
    List<Tuple2<DateTime, DateTime>> possibleConflicts = const [],
    required Color color,
  })  : _id = id,
        _coordinates = coordinates,
        _floor = floor,
        _identifier = identifier,
        _nickname = nickname,
        _numMonitors = numMonitors,
        _numScreens = numScreens,
        _numWhiteboards = numWhiteboards,
        _type = type,
        _color = color,
        _blockedMoments = blockedMoments;

  Workspace.fromWorkspace({required Workspace workspace})
      : _id = workspace.getId(),
        _coordinates = workspace.getCoords(),
        _floor = workspace.getFloor(),
        _identifier = workspace.getIdentifier(),
        _nickname = workspace.getNickname(),
        _numMonitors = workspace.getNumMonitors(),
        _numScreens = workspace.getNumScreens(),
        _numWhiteboards = workspace.getNumWhiteboards(),
        _type = workspace.getType(),
        _color = workspace.getColor(),
        _blockedMoments = workspace.getBlockedMoments();

  bool hasDifferentBasics(Workspace other) {
    return (_floor != other.getFloor() ||
        _identifier != other.getIdentifier() ||
        _nickname != other.getNickname() ||
        _numMonitors != other.getNumMonitors() ||
        _numScreens != other.getNumScreens() ||
        _numWhiteboards != other.getNumWhiteboards() ||
        _type != other.getType());
  }

  bool hasDifferentCoordinates(Workspace workspace) {
    if (_coordinates.length != workspace.getCoords().length) {
      return true;
    }
    final coords = workspace.getCoords();
    for (var i = 0; i < _coordinates.length; i++) {
      if (_coordinates[i] != coords[i]) {
        return true;
      }
    }
    return false;
  }

  bool hasDifferentBlockedMoments(Workspace workspace) {
    if (_blockedMoments.length != workspace.getBlockedMoments().length) {
      return true;
    }
    final blockedMoments = workspace.getCoords();
    for (var i = 0; i < _blockedMoments.length; i++) {
      if (_blockedMoments[i] != blockedMoments[i]) {
        return true;
      }
    }
    return false;
  }

  @override
  String toString() {
    var string = "ID $_id, Floor $_floor, named '$_identifier': ";
    for (final coord in _coordinates) {
      string = "$string $coord,";
    }
    return string;
  }

  List<Tuple2<double, double>> getCoords() {
    return [..._coordinates];
  }

  Floors getFloor() {
    return _floor;
  }

  String getIdentifier() {
    return _identifier;
  }

  String getNickname() {
    return _nickname;
  }

  int getNumMonitors() {
    return _numMonitors;
  }

  int getNumWhiteboards() {
    return _numWhiteboards;
  }

  int getNumScreens() {
    return _numScreens;
  }

  String getType() {
    return _type;
  }

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
      path.lineTo(_coordinates[i].item1, _coordinates[i].item2);
    }
    // complete path
    path.lineTo(_coordinates[0].item1, _coordinates[0].item2);
    return path;
  }

  String getId() {
    return _id;
  }

  Color getColor(){
    return _color;
  }

  List<Tuple2<DateTime, DateTime>> getBlockedMoments() {
    return [..._blockedMoments];
  }

  void addBlockedMoment(Tuple2<DateTime, DateTime> blockedMoment) {
    _blockedMoments.add(blockedMoment);
  }

  void deleteBlockedMoment(int index) {
    _blockedMoments.removeAt(index);
  }

  void setId(String id) {
    _id = id;
  }

  void setColor(Color color){
    _color = color;
  }

  void setIdentifier(String identifier) {
    _identifier = identifier;
  }

  void setNickname(String nickname) {
    _nickname = nickname;
  }

  void setNumMonitors(int numMonitors) {
    _numMonitors = numMonitors;
  }

  void setNumWhiteboards(int numWhiteboards) {
    _numWhiteboards = numWhiteboards;
  }

  void setNumScreens(int numScreens) {
    _numScreens = numScreens;
  }

  void setType(String type) {
    _type = type;
  }
}
