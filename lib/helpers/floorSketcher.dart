import "package:flutter/material.dart";
import "dart:math" as math;

class FloorSketcher {
  // Floor 9
  static Map<String, Path> getFloor9Rooms(
    double unitWidth,
    double unitHeight,
    double angleOfWalls,
  ) {
    Map<String, Path> rooms = {};
    const wall = 2.0;
    final roomUnitWidth = unitWidth - wall;
    final roomUnitHeight = unitHeight - wall;

    final topPoint = unitHeight * 1.5 + wall;
    final xOffset1 = math.sin(angleOfWalls) * unitWidth;
    final yOffset1 = -math.cos(angleOfWalls) * unitWidth;
    final xOffset2 = math.sin(angleOfWalls) * 2 * unitWidth;
    final yOffset2 = -math.cos(angleOfWalls) * 2 * unitWidth;
    final trickyAngle = math.atan(0.75);

    rooms.addAll({
      //top layer
      "09A-27": Path()
        ..addRect(Rect.fromLTWH(
            wall + 2 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-29": Path()
        ..addRect(Rect.fromLTWH(
            wall + 3 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-31": Path()
        ..addRect(Rect.fromLTWH(
            wall + 4 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-33": Path()
        ..addRect(Rect.fromLTWH(
            wall + 5 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-35": Path()
        ..addRect(Rect.fromLTWH(
            wall + 6 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-39": Path()
        ..addRect(Rect.fromLTWH(wall + 7 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "09A-41": Path()
        ..addRect(Rect.fromLTWH(
            wall + 9 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-43": Path()
        ..addRect(Rect.fromLTWH(wall + 10 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "09A-47": Path()
        ..addRect(Rect.fromLTWH(wall + 12 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "09A-51": Path()
        ..addRect(Rect.fromLTWH(wall + 14 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "09A-55": Path()
        ..addRect(Rect.fromLTWH(
            wall + 16 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-57": Path()
        ..addRect(Rect.fromLTWH(
            wall + 17 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-59": Path()
        ..addRect(Rect.fromLTWH(
            wall + 18 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-61": Path()
        ..addRect(Rect.fromLTWH(
            wall + 19 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-63": Path()
        ..addRect(Rect.fromLTWH(
            wall + 20 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-65": Path()
        ..addRect(Rect.fromLTWH(
            wall + 21 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-67": Path()
        ..addRect(Rect.fromLTWH(
            wall + 22 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "09A-69": Path()
        ..addRect(Rect.fromLTWH(
            wall + 23 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      //second layer
      "09A-30": Path()
        ..addRect(Rect.fromLTWH(
            wall + 3 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "09A-36": Path()
        ..addRect(Rect.fromLTWH(wall + 4 * unitWidth, topPoint,
            2 * unitWidth + roomUnitWidth, roomUnitHeight)),
      "09A-46": Path()
        ..addRect(Rect.fromLTWH(wall + 11 * unitWidth, topPoint,
            2 * unitWidth + roomUnitWidth, unitHeight * 1.5 + roomUnitHeight)),
      "09A-54": Path()
        ..addRect(Rect.fromLTWH(
            wall + 15 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "09A-56": Path()
        ..addRect(Rect.fromLTWH(wall + 16 * unitWidth, topPoint,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "09A-60": Path()
        ..addRect(Rect.fromLTWH(wall + 16 * unitWidth, topPoint + unitHeight,
            unitWidth + roomUnitWidth, 0.5 * unitHeight + roomUnitHeight)),
      "09A-66": Path()
        ..addRect(Rect.fromLTWH(wall + 20.5 * unitWidth, topPoint,
            unitWidth * 0.5 + roomUnitWidth, roomUnitHeight)),
      // left layer
      "09A-13": Path()
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            2 * unitHeight,
            wall + unitWidth * 0.5 + roomUnitWidth,
            unitHeight + roomUnitHeight)),
      "09A-07": Path()
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            4 * unitHeight,
            wall + unitWidth * 0.5 + roomUnitWidth,
            unitHeight + roomUnitHeight)),
      "09A-01": Path()
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            6 * unitHeight,
            wall + unitWidth * 0.5 + roomUnitWidth,
            unitHeight + roomUnitHeight))
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            (6 + 2 / 3) * unitHeight,
            wall + unitWidth * 2 + roomUnitWidth,
            (1 / 3) * unitHeight + roomUnitHeight)),
      // right layer
      "09A-89": Path()
        ..moveTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
        ..lineTo(
            (24 + 2 / 3) * unitWidth - math.cos(angleOfWalls) * roomUnitHeight,
            6 * unitHeight - math.sin(angleOfWalls) * roomUnitHeight)
        ..lineTo(
            (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight +
                math.sin(angleOfWalls) * roomUnitWidth,
            6 * unitHeight -
                math.sin(angleOfWalls) * roomUnitHeight -
                math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo(
            (24 + 2 / 3) * unitWidth + math.sin(angleOfWalls) * roomUnitWidth,
            6 * unitHeight - math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo((24 + 2 / 3) * unitWidth, 6 * unitHeight),
      "09A-87": Path()
        ..moveTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight)
        ..lineTo(
            xOffset1 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight,
            yOffset1 + 6 * unitHeight - math.sin(angleOfWalls) * roomUnitHeight)
        ..lineTo(
            xOffset1 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight +
                math.sin(angleOfWalls) * roomUnitWidth,
            yOffset1 +
                6 * unitHeight -
                math.sin(angleOfWalls) * roomUnitHeight -
                math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo(
            xOffset1 +
                (24 + 2 / 3) * unitWidth +
                math.sin(angleOfWalls) * roomUnitWidth,
            yOffset1 + 6 * unitHeight - math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo(
            xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight),
      "09A-85": Path()
        ..moveTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight)
        ..lineTo(
            xOffset2 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight,
            yOffset2 + 6 * unitHeight - math.sin(angleOfWalls) * roomUnitHeight)
        ..lineTo(
            xOffset2 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight +
                math.sin(angleOfWalls) * (roomUnitWidth + unitWidth),
            yOffset2 +
                6 * unitHeight -
                math.sin(angleOfWalls) * roomUnitHeight -
                math.cos(angleOfWalls) * (unitWidth + roomUnitWidth))
        ..lineTo(
            xOffset2 +
                (24 + 2 / 3) * unitWidth +
                math.sin(angleOfWalls) * (roomUnitWidth + unitWidth),
            yOffset2 +
                6 * unitHeight -
                math.cos(angleOfWalls) * (roomUnitWidth + unitWidth))
        ..lineTo(
            xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight),
      //tricky room
      "09A-93": Path()
        ..moveTo((22 + 5 / 12) * unitWidth, 8 * unitHeight) // G
        ..lineTo(
            (22 + 5 / 12) * unitWidth +
                math.cos(0.5 * math.pi - trickyAngle) *
                    (2 * unitWidth / math.cos(trickyAngle - angleOfWalls)),
            8 * unitHeight -
                math.sin(0.5 * math.pi - trickyAngle) *
                    (2 * unitWidth / math.cos(trickyAngle - angleOfWalls)))
        ..lineTo(
            (22 + 5 / 12) * unitWidth +
                math.sin(angleOfWalls) * 2 * unitWidth -
                math.cos(angleOfWalls) * unitHeight,
            8 * unitHeight -
                math.cos(angleOfWalls) * 2 * unitWidth -
                math.sin(angleOfWalls) * unitHeight) // H
        ..lineTo(
            (22 + 5 / 12) * unitWidth - unitHeight / math.cos(angleOfWalls),
            8 * unitHeight) // I
        ..lineTo((22 + 5 / 12) * unitWidth, 8 * unitHeight), //D
    });
    return rooms;
  }

  static Path getFloor9InnerWalls(
    double unitWidth,
    double unitHeight,
    double angleOfWalls,
  ) {
    return Path()
      //middle-left wall
      ..moveTo(7 * unitWidth, 1.5 * unitHeight + 2.0)
      ..lineTo(7 * unitWidth, 2.5 * unitHeight)
      //moddle-right wall
      ..moveTo(11 * unitWidth, 1.5 * unitHeight + 2.0)
      ..lineTo(11 * unitWidth, 4 * unitHeight)
      //topleft
      ..moveTo(7 * unitWidth, 3.5 * unitHeight)
      ..lineTo(7.7 * unitWidth, 3.5 * unitHeight)
      ..lineTo(7.7 * unitWidth, 2.5 * unitHeight)
      ..lineTo(2.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(2.5 * unitWidth, 3.5 * unitHeight)
      ..lineTo(3.2 * unitWidth, 3.5 * unitHeight)
      ..lineTo(3.2 * unitWidth, 3.4 * unitHeight)
      ..lineTo(7 * unitWidth, 3.4 * unitHeight)
      ..lineTo(7 * unitWidth, 3.5 * unitHeight)
      //bottomleft
      ..moveTo(3.2 * unitWidth, 4 * unitHeight)
      ..lineTo(2.5 * unitWidth, 4 * unitHeight)
      ..lineTo(2.5 * unitWidth, 5.5 * unitHeight)
      ..lineTo(7 * unitWidth, 5.5 * unitHeight)
      ..lineTo(7 * unitWidth, 4.2 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4.2 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4 * unitHeight)
      //right
      ..moveTo(19 * unitWidth, 4 * unitHeight)
      ..lineTo(19.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(22 * unitWidth, 2.5 * unitHeight)
      ..lineTo(
          19 * unitWidth +
              math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth,
          4 * unitHeight +
              math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth)
      ..lineTo(
          19 * unitWidth +
              math.cos(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.cos(angleOfWalls) * unitHeight,
          4 * unitHeight +
              math.sin(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          19 * unitWidth +
              math.cos(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.cos(angleOfWalls) * unitHeight -
              math.sin(angleOfWalls) * 2 * unitWidth,
          4 * unitHeight +
              math.sin(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.sin(angleOfWalls) * unitHeight +
              math.cos(angleOfWalls) * 2 * unitWidth)
      ..lineTo(19 * unitWidth - math.sin(angleOfWalls) * 2 * unitWidth,
          4 * unitHeight + math.cos(angleOfWalls) * 2 * unitWidth)
      ..lineTo(19 * unitWidth, 4 * unitHeight);
  }

  // Floor 10
  static Map<String, Path> getFloor10Rooms(
    double unitWidth,
    double unitHeight,
    double angleOfWalls,
  ) {
    Map<String, Path> rooms = {};
    const wall = 2.0;
    final roomUnitWidth = unitWidth - wall;
    final roomUnitHeight = unitHeight - wall;

    final topPoint = unitHeight * 1.5 + wall;
    final xOffset1 = math.sin(angleOfWalls) * unitWidth;
    final yOffset1 = -math.cos(angleOfWalls) * unitWidth;
    final xOffset2 = math.sin(angleOfWalls) * 2 * unitWidth;
    final yOffset2 = -math.cos(angleOfWalls) * 2 * unitWidth;
    final trickyAngle = math.atan(0.75);
    final referencePointX = 19 * unitWidth +
        math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
        math.cos(angleOfWalls) * unitHeight -
        math.sin(angleOfWalls) * 2 * unitWidth -
        math.cos(angleOfWalls) * 0.5 * unitHeight;
    final referencePointY = 4 * unitHeight +
        math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
        math.sin(angleOfWalls) * unitHeight +
        math.cos(angleOfWalls) * 2 * unitWidth -
        math.sin(angleOfWalls) * 0.5 * unitHeight;

    rooms.addAll({
      //top layer
      "10A-27": Path()
        ..addRect(Rect.fromLTWH(
            wall + 2 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "10A-29": Path()
        ..addRect(Rect.fromLTWH(
            wall + 3 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "10A-31": Path()
        ..addRect(Rect.fromLTWH(
            wall + 4 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "10A-33": Path()
        ..addRect(Rect.fromLTWH(wall + 5 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "10A-37": Path()
        ..addRect(Rect.fromLTWH(wall + 7 * unitWidth, wall,
            2 * unitWidth + roomUnitWidth, roomUnitHeight)),
      "10A-43": Path()
        ..addRect(Rect.fromLTWH(wall + 10 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "10A-47": Path()
        ..addRect(Rect.fromLTWH(
            wall + 12 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "10A-49": Path()
        ..addRect(Rect.fromLTWH(
            wall + 13 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "10A-51": Path()
        ..addRect(Rect.fromLTWH(wall + 14 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "10A-55": Path()
        ..addRect(Rect.fromLTWH(
            wall + 16 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "10A-57": Path()
        ..addRect(Rect.fromLTWH(wall + 17 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "10A-61": Path()
        ..addRect(Rect.fromLTWH(wall + 19 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "10A-65": Path()
        ..addRect(Rect.fromLTWH(wall + 21 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "10A-69": Path()
        ..addRect(Rect.fromLTWH(
            wall + 23 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      //second layer
      "10A-30": Path()
        ..addRect(Rect.fromLTWH(
            wall + 3 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "10A-46": Path()
        ..addRect(Rect.fromLTWH(wall + 11 * unitWidth, topPoint,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "10A-56": Path()
        ..addRect(Rect.fromLTWH(
            wall + 16 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "10A-58": Path()
        ..addRect(Rect.fromLTWH(
            wall + 17 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "10A-50": Path()
        ..addRect(Rect.fromLTWH(wall + 11 * unitWidth, topPoint + unitHeight,
            4 * unitWidth + roomUnitWidth, roomUnitHeight + 0.5 * unitHeight)),
      "10A-60": Path()
        ..addRect(Rect.fromLTWH(wall + 16 * unitWidth, topPoint + unitHeight,
            unitWidth + roomUnitWidth, 0.5 * unitHeight + roomUnitHeight)),
      "10A-66": Path()
        ..addRect(Rect.fromLTWH(wall + 20.5 * unitWidth, topPoint,
            unitWidth * 0.5 + roomUnitWidth, roomUnitHeight)),
      // left layer
      "10A-13": Path()
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            2 * unitHeight,
            wall + unitWidth * 0.5 + roomUnitWidth,
            unitHeight + roomUnitHeight)),
      "10A-07": Path()
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            4 * unitHeight,
            wall + unitWidth * 0.5 + roomUnitWidth,
            unitHeight + roomUnitHeight)),
      "10A-01": Path()
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            6 * unitHeight,
            wall + unitWidth * 0.5 + roomUnitWidth,
            unitHeight + roomUnitHeight))
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            (6 + 2 / 3) * unitHeight,
            wall + unitWidth * 2 + roomUnitWidth,
            (1 / 3) * unitHeight + roomUnitHeight)),
      // right layer
      "10A-89": Path()
        ..moveTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
        ..lineTo(
            (24 + 2 / 3) * unitWidth - math.cos(angleOfWalls) * roomUnitHeight,
            6 * unitHeight - math.sin(angleOfWalls) * roomUnitHeight)
        ..lineTo(
            (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight +
                math.sin(angleOfWalls) * roomUnitWidth,
            6 * unitHeight -
                math.sin(angleOfWalls) * roomUnitHeight -
                math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo(
            (24 + 2 / 3) * unitWidth + math.sin(angleOfWalls) * roomUnitWidth,
            6 * unitHeight - math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo((24 + 2 / 3) * unitWidth, 6 * unitHeight),
      "10A-87": Path()
        ..moveTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight)
        ..lineTo(
            xOffset1 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight,
            yOffset1 + 6 * unitHeight - math.sin(angleOfWalls) * roomUnitHeight)
        ..lineTo(
            xOffset1 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight +
                math.sin(angleOfWalls) * roomUnitWidth,
            yOffset1 +
                6 * unitHeight -
                math.sin(angleOfWalls) * roomUnitHeight -
                math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo(
            xOffset1 +
                (24 + 2 / 3) * unitWidth +
                math.sin(angleOfWalls) * roomUnitWidth,
            yOffset1 + 6 * unitHeight - math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo(
            xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight),
      "10A-85": Path()
        ..moveTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight)
        ..lineTo(
            xOffset2 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight,
            yOffset2 + 6 * unitHeight - math.sin(angleOfWalls) * roomUnitHeight)
        ..lineTo(
            xOffset2 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight +
                math.sin(angleOfWalls) * (roomUnitWidth + unitWidth),
            yOffset2 +
                6 * unitHeight -
                math.sin(angleOfWalls) * roomUnitHeight -
                math.cos(angleOfWalls) * (unitWidth + roomUnitWidth))
        ..lineTo(
            xOffset2 +
                (24 + 2 / 3) * unitWidth +
                math.sin(angleOfWalls) * (roomUnitWidth + unitWidth),
            yOffset2 +
                6 * unitHeight -
                math.cos(angleOfWalls) * (roomUnitWidth + unitWidth))
        ..lineTo(
            xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight),
      //tricky room
      "10A-93": Path()
        ..moveTo((22 + 5 / 12) * unitWidth, 8 * unitHeight) // G
        ..lineTo(
            (22 + 5 / 12) * unitWidth +
                math.cos(0.5 * math.pi - trickyAngle) *
                    (2 * unitWidth / math.cos(trickyAngle - angleOfWalls)),
            8 * unitHeight -
                math.sin(0.5 * math.pi - trickyAngle) *
                    (2 * unitWidth / math.cos(trickyAngle - angleOfWalls)))
        ..lineTo(
            (22 + 5 / 12) * unitWidth +
                math.sin(angleOfWalls) * 2 * unitWidth -
                math.cos(angleOfWalls) * unitHeight,
            8 * unitHeight -
                math.cos(angleOfWalls) * 2 * unitWidth -
                math.sin(angleOfWalls) * unitHeight) // H
        ..lineTo(
            (22 + 5 / 12) * unitWidth +
                math.sin(angleOfWalls) * 2 * unitWidth -
                math.cos(angleOfWalls) * unitHeight +
                math.sin(angleOfWalls) * 1.1 * unitWidth,
            8 * unitHeight -
                math.cos(angleOfWalls) * 2 * unitWidth -
                math.sin(angleOfWalls) * unitHeight -
                math.cos(angleOfWalls) * 1.1 * unitWidth) // K
        ..lineTo(19 * unitWidth - math.sin(angleOfWalls) * 2 * unitWidth,
            4 * unitHeight + math.cos(angleOfWalls) * 2 * unitWidth)
        ..lineTo((17 + 2 / 3) * unitWidth, 8 * unitHeight)
        ..lineTo(
            (22 + 5 / 12) * unitWidth - unitHeight / math.cos(angleOfWalls),
            8 * unitHeight) // I
        ..lineTo((22 + 5 / 12) * unitWidth, 8 * unitHeight), //D
    });
    return rooms;
  }

  static Path getFloor10InnerWalls(
    double unitWidth,
    double unitHeight,
    double angleOfWalls,
  ) {
    return Path()
      //middle-left wall
      ..moveTo(7 * unitWidth, 1.5 * unitHeight + 2.0)
      ..lineTo(7 * unitWidth, 2.5 * unitHeight)
      //moddle-right wall
      ..moveTo(11 * unitWidth, 1.5 * unitHeight + 2.0)
      ..lineTo(11 * unitWidth, 4 * unitHeight)

      ///topleft
      ..moveTo(7 * unitWidth, 3.5 * unitHeight)
      ..lineTo(7.7 * unitWidth, 3.5 * unitHeight)
      ..lineTo(7.7 * unitWidth, 2.5 * unitHeight)
      ..lineTo(2.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(2.5 * unitWidth, 3.5 * unitHeight)
      ..lineTo(3.2 * unitWidth, 3.5 * unitHeight)
      ..lineTo(3.2 * unitWidth, 3.4 * unitHeight)
      ..lineTo(7 * unitWidth, 3.4 * unitHeight)
      ..lineTo(7 * unitWidth, 3.5 * unitHeight)
      //bottomleft
      ..moveTo(3.2 * unitWidth, 4 * unitHeight)
      ..lineTo(2.5 * unitWidth, 4 * unitHeight)
      ..lineTo(2.5 * unitWidth, 5.5 * unitHeight)
      ..lineTo(7 * unitWidth, 5.5 * unitHeight)
      ..lineTo(7 * unitWidth, 4.2 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4.2 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4 * unitHeight)
      //right
      ..moveTo(19 * unitWidth, 4 * unitHeight)
      ..lineTo(19.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(22 * unitWidth, 2.5 * unitHeight)
      ..lineTo(
          19 * unitWidth +
              math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth,
          4 * unitHeight +
              math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth)
      ..lineTo(
          19 * unitWidth +
              math.cos(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.cos(angleOfWalls) * unitHeight,
          4 * unitHeight +
              math.sin(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          19 * unitWidth +
              math.cos(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.cos(angleOfWalls) * unitHeight -
              math.sin(angleOfWalls) * 2 * unitWidth,
          4 * unitHeight +
              math.sin(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.sin(angleOfWalls) * unitHeight +
              math.cos(angleOfWalls) * 2 * unitWidth)
      ..lineTo(19 * unitWidth - math.sin(angleOfWalls) * 2 * unitWidth,
          4 * unitHeight + math.cos(angleOfWalls) * 2 * unitWidth)
      ..lineTo(19 * unitWidth, 4 * unitHeight);
  }

  // Floor 11
  static Map<String, Path> getFloor11Rooms(
    double unitWidth,
    double unitHeight,
    double angleOfWalls,
  ) {
    Map<String, Path> rooms = {};
    const wall = 2.0;
    final roomUnitWidth = unitWidth - wall;
    final roomUnitHeight = unitHeight - wall;

    final topPoint = unitHeight * 1.5 + wall;
    final xOffset1 = math.sin(angleOfWalls) * unitWidth;
    final yOffset1 = -math.cos(angleOfWalls) * unitWidth;
    final xOffset2 = math.sin(angleOfWalls) * 2 * unitWidth;
    final yOffset2 = -math.cos(angleOfWalls) * 2 * unitWidth;
    final trickyAngle = math.atan(0.75);
    final referencePointX = 19 * unitWidth +
        math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
        math.cos(angleOfWalls) * unitHeight -
        math.sin(angleOfWalls) * 2 * unitWidth -
        math.cos(angleOfWalls) * 0.5 * unitHeight;
    final referencePointY = 4 * unitHeight +
        math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
        math.sin(angleOfWalls) * unitHeight +
        math.cos(angleOfWalls) * 2 * unitWidth -
        math.sin(angleOfWalls) * 0.5 * unitHeight;

    rooms.addAll({
      //top layer
      "11A-27": Path()
        ..addRect(Rect.fromLTWH(
            wall + 2 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "11A-29": Path()
        ..addRect(Rect.fromLTWH(
            wall + 3 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "11A-31": Path()
        ..addRect(Rect.fromLTWH(
            wall + 4 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "11A-33": Path()
        ..addRect(Rect.fromLTWH(wall + 5 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "11A-37": Path()
        ..addRect(Rect.fromLTWH(wall + 7 * unitWidth, wall,
            2 * unitWidth + roomUnitWidth, roomUnitHeight)),
      "11A-43": Path()
        ..addRect(Rect.fromLTWH(wall + 10 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "11A-47": Path()
        ..addRect(Rect.fromLTWH(
            wall + 12 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "11A-49": Path()
        ..addRect(Rect.fromLTWH(
            wall + 13 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "11A-51": Path()
        ..addRect(Rect.fromLTWH(wall + 14 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "11A-55": Path()
        ..addRect(Rect.fromLTWH(
            wall + 16 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "11A-57": Path()
        ..addRect(Rect.fromLTWH(wall + 17 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "11A-61": Path()
        ..addRect(Rect.fromLTWH(wall + 19 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "11A-65": Path()
        ..addRect(Rect.fromLTWH(wall + 21 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "11A-69": Path()
        ..addRect(Rect.fromLTWH(
            wall + 23 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      //second layer
      "11A-30": Path()
        ..addRect(Rect.fromLTWH(
            wall + 3 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "11A-46": Path()
        ..addRect(Rect.fromLTWH(
            wall + 11 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "11A-48": Path()
        ..addRect(Rect.fromLTWH(
            wall + 12 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "11A-56": Path()
        ..addRect(Rect.fromLTWH(
            wall + 16 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "11A-58": Path()
        ..addRect(Rect.fromLTWH(
            wall + 17 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "11A-60": Path()
        ..addRect(Rect.fromLTWH(wall + 16 * unitWidth, topPoint + unitHeight,
            unitWidth + roomUnitWidth, 0.5 * unitHeight + roomUnitHeight)),
      "11A-66": Path()
        ..addRect(Rect.fromLTWH(wall + 20.5 * unitWidth, topPoint,
            unitWidth * 0.5 + roomUnitWidth, roomUnitHeight)),
      // left layer
      "11A-13": Path()
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            2 * unitHeight,
            wall + unitWidth * 0.5 + roomUnitWidth,
            unitHeight + roomUnitHeight)),
      "11A-07": Path()
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            4 * unitHeight,
            wall + unitWidth * 0.5 + roomUnitWidth,
            unitHeight + roomUnitHeight)),
      "11A-01": Path()
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            6 * unitHeight,
            wall + unitWidth * 0.5 + roomUnitWidth,
            unitHeight + roomUnitHeight))
        ..addRect(Rect.fromLTWH(
            wall + 0.0,
            (6 + 2 / 3) * unitHeight,
            wall + unitWidth * 2 + roomUnitWidth,
            (1 / 3) * unitHeight + roomUnitHeight)),
      // right layer
      "11A-89": Path()
        ..moveTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
        ..lineTo(
            (24 + 2 / 3) * unitWidth - math.cos(angleOfWalls) * roomUnitHeight,
            6 * unitHeight - math.sin(angleOfWalls) * roomUnitHeight)
        ..lineTo(
            (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight +
                math.sin(angleOfWalls) * roomUnitWidth,
            6 * unitHeight -
                math.sin(angleOfWalls) * roomUnitHeight -
                math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo(
            (24 + 2 / 3) * unitWidth + math.sin(angleOfWalls) * roomUnitWidth,
            6 * unitHeight - math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo((24 + 2 / 3) * unitWidth, 6 * unitHeight),
      "11A-87": Path()
        ..moveTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight)
        ..lineTo(
            xOffset1 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight,
            yOffset1 + 6 * unitHeight - math.sin(angleOfWalls) * roomUnitHeight)
        ..lineTo(
            xOffset1 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight +
                math.sin(angleOfWalls) * roomUnitWidth,
            yOffset1 +
                6 * unitHeight -
                math.sin(angleOfWalls) * roomUnitHeight -
                math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo(
            xOffset1 +
                (24 + 2 / 3) * unitWidth +
                math.sin(angleOfWalls) * roomUnitWidth,
            yOffset1 + 6 * unitHeight - math.cos(angleOfWalls) * roomUnitWidth)
        ..lineTo(
            xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight),
      "11A-85": Path()
        ..moveTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight)
        ..lineTo(
            xOffset2 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight,
            yOffset2 + 6 * unitHeight - math.sin(angleOfWalls) * roomUnitHeight)
        ..lineTo(
            xOffset2 +
                (24 + 2 / 3) * unitWidth -
                math.cos(angleOfWalls) * roomUnitHeight +
                math.sin(angleOfWalls) * (roomUnitWidth + unitWidth),
            yOffset2 +
                6 * unitHeight -
                math.sin(angleOfWalls) * roomUnitHeight -
                math.cos(angleOfWalls) * (unitWidth + roomUnitWidth))
        ..lineTo(
            xOffset2 +
                (24 + 2 / 3) * unitWidth +
                math.sin(angleOfWalls) * (roomUnitWidth + unitWidth),
            yOffset2 +
                6 * unitHeight -
                math.cos(angleOfWalls) * (roomUnitWidth + unitWidth))
        ..lineTo(
            xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight),
      //tricky room
      "11A-93": Path()
        ..moveTo((22 + 5 / 12) * unitWidth, 8 * unitHeight) // G
        ..lineTo(
            (22 + 5 / 12) * unitWidth +
                math.cos(0.5 * math.pi - trickyAngle) *
                    (2 * unitWidth / math.cos(trickyAngle - angleOfWalls)),
            8 * unitHeight -
                math.sin(0.5 * math.pi - trickyAngle) *
                    (2 * unitWidth / math.cos(trickyAngle - angleOfWalls)))
        ..lineTo(
            (22 + 5 / 12) * unitWidth +
                math.sin(angleOfWalls) * 2 * unitWidth -
                math.cos(angleOfWalls) * unitHeight,
            8 * unitHeight -
                math.cos(angleOfWalls) * 2 * unitWidth -
                math.sin(angleOfWalls) * unitHeight) // H
        ..lineTo(
            (22 + 5 / 12) * unitWidth +
                math.sin(angleOfWalls) * 2 * unitWidth -
                math.cos(angleOfWalls) * unitHeight +
                math.sin(angleOfWalls) * 1.1 * unitWidth,
            8 * unitHeight -
                math.cos(angleOfWalls) * 2 * unitWidth -
                math.sin(angleOfWalls) * unitHeight -
                math.cos(angleOfWalls) * 1.1 * unitWidth) // K
        ..lineTo(19 * unitWidth - math.sin(angleOfWalls) * 2 * unitWidth,
            4 * unitHeight + math.cos(angleOfWalls) * 2 * unitWidth)
        ..lineTo((17 + 2 / 3) * unitWidth, 8 * unitHeight)
        ..lineTo(
            (22 + 5 / 12) * unitWidth - unitHeight / math.cos(angleOfWalls),
            8 * unitHeight) // I
        ..lineTo((22 + 5 / 12) * unitWidth, 8 * unitHeight), //D
    });
    return rooms;
  }

  static Path getFloor11InnerWalls(
    double unitWidth,
    double unitHeight,
    double angleOfWalls,
  ) {
    return Path()
      //middle-left wall
      ..moveTo(7 * unitWidth, 1.5 * unitHeight + 2.0)
      ..lineTo(7 * unitWidth, 2.5 * unitHeight)
      //moddle-right wall
      ..moveTo(11 * unitWidth, 1.5 * unitHeight + 2.0)
      ..lineTo(11 * unitWidth, 4 * unitHeight)
      //topleft
      ..moveTo(7 * unitWidth, 3.5 * unitHeight)
      ..lineTo(7.7 * unitWidth, 3.5 * unitHeight)
      ..lineTo(7.7 * unitWidth, 2.5 * unitHeight)
      ..lineTo(2.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(2.5 * unitWidth, 3.5 * unitHeight)
      ..lineTo(3.2 * unitWidth, 3.5 * unitHeight)
      ..lineTo(3.2 * unitWidth, 3.4 * unitHeight)
      ..lineTo(7 * unitWidth, 3.4 * unitHeight)
      ..lineTo(7 * unitWidth, 3.5 * unitHeight)
      //bottomleft
      ..moveTo(3.2 * unitWidth, 4 * unitHeight)
      ..lineTo(2.5 * unitWidth, 4 * unitHeight)
      ..lineTo(2.5 * unitWidth, 5.5 * unitHeight)
      ..lineTo(7 * unitWidth, 5.5 * unitHeight)
      ..lineTo(7 * unitWidth, 4.2 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4.2 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4 * unitHeight)
      //right
      ..moveTo(19 * unitWidth, 4 * unitHeight)
      ..lineTo(19.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(22 * unitWidth, 2.5 * unitHeight)
      ..lineTo(
          19 * unitWidth +
              math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth,
          4 * unitHeight +
              math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth)
      ..lineTo(
          19 * unitWidth +
              math.cos(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.cos(angleOfWalls) * unitHeight,
          4 * unitHeight +
              math.sin(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          19 * unitWidth +
              math.cos(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.cos(angleOfWalls) * unitHeight -
              math.sin(angleOfWalls) * 2 * unitWidth,
          4 * unitHeight +
              math.sin(angleOfWalls) *
                  math.cos(angleOfWalls) *
                  2.5 *
                  unitWidth +
              math.sin(angleOfWalls) * unitHeight +
              math.cos(angleOfWalls) * 2 * unitWidth)
      ..lineTo(19 * unitWidth - math.sin(angleOfWalls) * 2 * unitWidth,
          4 * unitHeight + math.cos(angleOfWalls) * 2 * unitWidth)
      ..lineTo(19 * unitWidth, 4 * unitHeight);
  }

  // Floor 12
  static Map<String, Path> getFloor12Rooms(
    double unitWidth,
    double unitHeight,
    double angleOfWalls,
  ) {
    Map<String, Path> rooms = {};
    const wall = 2.0;
    final roomUnitWidth = unitWidth - wall;
    final roomUnitHeight = unitHeight - wall;

    final topPoint = unitHeight * 1.5 + wall;
    final xOffset1 = math.sin(angleOfWalls) * unitWidth;
    final yOffset1 = -math.cos(angleOfWalls) * unitWidth;
    final xOffset2 = math.sin(angleOfWalls) * 2 * unitWidth;
    final yOffset2 = -math.cos(angleOfWalls) * 2 * unitWidth;
    final trickyAngle = math.atan(0.75);
    final referencePointX = 19 * unitWidth +
        math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
        math.cos(angleOfWalls) * unitHeight -
        math.sin(angleOfWalls) * 2 * unitWidth -
        math.cos(angleOfWalls) * 0.5 * unitHeight;
    final referencePointY = 4 * unitHeight +
        math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
        math.sin(angleOfWalls) * unitHeight +
        math.cos(angleOfWalls) * 2 * unitWidth -
        math.sin(angleOfWalls) * 0.5 * unitHeight;

    rooms.addAll({
      //top layer
      "12A-27": Path()
        ..addRect(Rect.fromLTWH(
            wall + 2 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "12A-29": Path()
        ..addRect(Rect.fromLTWH(
            wall + 3 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "12A-31": Path()
        ..addRect(Rect.fromLTWH(
            wall + 4 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "12A-33": Path()
        ..addRect(Rect.fromLTWH(wall + 5 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "12A-37": Path()
        ..addRect(Rect.fromLTWH(wall + 7 * unitWidth, wall,
            2 * unitWidth + roomUnitWidth, roomUnitHeight)),
      "12A-43": Path()
        ..addRect(Rect.fromLTWH(wall + 10 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "12A-47": Path()
        ..addRect(Rect.fromLTWH(wall + 12 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "12A-51": Path()
        ..addRect(Rect.fromLTWH(wall + 14 * unitWidth, wall,
            unitWidth + roomUnitWidth, roomUnitHeight)),
      "12A-55": Path()
        ..addRect(Rect.fromLTWH(
            wall + 16 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "12A-57": Path()
        ..addRect(Rect.fromLTWH(
            wall + 17 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "12A-59": Path()
        ..addRect(Rect.fromLTWH(
            wall + 18 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      "12A-61": Path()
        ..addRect(Rect.fromLTWH(wall + 19 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "12A-65": Path()
        ..addRect(Rect.fromLTWH(wall + 21 * unitWidth, wall,
            roomUnitWidth + unitWidth, roomUnitHeight)),
      "12A-69": Path()
        ..addRect(Rect.fromLTWH(
            wall + 23 * unitWidth, wall, roomUnitWidth, roomUnitHeight)),
      //second layer
      "12A-30": Path()
        ..addRect(Rect.fromLTWH(
            wall + 3 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "12A-52": Path()
        ..addRect(Rect.fromLTWH(wall + 11 * unitWidth, topPoint,
            roomUnitWidth + 3 * unitWidth, roomUnitHeight + 1.5 * unitHeight)),
      "12A-56": Path()
        ..addRect(Rect.fromLTWH(
            wall + 16 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      "12A-58": Path()
        ..addRect(Rect.fromLTWH(
            wall + 17 * unitWidth, topPoint, roomUnitWidth, roomUnitHeight)),
      // left layer
      "12A-11": Path()
        ..moveTo(wall + 0.0, 4 * unitHeight)
        ..lineTo(2.7 * unitWidth, 4 * unitHeight)
        ..lineTo(2.7 * unitWidth, 4.75 * unitHeight)
        ..lineTo(3.2 * unitWidth, 4.75 * unitHeight)
        ..lineTo(3.2 * unitWidth, 5.5 * unitHeight)
        ..lineTo(7 * unitWidth, 5.5 * unitHeight)
        ..lineTo(7 * unitWidth, 8 * unitHeight)
        ..lineTo(wall + 0.0 * unitWidth, 8 * unitHeight)
        ..lineTo(wall + 0.0, 4 * unitHeight),
      //tricky room
      "12A-81": Path()
        ..moveTo(19.5 * unitWidth, 2.5 * unitHeight)
        ..lineTo(22 * unitWidth, 2.5 * unitHeight)
        ..lineTo(
            24 * unitWidth -
                math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2 * unitWidth,
            2.5 * unitHeight -
                math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2 * unitWidth)
        ..lineTo(
            24 * unitWidth +
                math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2 * unitWidth,
            2.5 * unitHeight +
                math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2 * unitWidth)
        ..lineTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
        ..lineTo((22 + 2 / 3 - 1 / 4) * unitWidth, 8 * unitHeight)
        ..lineTo((17 + 2 / 3) * unitWidth, 8 * unitHeight)
        ..lineTo(19.5 * unitWidth, 2.5 * unitHeight),
      // "12A-93": Path()
      //   ..moveTo((22 + 5 / 12) * unitWidth, 8 * unitHeight) // G
      //   ..lineTo(
      //       (22 + 5 / 12) * unitWidth +
      //           math.cos(0.5 * math.pi - trickyAngle) *
      //               (2 * unitWidth / math.cos(trickyAngle - angleOfWalls)),
      //       8 * unitHeight -
      //           math.sin(0.5 * math.pi - trickyAngle) *
      //               (2 * unitWidth / math.cos(trickyAngle - angleOfWalls)))
      //   ..lineTo(
      //       (22 + 5 / 12) * unitWidth +
      //           math.sin(angleOfWalls) * 2 * unitWidth -
      //           math.cos(angleOfWalls) * unitHeight,
      //       8 * unitHeight -
      //           math.cos(angleOfWalls) * 2 * unitWidth -
      //           math.sin(angleOfWalls) * unitHeight) // H
      //   ..lineTo(
      //       (22 + 5 / 12) * unitWidth +
      //           math.sin(angleOfWalls) * 2 * unitWidth -
      //           math.cos(angleOfWalls) * unitHeight +
      //           math.sin(angleOfWalls) * 1.1 * unitWidth,
      //       8 * unitHeight -
      //           math.cos(angleOfWalls) * 2 * unitWidth -
      //           math.sin(angleOfWalls) * unitHeight -
      //           math.cos(angleOfWalls) * 1.1 * unitWidth) // K
      //   ..lineTo(19 * unitWidth - math.sin(angleOfWalls) * 2 * unitWidth,
      //       4 * unitHeight + math.cos(angleOfWalls) * 2 * unitWidth)
      //   ..lineTo((17 + 2 / 3) * unitWidth, 8 * unitHeight)
      //   ..lineTo(
      //       (22 + 5 / 12) * unitWidth - unitHeight / math.cos(angleOfWalls),
      //       8 * unitHeight) // I
      //   ..lineTo((22 + 5 / 12) * unitWidth, 8 * unitHeight), //D
    });
    return rooms;
  }

  static Path getFloor12InnerWalls(
    double unitWidth,
    double unitHeight,
    double angleOfWalls,
  ) {
    return Path()
      //middle-left wall
      ..moveTo(7 * unitWidth, 1.5 * unitHeight + 2.0)
      ..lineTo(7 * unitWidth, 2.5 * unitHeight)
      //middle-right wall
      ..moveTo(11 * unitWidth, 1.5 * unitHeight + 2.0)
      ..lineTo(11 * unitWidth, 4 * unitHeight)
      //topleft
      ..moveTo(7 * unitWidth, 3.5 * unitHeight)
      ..lineTo(7.7 * unitWidth, 3.5 * unitHeight)
      ..lineTo(7.7 * unitWidth, 2.5 * unitHeight)
      ..lineTo(2.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(2.5 * unitWidth, 3.5 * unitHeight)
      ..lineTo(3.2 * unitWidth, 3.5 * unitHeight)
      ..lineTo(3.2 * unitWidth, 3.4 * unitHeight)
      ..lineTo(7 * unitWidth, 3.4 * unitHeight)
      ..lineTo(7 * unitWidth, 3.5 * unitHeight)
      //bottomleft
      ..moveTo(3.2 * unitWidth, 4 * unitHeight)
      ..lineTo(2.7 * unitWidth, 4 * unitHeight)
      ..lineTo(2.7 * unitWidth, 4.75 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4.75 * unitHeight)
      ..lineTo(3.2 * unitWidth, 5.5 * unitHeight)
      ..lineTo(7 * unitWidth, 5.5 * unitHeight)
      ..lineTo(7 * unitWidth, 4.2 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4.2 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4 * unitHeight)
      //right
      ..moveTo(19.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(19.5 * unitWidth + math.tan(angleOfWalls) * unitHeight,
          1.5 * unitHeight)
      ..lineTo(22 * unitWidth + math.tan(angleOfWalls) * unitHeight,
          1.5 * unitHeight)
      ..lineTo(22 * unitWidth, 2.5 * unitHeight)
      ..lineTo(19.5 * unitWidth, 2.5 * unitHeight);
  }

  // Equal for all floors
  static Path getOutterWalls(
    double unitWidth,
    double unitHeight,
  ) {
    return Path()
      ..moveTo(0.0, 0.0) //topleft
      ..lineTo(0.0, 8 * unitHeight) //bottomleft
      ..lineTo(7 * unitWidth, 8 * unitHeight) //bottom left-mid
      ..lineTo(7 * unitWidth, 4 * unitHeight) //top left-mid
      ..lineTo(19 * unitWidth, 4 * unitHeight) //top right-mid
      ..lineTo((17 + 2 / 3) * unitWidth, 8 * unitHeight) //bottom right-mid
      ..lineTo((22 + 2 / 3 - 1 / 4) * unitWidth,
          8 * unitHeight) //bottom right-corner
      ..lineTo((24 + 2 / 3) * unitWidth, 6 * unitHeight) //side right-corner
      ..lineTo((26 + 3 / 4) * unitWidth, 0.0) //topright
      ..lineTo(0.0, 0.0); //topleft
  }
}
