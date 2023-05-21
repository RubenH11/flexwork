import "package:tuple/tuple.dart";
import "package:flutter/material.dart";
import "./floors.dart";

class Workspace {
  final Floors _floor;
  List<Tuple2<double, double>> _coordinates;
  String _identifier;
  String _nickname;
  String _type;
  int _numMonitors;
  int _numWhiteboards;
  int _numScreens;

  Workspace(
    this._coordinates,
    this._floor,
    this._identifier,
    this._nickname,
    this._numMonitors,
    this._numScreens,
    this._numWhiteboards,
    this._type,
  );

  @override
  String toString() {
    var string = "Floor $_floor, named '$_identifier': ";
    for (final coord in _coordinates) {
      string = "$string $coord,";
    }
    return string;
  }

  void addCoordinateFromLast(){
    final numCoords = _coordinates.length;
    _coordinates.add(_coordinates[numCoords-1]);
  }

  void deleteCoordinate(int numOfCoord){
    _coordinates.removeAt(numOfCoord);
  }

  List<Tuple2<double, double>> getCoords(){
    return [..._coordinates];
  }

  Floors getFloor(){
    return _floor;
  }

  String getIdentifier(){
    return _identifier;
  }

  String getNickname(){
    return _nickname;
  }

  int getNumMonitors(){
    return _numMonitors;
  }

  int getNumWhiteboards(){
    return _numWhiteboards;
  }

  int getNumScreens(){
    return _numScreens;
  }

  String getType(){
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

  void setCoords(List<Tuple2<double, double>> newCoords){
    _coordinates = newCoords;
  }

  void setOneCoord({required int numOfCoord, required Tuple2<double, double> coord}){
    _coordinates[numOfCoord] = coord;
  }

  void setIdentifier(String identifier){
    _identifier = identifier;
  }

  void setNickname(String nickname){
    _nickname = nickname;
  }

  void setNumMonitors(int numMonitors){
    _numMonitors = numMonitors;
  }

  void setNumWhiteboards(int numWhiteboards){
    _numWhiteboards = numWhiteboards;
  }

  void setNumScreens(int numScreens){
    _numScreens = numScreens;
  }

  void setType(String type){
    _type = type;
  }

}
