import 'package:flutter/material.dart';

enum Floors { f9, f10, f11, f12 }

class FloorsConvert {
  static int toFloorNum(Floors floor) {
    return int.parse(floor.name.substring(1));
  }

  static Floors toFloors(int floorNum) {
    switch (floorNum) {
      case 9:
        return Floors.f9;
      case 10:
        return Floors.f10;
      case 11:
        return Floors.f11;
      case 12:
        return Floors.f12;
      default:
        throw ErrorDescription("floorNum was not between 9 and 12");
    }
  }
}
