import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexwork/database/firebaseService.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/models/reservation.dart';
import 'package:flexwork/models/reservationConflict.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class ReservationsRepo {
  // Reservations
  List<Reservation> _reservations = [];

  ReservationsRepo(this._reservations);

  final collection = FirebaseService().firestore.collection("reservations");

  List<Reservation> get({Workspace? workspace, DateTime? date, String? uid}) {
    var reservations = [..._reservations];
    // print("getting reservations based on all three? ${workspace != null}, ${date != null}, ${uid != null}");

    if (uid != null) {
      reservations =
          reservations.where((res) => res.getUserId() == uid).toList();
      // print("filtered by uid: $reservations");
    }

    if (workspace != null) {
      reservations = reservations
          .where((res) => res.getWorkspaceId() == workspace.getId())
          .toList();
      // print("filtered by workspace: $reservations");
    }
    if (date != null) {
      reservations = reservations.where((res) {
        final comparisonDay = DateTimeHelper.extractOnlyDay(date);
        return DateTimeHelper.dateRangesOverlap(
            Tuple2(res.getStart(), res.getEnd()),
            Tuple2(comparisonDay, comparisonDay.add(const Duration(days: 1))));
      }).toList();
      // print("filtered by date: $reservations");
    }

    return reservations;
  }

  Reservation getById(String id) {
    return _reservations.firstWhere((res) => res.getId() == id);
  }

  // void set(List<Reservation> reservations) {
  //   _reservations = reservations;
  // }

  List<String> getConflictWorkspaceIds(NewReservationNotifier newResNotif) {
    // print("Getting conflicts");
    final start = newResNotif.getStartTime();
    final end = newResNotif.getEndTime();

    if (start == null || end == null) {
      return [];
    }

    return _reservations
        .where((res) =>
            DateTimeHelper.dateRangesOverlap(
                Tuple2(res.getStart(), res.getEnd()), Tuple2(start, end)) &&
            res.getUserId() != FirebaseAuth.instance.currentUser!.uid)
        .map((res) => res.getWorkspaceId())
        .toList();
  }

  List<ReservationConflict> getReservationConflicts(
      NewReservationNotifier newResNotif) {
    // print("getting conflicts for $newResNotif");
    final workspace = newResNotif.getWorkspace();

    if (newResNotif.getStartTime() == null ||
        newResNotif.getEndTime() == null ||
        workspace == null) {
      return [];
    }

    final List<ReservationConflict> conflictReservations = [];

    for (final range in newResNotif.constructScheduleIncludingConflicts()) {
      conflictReservations.addAll(
        _reservations.where((res) {
          // print(res);
          return newResNotif.getWorkspace()!.getId() == res.getWorkspaceId() &&
              DateTimeHelper.dateRangesOverlap(
                Tuple2(res.getStart(), res.getEnd()),
                Tuple2(range.item1, range.item2),
              ) &&
              res.getUserId() != FirebaseAuth.instance.currentUser!.uid;
        }).map((res) {
          final sortedDateTimes = [
            range.item1,
            range.item2,
            res.getStart(),
            res.getEnd()
          ];
          sortedDateTimes.sort();
          return ReservationConflict(
            start: sortedDateTimes[1],
            end: sortedDateTimes[2],
            reservationId: res.getId(),
          );
        }).toList(),
      );
    }
    for (var conflictReservation in conflictReservations) {
      // print("${conflictReservation.getStart()} -- ${conflictReservation.getEnd()}");
    }

    return conflictReservations;
  }

  bool hasConflict(NewReservationNotifier newResNotif) {
    if (newResNotif.getStartTime() == null ||
        newResNotif.getEndTime() == null ||
        newResNotif.getWorkspace() == null) {
      return false;
    }
    for (var res in _reservations) {
      if (DateTimeHelper.dateRangesOverlap(
            Tuple2(res.getStart(), res.getEnd()),
            Tuple2(newResNotif.getStartTime()!, newResNotif.getEndTime()!),
          ) &&
          newResNotif.getWorkspace()!.getId() == res.getWorkspaceId()) {
        return true;
      }
    }
    return false;
  }

  Future<void> addReservation(Reservation reservation) async {
    collection.add({
      "userId": reservation.getUserId(),
      "workspaceId": reservation.getWorkspaceId(),
      "start": reservation.getStart().toIso8601String(),
      "end": reservation.getEnd().toIso8601String(),
    });
  }

  Future<void> add(NewReservationNotifier newRes) async {
    assert(newRes.getWorkspace() != null);
    assert(newRes.getStartTime() != null);
    assert(newRes.getEndTime() != null);

    final reservations = newRes.constructSchedule();

    final batch = FirebaseService().firestore.batch();

    final workspaceId = newRes.getWorkspace()!.getId();

    for (final reservation in reservations) {
      batch.set(collection.doc(), {
        "userId": FirebaseAuth.instance.currentUser!.uid,
        "workspaceId": workspaceId,
        "start": reservation.item1.toIso8601String(),
        "end": reservation.item2.toIso8601String(),
      });
    }
    await batch.commit().then((value) {
      print('Batch commit of new reservations was successful!');
    }).catchError((error) {
      print('Error performing Batch commit of new reservations: $error');
    });
  }

  Future<void> delete({required String workspaceId}) async {
    _reservations.removeWhere((res) => res.getWorkspaceId() == workspaceId);
    final reservationsToDelete = await FirebaseService()
        .firestore
        .collection("reservations")
        .where("workspaceId", isEqualTo: workspaceId)
        .get();
    for (var resDoc in reservationsToDelete.docs) {
      await resDoc.reference.delete();
    }
  }
}
