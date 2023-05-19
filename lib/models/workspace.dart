import "package:tuple/tuple.dart";
import "package:flutter/material.dart";
import "./floors.dart";

class Workspace {
  final Floors _floor;
  List<Tuple2<double, double>> _coordinates;
  String _identifier;

  Workspace(
    this._coordinates,
    this._identifier,
    this._floor,
  );

  @override
  String toString() {
    var string = "Floor $_floor, named '$_identifier': ";
    for (final coord in _coordinates) {
      string = "$string $coord,";
    }
    return string;
  }

  List<Tuple2<double, double>> getCoords(){
    return [..._coordinates];
  }

  void setCoords(List<Tuple2<double, double>> newCoords){
    _coordinates = newCoords;
  }

  void setOneCoord({required int numOfCoord, required Tuple2<double, double> coord}){
    _coordinates[numOfCoord] = coord;
  }

  void addCoordinateFromLast(){
    final numCoords = _coordinates.length;
    _coordinates.add(_coordinates[numCoords-1]);
  }

  void deleteCoordinate(int numOfCoord){
    _coordinates.removeAt(numOfCoord);
  }

  Floors getFloor(){
    return _floor;
  }

  String getIdentifier(){
    return _identifier;
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
}
