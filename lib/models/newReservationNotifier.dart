import 'package:flutter/material.dart';

enum Floors { f12, f11, f10, f9 }

class NewReservationNotifier extends ChangeNotifier{
  var _floor = Floors.f9;
  var _starTime = DateTime.now();
  var _endTime = DateTime.now();
  String? _roomNumber;

  Floors getFloor(){
    return _floor;
  }

  void setFloor(Floors floor){
    _floor = floor;
    notifyListeners();
  }

  DateTime getStartTime(){
    return _starTime.copyWith();
  }

  void setStartTime(DateTime start){
    _starTime = start;
    notifyListeners();
  }

  DateTime getEndTime(){
    return _endTime.copyWith();
  }

  void setEndTime(DateTime end){
    _endTime = end;
    notifyListeners();
  }

  String? getRoomNumber(){
    print(_roomNumber);
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