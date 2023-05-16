import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flexwork/models/newSpaceNotifier.dart";
import "../models/workspace.dart";

class FirebaseService {
  // Singleton Pattern
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  // FirebaseService
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Workspace> workspaces = [];

  Future<String> addReservation(
      DateTime startDateTime, DateTime endDateTime, String roomNumber) async {
    var docRef = await firestore.collection("reservations").add({
      "start": startDateTime,
      "end": endDateTime,
      "room_number": roomNumber
    });
    return docRef.id;
  }

  Future<String> addSpace(String identifier, NewSpaceNotifier space) async {
    var docRef = await firestore.collection("workspaces").add({
      "identifier": identifier,
      "coordinates": space.toString(),
    });

    //workspaces.add(Workspace(space, title))

    return docRef.id;
  }

  void _fromNewSpaceToCoords(NewSpaceNotifier newSpaceNotifier) {
    //TODO
  }

  void _fromCoordsToSpace(List<double> coords) {
    //TODO
  }
}
