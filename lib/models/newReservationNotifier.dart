import 'package:flutter/material.dart';
import "./floors.dart";

class NewReservationNotifier extends ChangeNotifier{
  var _floor = Floors.f9;
  DateTime? _startTime;
  DateTime? _endTime;
  String? _roomNumber;

  bool isComplete(){
    return _startTime != null && _endTime != null && _roomNumber != null;
  }

  void clear(){
    _startTime = null;
    _endTime = null;
    _roomNumber = null;
    notifyListeners();
  }

  Floors getFloor(){
    return _floor;
  }

  void setFloor(Floors floor){
    _floor = floor;
    notifyListeners();
  }

  DateTime? getStartTime(){
    return _startTime == null ? null :_startTime!.copyWith();
  }

  void setStartTime(DateTime? start){
    _startTime = start;
    print("setStartTime in newResercationNotifier");
    notifyListeners();
  }

  DateTime? getEndTime(){
    return _endTime == null ? null : _endTime!.copyWith();
  }

  void setEndTime(DateTime? end){
    _endTime = end;
    notifyListeners();
  }

  String? getRoomNumber(){
    return [_roomNumber].first;
  }

  void setRoomNumber(String? roomNum){
    _roomNumber = roomNum;
    notifyListeners();
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