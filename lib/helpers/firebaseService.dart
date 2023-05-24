import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/newReservationNotifier.dart";
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
  Future<String> addReservation(NewReservationNotifier newRes) async {
   // final workspaceId = newRes.getWorkspace().getId();

    var docRef = await firestore.collection("reservations").add({

    });
    return docRef.id;
  }

  // Workspaces
  List<Workspace> _workspaces = [];

  List<Workspace> getWorkspaces(Floors floor) {
    final workspacesOnFloor = _workspaces
        .where((workspace) => workspace.getFloor() == floor)
        .toList();
    return workspacesOnFloor;
  }

  Future<String?> addNewWorkspaceToDB(NewSpaceNotifier workspace) {
    return _lock.synchronized(() => _addNewWorkspaceToDB(workspace));
  }

  Future<String?> _addNewWorkspaceToDB(NewSpaceNotifier workspace) async {
    try {
      // print("== add New Workspace To DB");

      final floor = workspace.getFloor();
      final identifier = workspace.getIdentifier();
      final nickname = workspace.getNickname();
      final numMonitors = workspace.getNumMonitors();
      final numWhiteboards = workspace.getNumWhiteboards();
      final numScreens = workspace.getNumScreens();
      final coords = workspace.getCoords();
      final blockedMoments = workspace.getBlockedMoments();
      final type = workspace.getType();

      var docRef = await firestore.collection("workspaces").add({
        "floor": floor.name.substring(1),
        "identifier": identifier,
        "nickname": nickname,
        "numMonitors": numMonitors,
        "numWhiteboards": numWhiteboards,
        "numScreens": numScreens,
        "type": type,
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
      for (var i = 0; i < blockedMoments.length; i++) {
        await firestore
            .collection("workspaces")
            .doc(docRef.id)
            .collection("blockedMoments")
            .doc(i.toString())
            .set({
          "start": blockedMoments[i].item1.toIso8601String(),
          "end": blockedMoments[i].item2.toIso8601String(),
        });
      }
      // add to current state
      _workspaces.add(Workspace(
        id: docRef.id,
        coordinates: coords,
        floor: floor,
        identifier: identifier,
        nickname: nickname,
        numMonitors: numMonitors,
        numScreens: numScreens,
        numWhiteboards: numWhiteboards,
        type: type,
        blockedMoments: blockedMoments,
      ));
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

  Future<List<Workspace>?> getAllWorkspacesFromDB() {
    return _lock.synchronized(() => _getAllWorkspacesFromDB());
  }

  Future<List<Workspace>?> _getAllWorkspacesFromDB() async {
    try {
      // print("cannot execute getting all spaces yet");

      final List<Workspace> workspaces = [];

      final docsSnapshot = await firestore.collection("workspaces").get();
      final docs = docsSnapshot.docs;

      for (var doc in docs) {
        final identifier = doc["identifier"];
        final nickname = doc["nickname"];
        final numMonitors = doc["numMonitors"];
        final numWhiteboards = doc["numWhiteboards"];
        final numScreens = doc["numScreens"];
        final type = doc["type"];
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

        List<Tuple2<double, double>> coords = [];
        for (var coordDoc in coordsSnapshot.docs) {
          coords.add(Tuple2(coordDoc.data()["x"], coordDoc.data()["y"]));
        }

        final blockedMomentsSnapshot = await firestore
            .collection("workspaces")
            .doc(doc.id)
            .collection("blockedMoments")
            .get();

        List<Tuple2<DateTime, DateTime>> blockedMoments = [];
        for (var blockedMomentDoc in blockedMomentsSnapshot.docs) {
          print("trying to add ${blockedMomentDoc.id}");
          blockedMoments.add(
            Tuple2(
              // DateTime.parse(blockedMomentDoc.data()["start"]),
              // DateTime.parse(blockedMomentDoc.data()["end"]),
              DateTime.now(),
              DateTime.now(),
            ),
          );
        }

        workspaces.add(Workspace(
          id: doc.id,
          coordinates: coords,
          floor: floor,
          identifier: identifier,
          nickname: nickname,
          numMonitors: numMonitors,
          numScreens: numScreens,
          numWhiteboards: numWhiteboards,
          type: type,
          blockedMoments: blockedMoments,
        ));
      }

      // print("add $workspaces in getAllWorkspacesFromDB");
      _workspaces = workspaces;
      return _workspaces;
    } catch (error) {
      print("ERROR in getAllWorkspaces: $error");
    }
    return null;
  }

  Future<void> updateWorkspace(Workspace workspace) async {
    try {
      final updateMap = {
        "floor": workspace.getFloor().name.substring(1),
        "identifier": workspace.getIdentifier(),
        "nickname": workspace.getNickname(),
        "numMonitors": workspace.getNumMonitors(),
        "numWhiteboards": workspace.getNumWhiteboards(),
        "numScreens": workspace.getNumScreens(),
        "type": workspace.getType(),
      };
      firestore
          .collection("workspaces")
          .doc(workspace.getId())
          .update(updateMap);

      final coords = workspace.getCoords();
      for (var i = 0; i < coords.length; i++) {
        await firestore
            .collection("workspaces")
            .doc(workspace.getId())
            .collection("coordinates")
            .doc(i.toString())
            .set({
          "x": coords[i].item1,
          "y": coords[i].item2,
        });
      }

      final blockedMoments = workspace.getBlockedMoments();
      for (var i = 0; i < blockedMoments.length; i++) {
        await firestore
            .collection("workspaces")
            .doc(workspace.getId())
            .collection("blockedMoments")
            .doc(i.toString())
            .set({
          "start": blockedMoments[i].item1,
          "end": blockedMoments[i].item2
        });
      }
      print("end of update");
    } catch (error) {
      print("ERROR in updateWorkspace: $error");
    }
  }

  Future<void> deleteWorkspace(Workspace workspace) async {
    try {
      assert(workspace.getId() != null);
      firestore.collection("workspaces").doc(workspace.getId()).delete();
    } catch (error) {
      print("ERROR: $error");
    }
  }

  void printWorkspaces() {
    for (var workspace in _workspaces) {
      print(workspace.toString());
    }
  }
}
