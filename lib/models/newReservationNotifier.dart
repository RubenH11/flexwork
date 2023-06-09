import 'package:flexwork/database/database.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/models/request.dart';
import 'package:flexwork/models/reservation.dart';
import 'package:flexwork/models/reservationConflict.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import "./floors.dart";

class NewReservationNotifier extends ChangeNotifier {
  Floors _floor;
  String _scheduleFrequency = "months";
  int _scheduleFrequencyNum = 1;
  Set<Tuple2<String, DateTime>> _scheduleExceptions = {};
  DateTime? _startTime;
  DateTime? _endTime;
  DateTime? _scheduleUntilDate;
  Workspace? _workspace;
  final List<ReservationConflict> _acceptedConflicts = [];
  final Map<ReservationConflict, Request> _rejectedConflicts = {};

  NewReservationNotifier(this._floor);

  void _removeExceptions(List<Tuple2<DateTime, DateTime>> dates) {
    for (var exception in _scheduleExceptions) {
      final exceptionDate = DateTimeHelper.extractOnlyDay(exception.item2);

      dates.removeWhere((reservartion) {
        final resStartDateTime = reservartion.item1;
        final resEndDateTime = reservartion.item2;

        if (resStartDateTime.isBefore(exceptionDate) &&
            resEndDateTime.isBefore(exceptionDate)) {
          return false;
        } else if (resStartDateTime.isAfter(exceptionDate.add(
              const Duration(hours: 23, minutes: 56, seconds: 59),
            )) &&
            resEndDateTime.isAfter(exceptionDate.add(
              const Duration(hours: 23, minutes: 56, seconds: 59),
            ))) {
          return false;
        }
        return true;
      });
    }
  }

  void acceptReservationConflict(ReservationConflict resConflict) {
    print("== accept");
    _rejectedConflicts.removeWhere(
      (rejResConf, _) =>
          rejResConf.getStart() == resConflict.getStart() &&
          rejResConf.getEnd() == resConflict.getEnd(),
    );

    _acceptedConflicts.add(resConflict);
    notifyListeners();
  }

  void rejectReservationConflict(
      ReservationConflict resConflict, Request request) {
    print("== reject");
    _acceptedConflicts.removeWhere(
      (accResConf) =>
          accResConf.getStart() == resConflict.getStart() &&
          accResConf.getEnd() == resConflict.getEnd(),
    );
    _rejectedConflicts.addAll({resConflict: request});
    notifyListeners();
  }

  List<Request> getRequests() {
    return _rejectedConflicts.values.toList();
  }

  Future<bool> allConflictsResolved() async {
    print("-allConflictsResolved check-");
    final upToDateConflicts = await getConflicts();
    final resolvedConflicts = [..._acceptedConflicts];
    resolvedConflicts.addAll(_rejectedConflicts.keys);
    for (var resolvedConf in resolvedConflicts) {
      upToDateConflicts.removeWhere((upToDateConflict) =>
          upToDateConflict.getReservationId() ==
          resolvedConf.getReservationId());
    }
    return upToDateConflicts.isEmpty;
  }

  Future<List<ReservationConflict>> getConflicts() async {
    if (_startTime == null || _endTime == null || _workspace == null) {
      return [];
    }
    final schedule = constructScheduleIncludingConflicts();
    // print("get conflicts from schedule: $schedule");
    final List<ReservationConflict> reservationConflicts = [];
    for (var range in schedule) {
      // print("1");
      final reservations = await DatabaseFunctions.getReservations(
        timeRange: range,
        workspaceId: _workspace!.getId(),
        others: true,
      );

      // print("adding conflicts from range: $range");
      for (var res in reservations) {
        print("  ${res.getStart()} - ${res.getEnd()}");
      }

      reservationConflicts.addAll(
        reservations.map(
          (res) {
            final moments = [
              res.getStart(),
              res.getEnd(),
              range.item1,
              range.item2,
            ];
            moments.sort();
            return ReservationConflict(
              start: moments[1],
              end: moments[2],
              reservationId: res.getId(),
              workspaceId: res.getWorkspaceId(),
            );
          },
        ),
      );

      for (var blockedRange in _workspace!.getBlockedMoments()) {
        final overlappingRange =
            DateTimeHelper.getOverlappingRange(blockedRange, range);
        if (overlappingRange != null) {
          reservationConflicts.add(
            ReservationConflict(
              start: overlappingRange.item1,
              end: overlappingRange.item2,
              reservationId: -1,
              workspaceId: _workspace!.getId(),
            ),
          );
        }
      }
    }

    _cleanseReservationConflicts(reservationConflicts);

    return reservationConflicts;
  }

  void _cleanseReservationConflicts(List<ReservationConflict> conflicts) {
    _acceptedConflicts.removeWhere(
        (accConf) => conflicts.every((conf) => !conf.isEqual(accConf)));
    _rejectedConflicts.removeWhere(
        (rejConf, _) => conflicts.every((conf) => !conf.isEqual(rejConf)));
  }

  bool? conflictIsAccepted(ReservationConflict conflict) {
    print("all accepted Conflicts:");
    for (var conf in _acceptedConflicts) {
      print(" ${conf.getStart()} - ${conf.getEnd()}");
    }
    for (var accConflict in _acceptedConflicts) {
      if (accConflict.getStart() == conflict.getStart() &&
          accConflict.getEnd() == conflict.getEnd()) {
        print("43");
        print(accConflict.getStart());
        print(accConflict.getEnd());
        return true;
      }
    }

    for (var rejConflict in _rejectedConflicts.keys) {
      if (rejConflict.getStart() == conflict.getStart() &&
          rejConflict.getEnd() == rejConflict.getEnd()) {
        return false;
      }
    }

    return null;
  }

  List<Tuple2<DateTime, DateTime>> clipSchedule(
      List<Tuple2<DateTime, DateTime>> schedule,
      Tuple2<DateTime, DateTime> clip) {
    List<Tuple2<DateTime, DateTime>> clippedSchedule = [];

    for (var range in schedule) {
      // Check if the range is entirely before or after the clip
      if (range.item2.isBefore(clip.item1) || range.item1.isAfter(clip.item2)) {
        // No overlap, add the range as it is
        clippedSchedule.add(range);
      }
      // Check if the range is entirely within the clip
      else if (range.item1.isAfter(clip.item1) &&
          range.item2.isBefore(clip.item2)) {
        // Completely clipped, ignore this range
      }
      // Check if the range overlaps the clip and needs to be clipped
      else {
        // Clip the range and add the clipped parts to the new schedule

        // Clip the start if necessary
        if (range.item1.isBefore(clip.item1)) {
          clippedSchedule.add(Tuple2(range.item1, clip.item1));
        }

        // Clip the end if necessary
        if (range.item2.isAfter(clip.item2)) {
          clippedSchedule.add(Tuple2(clip.item2, range.item2));
        }
      }
    }

    return clippedSchedule;
  }

  List<Tuple2<DateTime, DateTime>> constructSchedule() {
    var schedule = constructScheduleIncludingConflicts();

    final handledConflicts = _acceptedConflicts
        .where((conf) => conf.getWorkspaceId() == _workspace!.getId())
        .toList();
    handledConflicts.addAll(_rejectedConflicts.keys
        .where((conf) => conf.getWorkspaceId() == _workspace!.getId())
        .toList());

    for (var conflict in handledConflicts
        .map((conf) => Tuple2(conf.getStart(), conf.getEnd()))) {
      schedule = clipSchedule(schedule, conflict);
      print("schedule after clip: $schedule, from conflict: $conflict");
    }

    // for (final res in schedule) {
    //   for (final conf in handledConflicts) {
    //     if (DateTimeHelper.dateRangesOverlap(
    //         res, Tuple2(conf.getStart(), conf.getEnd()))) {
    //       //remove reservation
    //       if (conf.getStart().isAtSameMomentAs(res.item1) &&
    //           conf.getEnd().isAtSameMomentAs(res.item2)) {
    //             print("000: remove reservation");
    //         schedule.remove(res);
    //       }
    //       //split in two
    //       else if (conf.getStart().isAfter(res.item1) &&
    //           conf.getEnd().isBefore(res.item2)) {
    //             print("000: split in two");
    //         schedule.remove(res);
    //         schedule.add(Tuple2(res.item1, conf.getStart()));
    //         schedule.add(Tuple2(conf.getEnd(), res.item2));
    //       }
    //       //clip off beginning
    //       else if (conf.getEnd().isAfter(res.item1) &&
    //           conf.getEnd().isBefore(res.item2)) {
    //             print("000: clip off beginning");
    //         schedule.remove(res);
    //         schedule.add(Tuple2(conf.getEnd(), res.item2));
    //       }
    //       //clip off end
    //       else if (conf.getStart().isAfter(res.item1) &&
    //           conf.getStart().isBefore(res.item2)) {
    //             print("000: ");
    //         schedule.remove(res);
    //         schedule.add(Tuple2(res.item1, conf.getStart()));
    //       } else {
    //         print("something strange happened");
    //       }
    //     }
    //   }
    // }
    // print(schedule);
    return [...schedule];
  }

  List<Tuple2<DateTime, DateTime>> constructScheduleIncludingConflicts() {
    if (_startTime == null || _endTime == null) {
      return [];
    }

    final List<Tuple2<DateTime, DateTime>> draftReservations = [
      Tuple2(_startTime!, _endTime!)
    ];

    if (_scheduleUntilDate == null) {
      return draftReservations;
    }

    final List<Tuple2<DateTime, DateTime>> scheduleReservations = [
      Tuple2(_startTime!, _endTime!)
    ];

    var currIncrement = _scheduleFrequencyNum;
    while (draftReservations.last.item2
        .isBefore(_scheduleUntilDate!.add(const Duration(days: 1)))) {
      switch (_scheduleFrequency) {
        case "days":
          draftReservations.add(
            Tuple2(
              _startTime!.add(Duration(days: currIncrement)),
              _endTime!.add(Duration(days: currIncrement)),
            ),
          );
          scheduleReservations.add(draftReservations.last);
          break;
        case "weeks":
          draftReservations.add(
            Tuple2(
              _startTime!.add(Duration(days: 7 * currIncrement)),
              _endTime!.add(Duration(days: 7 * currIncrement)),
            ),
          );
          scheduleReservations.add(draftReservations.last);
          break;
        case "months":
          draftReservations.add(
            Tuple2(
              DateTime(_startTime!.year, _startTime!.month + currIncrement,
                  _startTime!.day, _startTime!.hour, _startTime!.minute),
              DateTime(_endTime!.year, _endTime!.month + currIncrement,
                  _endTime!.day, _endTime!.hour, _endTime!.minute),
            ),
          );
          if (draftReservations.last.item1.day == _startTime!.day &&
              draftReservations.last.item2.day == _endTime!.day) {
            scheduleReservations.add(draftReservations.last);
          }
          break;
        case "years":
          draftReservations.add(
            Tuple2(
              DateTime(_startTime!.year + currIncrement, _startTime!.month,
                  _startTime!.day, _startTime!.hour, _startTime!.minute),
              DateTime(_endTime!.year + currIncrement, _endTime!.month,
                  _endTime!.day, _endTime!.hour, _endTime!.minute),
            ),
          );
          if (draftReservations.last.item1.day == _startTime!.day &&
              draftReservations.last.item2.day == _endTime!.day) {
            scheduleReservations.add(draftReservations.last);
          }
          break;
        default:
      }
      currIncrement += _scheduleFrequencyNum;
    }
    scheduleReservations.removeLast();
    _removeExceptions(scheduleReservations);
    return [...scheduleReservations];
  }

  Future<bool> isValid() async {
    if (_endTime == null ||
        _startTime == _endTime ||
        _startTime == null ||
        _workspace == null) {
      return false;
    }

    final reservations = constructSchedule();
    if (reservations.length == 0) {
      return false;
    }
    for (var moment in _workspace!.getBlockedMoments()) {
      for (var res in reservations) {
        if (DateTimeHelper.dateRangesOverlap(moment, res)) {
          return false;
        }
      }
    }
    if (hasSchedule()) {
      //check for overlap
      for (var i = 0; i < reservations.length - 1; i++) {
        if (DateTimeHelper.dateRangesOverlap(
            reservations[i], reservations[i + 1])) {
          return false;
        }
      }
    }
    return await allConflictsResolved();
  }

  bool hasSchedule() {
    return _scheduleUntilDate != null && _startTime != null && _endTime != null;
  }

  void clear() {
    print("clearing");
    _scheduleFrequency = "months";
    _scheduleExceptions = {};
    _scheduleFrequencyNum = 1;
    _scheduleUntilDate = null;
    _startTime = null;
    _endTime = null;
    _acceptedConflicts.clear();
    _rejectedConflicts.clear();
    print("done clearing");
    notifyListeners();
    print("notified");
  }

  void clearSchedule() {
    _scheduleFrequency = "months";
    _scheduleExceptions = {};
    _scheduleFrequencyNum = 1;
    _scheduleUntilDate = null;
    notifyListeners();
  }

  void setStartTime(DateTime? start) {
    _startTime = start;
    notifyListeners();
  }

  void setEndTime(DateTime? end) {
    _endTime = end;
    notifyListeners();
  }

  void setIdentifier(String identifier) {
    assert(_workspace != null);
    _workspace!.setIdentifier(identifier);
    notifyListeners();
  }

  void setFloor(Floors floor) {
    _floor = floor;
    notifyListeners();
  }

  void setWorkspace(Workspace? workspace) {
    _workspace = workspace;
    notifyListeners();
  }

  void setScheduleFrequency(String timeframe) {
    if (getScheduleFrequencyOptions().contains(timeframe)) {
      _scheduleFrequency = timeframe;
      notifyListeners();
    }
  }

  void setScheduleFrequencyNum(int number) {
    _scheduleFrequencyNum = number;
    notifyListeners();
  }

  void setScheduleUntilDate(DateTime date) {
    _scheduleUntilDate = date;
    notifyListeners();
  }

  void addManualScheduleException(DateTime exception) {
    _scheduleExceptions.add(Tuple2("manual", exception));
    notifyListeners();
  }

  void removeScheduleException(DateTime exception) {
    _scheduleExceptions.remove(Tuple2("manual", exception));
    notifyListeners();
  }

  List<DateTime> getScheduleExceptions() {
    return _scheduleExceptions.map((e) => e.item2).toList();
  }

  DateTime? getScheduleUntilDate() {
    return _scheduleUntilDate;
  }

  String? getScheduleFrequency() {
    return _scheduleFrequency;
  }

  int getScheduleFrequencyNum() {
    return _scheduleFrequencyNum;
  }

  static List<String> getScheduleFrequencyOptions() {
    return ["days", "weeks", "months", "years"];
  }

  Workspace? getWorkspace() {
    return _workspace;
  }

  Floors getFloor() {
    return _floor;
  }

  DateTime? getEndTime() {
    return _endTime == null ? null : _endTime!.copyWith();
  }

  DateTime? getStartTime() {
    return _startTime == null ? null : _startTime!.copyWith();
  }

  // Floors updateFloor(Floors? floor) {
  //   if (floor != null) {
  //     setState(() {
  //       this.floor = floor;
  //     });
  //   }
  //   return this.floor;
  // }

  // DateTime updateTime(DateTime? startTime) {
  //   if (startTime != null) {
  //     setState(() {
  //       this.starTime = startTime;
  //     });
  //   }
  //   return this.starTime;
  // }

  // DateTime updateEndTime(DateTime? endTime) {
  //   if (endTime != null) {
  //     setState(() {
  //       this.endTime = endTime;
  //     });
  //   }
  //   return this.endTime;
  // }

  // String updateRoomNumber(String? roomNumber) {
  //   if (roomNumber != null) {
  //     setState(() {
  //       this.roomNumber = roomNumber;
  //     });
  //   }
  //   return this.roomNumber;
  // }

  @override
  String toString() {
    final workspaceId = _workspace == null ? null : _workspace!.getId();

    return "Resrvation: Workspace $workspaceId, from $_startTime until $_endTime";
  }
}
