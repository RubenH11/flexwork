import 'package:flexwork/models/workspace.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import "./floors.dart";

class NewReservationNotifier extends ChangeNotifier {
  Floors _floor;
  String? _scheduleTimeframe;
  int _scheduleTimeframeNum = 1;
  Set<Tuple2<String, DateTime>> _scheduleExceptions = {};
  DateTime? _startTime;
  DateTime? _endTime;
  DateTime? _scheduleUntilDate;
  Workspace? _workspace;

  NewReservationNotifier(this._floor);

  bool isComplete() {
    print("is complete check");
    return _startTime != null &&
        _endTime != null &&
        _startTime != _endTime &&
        _workspace != null;
  }

  void clear() {
    _scheduleTimeframe = null;
    _scheduleTimeframeNum = 1;
    _scheduleExceptions = {};
    _startTime = null;
    _endTime = null;
    _scheduleUntilDate = null;
    _workspace = null;
    notifyListeners();
  }

  void clearSchedule() {
    _scheduleTimeframe = null;
    _scheduleExceptions = {};
    _scheduleTimeframeNum = 1;
    _scheduleUntilDate = null;
    notifyListeners();
  }

  void setStartTime(DateTime? start) {
    _startTime = start;
    print("setStartTime in newResercationNotifier to $start");
    notifyListeners();
  }

  void setEndTime(DateTime? end) {
    _endTime = end;
    print("setEndTime in newResercationNotifier to $end");
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

  void setScheduleTimeframe(String? timeframe) {
    if (getScheduleTimeframeOptions().contains(timeframe)) {
      _scheduleTimeframe = timeframe;
      notifyListeners();
    }
  }

  void setScheduleTimeframeNum(int number) {
    _scheduleTimeframeNum = number;
    notifyListeners();
  }

  void setScheduleUntilDate(DateTime date) {
    _scheduleUntilDate = date;
    notifyListeners();
  }

  void addManualScheduleException(DateTime exception) {
    print("before add $_scheduleExceptions");
    _scheduleExceptions.add(Tuple2("manual", exception));
    _sortScheduleExceptions();
    print(_scheduleExceptions);
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

  String? getScheduleTimeframe() {
    return _scheduleTimeframe;
  }

  int getScheduleTimeframeNum() {
    return _scheduleTimeframeNum;
  }

  static List<String> getScheduleTimeframeOptions() {
    return ["days", "weeks", "months", "years"];
  }

  Workspace? getWorkspace() {
    return _workspace;
  }

  Floors getFloor() {
    return _floor;
  }

  String? getIdentifier() {
    if (_workspace == null) {
      return null;
    }
    return _workspace!.getIdentifier();
  }

  DateTime? getEndTime() {
    return _endTime == null ? null : _endTime!.copyWith();
  }

  DateTime? getStartTime() {
    return _startTime == null ? null : _startTime!.copyWith();
  }

  // PRIVATE

  Set<Tuple2<String, DateTime>> _sortScheduleExceptions() {
    final listVersion = _scheduleExceptions.toList();
    listVersion.sort((a, b) => a.item2.compareTo(b.item2));
    return listVersion.toSet();
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
}
