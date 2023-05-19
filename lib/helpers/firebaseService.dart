import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/newSpaceNotifier.dart";
import "package:flutter/foundation.dart";
import "../models/workspace.dart";
import "package:firebase_core/firebase_core.dart";
import "package:tuple/tuple.dart";
import "package:synchronized/synchronized.dart";

// FirebaseService communicates with Firebase and maganages the app state, as they should always be in sync
class FirebaseService {
  // Singleton Pattern
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  // FirebaseService
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _lock = Lock();

  static Future<FirebaseApp> initializeApp() async {
    final firebaseApp = await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBK9xQzpEgGfGxljk6L7oq1OUDQ10w7Kd0",
        appId: "1:598691515878:web:f30e1a8f34a75d16d45a27",
        messagingSenderId: "598691515878",
        projectId: "nu-flex-app",
        storageBucket: "nu-flex-app.appspot.com",
      ),
    );

    return firebaseApp;
  }

  // Reservations
  Future<String> addReservation(
      DateTime startDateTime, DateTime endDateTime, String roomNumber) async {
    var docRef = await firestore.collection("reservations").add({
      "start": startDateTime,
      "end": endDateTime,
      "room_number": roomNumber
    });
    return docRef.id;
  }

  // Workspaces
  List<Workspace> _workspaces = [];

  List<Workspace> getWorkspaces() {
    return [..._workspaces];
  }

  Future<String?> addNewWorkspaceToDB(
      String identifier, NewSpaceNotifier workspace) {
    return _lock
        .synchronized(() => _addNewWorkspaceToDB(identifier, workspace));
  }

  Future<String?> _addNewWorkspaceToDB(
      String identifier, NewSpaceNotifier workspace) async {
    try {
      // print("== add New Workspace To DB");

      final coords = workspace.getCoords();
      final floor = workspace.getFloor();
      var docRef = await firestore.collection("workspaces").add({
        "identifier": identifier,
        "floor": floor.name.substring(1),
      });
      for (var i = 0; i < coords.length; i++) {
        await firestore
            .collection("workspaces")
            .doc(docRef.id)
            .collection("coordinates")
            .doc(i.toString())
            .set({
          "x": coords[i].item1,
          "y": coords[i].item2,
        });
      }
      // add to current state
      _workspaces.add(Workspace(coords, identifier, floor));
      // print("== END: add New Workspace To DB");
      return docRef.id;
    } catch (error) {
      print("ERROR in addSpace: $error");
    }
    return null;
  }

  Stream<QuerySnapshot> getAllSpacesStreamFromDB() {
    //print(firestore.collection("workspaces").id);
    return firestore.collection("workspaces").snapshots();
  }

  Future<List<Workspace>?> getAllWorkspacesFromDB(
      List<QueryDocumentSnapshot<Object?>> docs) {
    return _lock.synchronized(() => _getAllWorkspacesFromDB(docs));
  }

  Future<List<Workspace>?> _getAllWorkspacesFromDB(
      List<QueryDocumentSnapshot<Object?>> docs) async {
    try {
      print("cannot execute getting all spaces yet");

      final List<Workspace> workspaces = [];

      for (var doc in docs) {
        final identifier = doc["identifier"];
        late final Floors floor;
        switch (doc["floor"]) {
          case "9":
            floor = Floors.f9;
            break;
          case "10":
            floor = Floors.f10;
            break;
          case "11":
            floor = Floors.f11;
            break;
          case "12":
            floor = Floors.f12;
            break;
          default:
            throw ErrorDescription(
                "recieved invalid value for Floors from database");
        }

        final coordsSnapshot = await firestore
            .collection("workspaces")
            .doc(doc.id)
            .collection("coordinates")
            .get();

        print("snapshot docs: ${coordsSnapshot.docs.length} from ${doc.id}");
        List<Tuple2<double, double>> coords = [];
        for (var coordDoc in coordsSnapshot.docs) {
          coords.add(Tuple2(coordDoc.data()["x"], coordDoc.data()["y"]));
          print("just added ${coords.last} to coords");
        }
        workspaces.add(Workspace(coords, identifier, floor));
      }

      // print("add $workspaces in getAllWorkspacesFromDB");
      _workspaces = workspaces;
      return _workspaces;
    } catch (error) {
      print("ERROR in getAllWorkspaces: $error");
    }
    return null;
  }

  void printWorkspaces() {
    for (var workspace in _workspaces) {
      print(workspace.toString());
    }
  }
}
