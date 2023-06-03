import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:flexwork/database/requestsRepo.dart";
import "package:flexwork/database/reservationsRepo.dart";
import 'package:flexwork/database/employeesRepo.dart';
import "package:flexwork/database/workspaceTypesRepo.dart";
import "package:flexwork/database/workspacesRepo.dart";
import "package:flexwork/helpers/dateTimeHelper.dart";
import "package:flexwork/models/floors.dart";
import "package:flexwork/models/newReservationNotifier.dart";
import "package:flexwork/models/newSpaceNotifier.dart";
import "package:flexwork/models/request.dart";
import "package:flexwork/models/reservation.dart";
import 'package:flexwork/models/employee.dart';
import "package:flutter/foundation.dart";
import "package:intl/intl.dart";
import '../models/workspace.dart';
import "package:firebase_core/firebase_core.dart";
import "package:tuple/tuple.dart";
import "package:synchronized/synchronized.dart";
import '../helpers/dateTimeHelper.dart';
import "package:flutter/material.dart";

//test

class FirebaseService {
  // Singleton Pattern
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  // FirebaseService
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final lock = Lock();
  RequestsRepo? _requests;
  WorkspacesRepo? _workspaces;
  WorkspaceTypesRepo? _workspaceTypes;
  ReservationsRepo? _reservations;
  EmployeesRepo? _employees;

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

  Stream<List<Workspace>> getWorkspacesStream() {
    assert(workspaceTypes != null);

    final snapshots = firestore.collection("workspaces").snapshots();
    final stream = snapshots.map(
      (e) => e.docs.map(
        (doc) {
          final id = doc.id;
          final floorNum = doc.data()["floor"] as int;
          final identifier = doc.data()["identifier"] as String;
          final nickname = doc.data()["nickname"] as String;
          final numMonitors = doc.data()["numMonitors"] as int;
          final numScreens = doc.data()["numScreens"] as int;
          final numWhiteboards = doc.data()["numWhiteboards"] as int;
          final type = doc.data()["type"] as String;
          final blockedMomentsMaps =
              (doc.data()["blockedMoments"] as List<dynamic>)
                  .cast<Map<String, dynamic>>()
                  .map((dynamic item) => item.cast<String, String>())
                  .toList();

          final blockedMoments = blockedMomentsMaps
              .map((moment) => Tuple2(DateTime.parse(moment["start"]),
                  DateTime.parse(moment["end"])))
              .toList();

          final coordinatesMaps = (doc.data()["coordinates"] as List<dynamic>)
              .cast<Map<String, dynamic>>()
              .map((dynamic item) => item.cast<String, double>())
              .toList();

          final coordinates = coordinatesMaps
              .map((coord) =>
                  Tuple2(coord["x"]! as double, coord["y"]! as double))
              .toList();

          late final Floors floor;
          switch (floorNum) {
            case 9:
              floor = Floors.f9;
              break;
            case 10:
              floor = Floors.f10;
              break;
            case 11:
              floor = Floors.f11;
              break;
            case 12:
              floor = Floors.f12;
              break;
            default:
              print(
                  "ERROR: getAllSpacesStreamFromDB() recieved an invalid floor number");
          }

          final workspace = Workspace(
            id: id,
            floor: floor,
            blockedMoments: blockedMoments,
            identifier: identifier,
            nickname: nickname,
            numMonitors: numMonitors,
            numScreens: numScreens,
            numWhiteboards: numWhiteboards,
            type: type,
            coordinates: coordinates,
            color: FirebaseService().workspaceTypes.getColor(type),
          );

          return workspace;
        },
      ).toList(),
    );
    return stream;
  }

  Stream<List<Reservation>> getReservationsStream() {
    final snapshots = firestore.collection("reservations").snapshots();

    return snapshots.map(
      (e) => e.docs.map(
        (doc) {
          final uid = doc.data()["userId"] as String;
          final start = doc.data()["start"] as String;
          final end = doc.data()["end"] as String;

          return Reservation(
            doc.id,
            uid,
            DateTime.parse(start),
            DateTime.parse(end),
            doc.data()["workspaceId"],
          );
        },
      ).toList(),
    );
  }

  Stream<List<Employee>> getEmployeesStream() {
    final snapshots = firestore.collection("users").snapshots();

    return snapshots.map(
      (e) => e.docs.map(
        (doc) {
          final uid = doc.id;
          final email = doc.data()["email"] as String;
          final type = doc.data()["role"] as String;

          return Employee(
            uid,
            email,
            type,
          );
        },
      ).toList(),
    );
  }

  Stream<Map<String, Color>> getWorkspaceTypesStream() {
    final snapshots = firestore.collection("workspaceTypes").snapshots();

    return snapshots.map((e) => e.docs.map(
          (doc) {
            final red = doc.data()["red"] as int;
            final green = doc.data()["green"] as int;
            final blue = doc.data()["blue"] as int;
            final type = doc.id;
            return {type: Color.fromRGBO(red, green, blue, 1)};
          },
        ).fold<Map<String, Color>>(
            {}, (previous, element) => {...previous, ...element}));
  }

  Stream<List<Request>> getRequestsStream() {
    final snapshots = firestore.collection("requests").snapshots();

    return snapshots.map(
      (e) => e.docs.map(
        (doc) {
          final uid = doc.data()["userId"] as String;
          final reservationId = doc.data()["reservationId"] as String;
          final message = doc.data()["message"] as String;
          final start = doc.data()["start"] as String;
          final end = doc.data()["end"] as String;

          return Request(
            id: doc.id,
            userId: uid,
            reservationId: reservationId,
            message: message,
            start: DateTime.parse(start),
            end: DateTime.parse(end),
          );
        },
      ).toList(),
    );
  }

  Future<String> getUserRoleFromDB(String uid) async {
    final doc = await FirebaseService().firestore.collection("users").doc(uid).get();
    return doc.data()!["role"];
  }

  // Stream<List<Workspace>> getLimitedStream() {
  //   final snapshots =
  //       firestore.collection("workspaces").snapshots();

  //   return snapshots.map(
  //     (e) => e.docs.map(
  //       (doc) {
  //         final id = doc.id;
  //         final floorNum = doc.data()["floor"] as int;
  //         final identifier = doc.data()["identifier"] as String;
  //         final nickname = doc.data()["nickname"] as String;
  //         final numMonitors = doc.data()["numMonitors"] as int;
  //         final numScreens = doc.data()["numScreens"] as int;
  //         final numWhiteboards = doc.data()["numWhiteboards"] as int;
  //         final type = doc.data()["type"] as String;
  //         final coordinatesMaps = (doc.data()["coordinates"] as List<dynamic>)
  //             .cast<Map<String, dynamic>>()
  //             .map((dynamic item) => item.cast<String, double>())
  //             .toList();

  //         final coordinates = coordinatesMaps
  //             .map((coord) =>
  //                 Tuple2(coord["x"]! as double, coord["y"]! as double))
  //             .toList();

  //         late final Floors floor;
  //         switch (floorNum) {
  //           case 9:
  //             floor = Floors.f9;
  //             break;
  //           case 10:
  //             floor = Floors.f10;
  //             break;
  //           case 11:
  //             floor = Floors.f11;
  //             break;
  //           case 12:
  //             floor = Floors.f12;
  //             break;
  //           default:
  //             print(
  //                 "ERROR: getAllSpacesStreamFromDB() recieved an invalid floor number");
  //         }

  //         // print("forming workspace with type: $type with _typeColors is ${_typeColors.length} long");

  //         return Workspace(
  //           id: id,
  //           floor: floor,
  //           identifier: identifier,
  //           nickname: nickname,
  //           numMonitors: numMonitors,
  //           numScreens: numScreens,
  //           numWhiteboards: numWhiteboards,
  //           type: type,
  //           coordinates: coordinates,
  //           color: FirebaseService().workspaceTypes.getColor(type),
  //         );
  //       },
  //     ).toList(),
  //   );
  // }

  // Stream<List<Reservation>> getFilteredStream(
  //     {required String uid}) {
  //   // print("getting stream for filtered reservations");
  //   final snapshots = FirebaseService()
  //       .firestore
  //       .collection("reservations")
  //       .where("userId", isEqualTo: uid)
  //       .snapshots();

  //   return snapshots.map(
  //     (e) => e.docs.map(
  //       (doc) {
  //         final startTimestamp = doc.data()["start"] as Timestamp;
  //         final endTimestamp = doc.data()["end"] as Timestamp;

  //         return Reservation(
  //           uid,
  //           DateTime.fromMillisecondsSinceEpoch(
  //               startTimestamp.millisecondsSinceEpoch), //FIX
  //           DateTime.fromMillisecondsSinceEpoch(
  //               endTimestamp.millisecondsSinceEpoch),
  //           doc.data()["workspaceId"],
  //         );
  //       },
  //     ).toList(),
  //   );
  // }

  void buildEmployeesReop(List<Employee> employees){
    _employees = EmployeesRepo(employees);
  }

  void buildWorkspacesRepo(List<Workspace> workspaces) {
    _workspaces = WorkspacesRepo(workspaces);
  }

  void buildReservationsRepo(List<Reservation> reservations) {
    _reservations = ReservationsRepo(reservations);
  }

  void buildWorkspaceTypesRepo(Map<String, Color> workspaceTypes) {
    _workspaceTypes = WorkspaceTypesRepo(workspaceTypes);
  }

  void buildRequestsRepo(List<Request> requests) {
    _requests = RequestsRepo(requests);
  }

  EmployeesRepo get employees{
    assert(_employees != null);
    return _employees!;
  }

  WorkspacesRepo get workspaces {
    assert(_workspaces != null);
    return _workspaces!;
  }

  WorkspaceTypesRepo get workspaceTypes {
    assert(_workspaceTypes != null);
    return _workspaceTypes!;
  }

  ReservationsRepo get reservations {
    assert(_reservations != null);
    return _reservations!;
  }

  RequestsRepo get requests {
    assert(_requests != null);
    return _requests!;
  }
}
