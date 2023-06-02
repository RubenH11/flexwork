import 'package:flexwork/database/firebaseService.dart';
import 'package:flutter/material.dart';

class WorkspaceTypesRepo{
  // typeColors
  Map<String, Color> _typeColors = {};

  WorkspaceTypesRepo(this._typeColors);

  Color getColor(String type) {
    // assert(_typeColors.containsKey(type));
    // print(_typeColors);
    if (_typeColors.containsKey(type)) {
      return _typeColors[type]!;
    }
    return Colors.black;
  }

  void setColor(String type, Color color) async {
    try {
      await FirebaseService().firestore.collection("workspaceTypes").doc(type).set({
        "red": color.red,
        "green": color.green,
        "blue": color.blue,
      });
    } catch (error) {
      print("ERROR: $error");
    }
  }

  Map<String, Color> getColors() {
    return _typeColors;
  }

  Future<void> delete(String type) async {
    _typeColors.remove(type);
    await FirebaseService().firestore.collection("workspaceTypes").doc(type).delete();
  }
}