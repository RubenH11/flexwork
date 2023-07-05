import "package:flutter/material.dart";
import "dart:math" as math;

class FloorSketcher {
  static const unitWidth = 12.0;
  static const unitHeight = 18.0;
  static final angleOfWalls = math.atan(2 / 9);
  static final secondaryAngleOfWalls = math.atan(0.75);

  static Path getFloor9InnerWalls() {
    final xOffset1 = math.sin(angleOfWalls) * unitWidth;
    final yOffset1 = -math.cos(angleOfWalls) * unitWidth;
    final xOffset2 = math.sin(angleOfWalls) * 2 * unitWidth;
    final yOffset2 = -math.cos(angleOfWalls) * 2 * unitWidth;
    return Path()
      //SECTIONS
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
      ..lineTo(19 * unitWidth, 4 * unitHeight)

      //ROOM WALLS
      //top row
      ..moveTo(2 * unitWidth, 0)
      ..lineTo(2 * unitWidth, unitHeight)
      ..lineTo(24 * unitWidth, unitHeight)
      ..lineTo(24 * unitWidth, 0)
      ..moveTo(3 * unitWidth, 0)
      ..lineTo(3 * unitWidth, unitHeight)
      ..moveTo(4 * unitWidth, 0)
      ..lineTo(4 * unitWidth, unitHeight)
      ..moveTo(5 * unitWidth, 0)
      ..lineTo(5 * unitWidth, unitHeight)
      ..moveTo(6 * unitWidth, 0)
      ..lineTo(6 * unitWidth, unitHeight)
      ..moveTo(7 * unitWidth, 0)
      ..lineTo(7 * unitWidth, unitHeight)
      ..moveTo(9 * unitWidth, 0)
      ..lineTo(9 * unitWidth, unitHeight)
      ..moveTo(10 * unitWidth, 0)
      ..lineTo(10 * unitWidth, unitHeight)
      ..moveTo(12 * unitWidth, 0)
      ..lineTo(12 * unitWidth, unitHeight)
      ..moveTo(14 * unitWidth, 0)
      ..lineTo(14 * unitWidth, unitHeight)
      ..moveTo(16 * unitWidth, 0)
      ..lineTo(16 * unitWidth, unitHeight)
      ..moveTo(17 * unitWidth, 0)
      ..lineTo(17 * unitWidth, unitHeight)
      ..moveTo(18 * unitWidth, 0)
      ..lineTo(18 * unitWidth, unitHeight)
      ..moveTo(19 * unitWidth, 0)
      ..lineTo(19 * unitWidth, unitHeight)
      ..moveTo(20 * unitWidth, 0)
      ..lineTo(20 * unitWidth, unitHeight)
      ..moveTo(21 * unitWidth, 0)
      ..lineTo(21 * unitWidth, unitHeight)
      ..moveTo(22 * unitWidth, 0)
      ..lineTo(22 * unitWidth, unitHeight)
      ..moveTo(23 * unitWidth, 0)
      ..lineTo(23 * unitWidth, unitHeight)
      ..moveTo(24 * unitWidth, 0)
      ..lineTo(24 * unitWidth, unitHeight)
      //left column
      ..moveTo(0, 3 * unitWidth)
      ..lineTo(unitHeight, 3 * unitWidth)
      ..lineTo(unitHeight, 10 * unitWidth)
      ..lineTo(2 * unitHeight, 10 * unitWidth)
      ..lineTo(2 * unitHeight, 12 * unitWidth)
      ..moveTo(0, 6 * unitWidth)
      ..lineTo(unitHeight, 6 * unitWidth)
      ..moveTo(0, 9 * unitWidth)
      ..lineTo(unitHeight, 9 * unitWidth)
      //single office
      ..moveTo(3 * unitWidth, 1.5 * unitHeight)
      ..lineTo(4 * unitWidth, 1.5 * unitHeight)
      ..lineTo(4 * unitWidth, 2.5 * unitHeight)
      ..lineTo(3 * unitWidth, 2.5 * unitHeight)
      ..lineTo(3 * unitWidth, 1.5 * unitHeight)
      //middle
      ..moveTo(11 * unitWidth, 1.5 * unitHeight)
      ..lineTo(14 * unitWidth, 1.5 * unitHeight)
      ..lineTo(14 * unitWidth, 4 * unitHeight)
      ..lineTo(11 * unitWidth, 4 * unitHeight)
      ..lineTo(11 * unitWidth, 1.5 * unitHeight)
      ..moveTo(15 * unitWidth, 2.5 * unitHeight)
      ..lineTo(16 * unitWidth, 2.5 * unitHeight)
      ..moveTo(15 * unitWidth, 2.5 * unitHeight)
      ..lineTo(15 * unitWidth, 1.5 * unitHeight)
      ..lineTo(16 * unitWidth, 1.5 * unitHeight)
      ..moveTo(16 * unitWidth, 2.5 * unitHeight)
      ..lineTo(16 * unitWidth, 1.5 * unitHeight)
      ..lineTo(18 * unitWidth, 1.5 * unitHeight)
      ..lineTo(18 * unitWidth, 2.5 * unitHeight)
      ..moveTo(16 * unitWidth, 2.5 * unitHeight)
      ..lineTo(18 * unitWidth, 2.5 * unitHeight)
      ..lineTo(18 * unitWidth, 4 * unitHeight)
      ..lineTo(16 * unitWidth, 4 * unitHeight)
      ..lineTo(16 * unitWidth, 2.5 * unitHeight)
      //right-mid
      ..moveTo(22 * unitWidth, 2.5 * unitHeight)
      ..lineTo(20.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(20.5 * unitWidth, 1.5 * unitHeight)
      ..lineTo(22 * unitWidth, 1.5 * unitHeight)
      ..lineTo(22 * unitWidth, 2.5 * unitHeight)
      //right column
      ..moveTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
      ..lineTo((24 + 2 / 3) * unitWidth - math.cos(angleOfWalls) * unitHeight,
          6 * unitHeight - math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * unitWidth,
          6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * unitWidth)
      ..lineTo((24 + 2 / 3) * unitWidth + math.sin(angleOfWalls) * unitWidth,
          6 * unitHeight - math.cos(angleOfWalls) * unitWidth)
      ..lineTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
      ..moveTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight)
      ..lineTo(
          xOffset1 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight,
          yOffset1 + 6 * unitHeight - math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          xOffset1 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * unitWidth,
          yOffset1 +
              6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * unitWidth)
      ..lineTo(
          xOffset1 +
              (24 + 2 / 3) * unitWidth +
              math.sin(angleOfWalls) * unitWidth,
          yOffset1 + 6 * unitHeight - math.cos(angleOfWalls) * unitWidth)
      ..lineTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight)
      ..moveTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight)
      ..lineTo(
          xOffset2 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight,
          yOffset2 + 6 * unitHeight - math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          xOffset2 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * (unitWidth + unitWidth),
          yOffset2 +
              6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * (unitWidth + unitWidth))
      ..lineTo(
          xOffset2 +
              (24 + 2 / 3) * unitWidth +
              math.sin(angleOfWalls) * (unitWidth + unitWidth),
          yOffset2 +
              6 * unitHeight -
              math.cos(angleOfWalls) * (unitWidth + unitWidth))
      ..lineTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight)
      //tricky room
      ..moveTo(
          (22 + 5 / 12) * unitWidth +
              math.cos(0.5 * math.pi - secondaryAngleOfWalls) *
                  (2 *
                      unitWidth /
                      math.cos(secondaryAngleOfWalls - angleOfWalls)),
          8 * unitHeight -
              math.sin(0.5 * math.pi - secondaryAngleOfWalls) *
                  (2 *
                      unitWidth /
                      math.cos(secondaryAngleOfWalls - angleOfWalls)))
      ..lineTo(
          (22 + 5 / 12) * unitWidth +
              math.sin(angleOfWalls) * 2 * unitWidth -
              math.cos(angleOfWalls) * unitHeight,
          8 * unitHeight -
              math.cos(angleOfWalls) * 2 * unitWidth -
              math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          (22 + 5 / 12) * unitWidth +
              math.sin(angleOfWalls) * 2 * unitWidth -
              math.cos(angleOfWalls) * unitHeight -
              math.sin(angleOfWalls) *
                  (2 * unitWidth + 1.5 * unitWidth * math.tan(angleOfWalls)),
          8 * unitHeight -
              math.cos(angleOfWalls) * 2 * unitWidth -
              math.sin(angleOfWalls) * unitHeight +
              math.cos(angleOfWalls) *
                  (2 * unitWidth + 1.5 * unitWidth * math.tan(angleOfWalls)));
  }

  static Path getFloor10InnerWalls() {
    final xOffset1 = math.sin(angleOfWalls) * unitWidth;
    final yOffset1 = -math.cos(angleOfWalls) * unitWidth;
    final xOffset2 = math.sin(angleOfWalls) * 2 * unitWidth;
    final yOffset2 = -math.cos(angleOfWalls) * 2 * unitWidth;
    return Path()
      //SECTIONS
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
      ..lineTo(19 * unitWidth, 4 * unitHeight)

      //ROOM WALLS
      //top row
      ..moveTo(2 * unitWidth, 0)
      ..lineTo(2 * unitWidth, unitHeight)
      ..lineTo(24 * unitWidth, unitHeight)
      ..lineTo(24 * unitWidth, 0)
      ..moveTo(3 * unitWidth, 0)
      ..lineTo(3 * unitWidth, unitHeight)
      ..moveTo(4 * unitWidth, 0)
      ..lineTo(4 * unitWidth, unitHeight)
      ..moveTo(5 * unitWidth, 0)
      ..lineTo(5 * unitWidth, unitHeight)
      ..moveTo(7 * unitWidth, 0)
      ..lineTo(7 * unitWidth, unitHeight)
      ..moveTo(10 * unitWidth, 0)
      ..lineTo(10 * unitWidth, unitHeight)
      ..moveTo(12 * unitWidth, 0)
      ..lineTo(12 * unitWidth, unitHeight)
      ..moveTo(13 * unitWidth, 0)
      ..lineTo(13 * unitWidth, unitHeight)
      ..moveTo(14 * unitWidth, 0)
      ..lineTo(14 * unitWidth, unitHeight)
      ..moveTo(16 * unitWidth, 0)
      ..lineTo(16 * unitWidth, unitHeight)
      ..moveTo(17 * unitWidth, 0)
      ..lineTo(17 * unitWidth, unitHeight)
      ..moveTo(19 * unitWidth, 0)
      ..lineTo(19 * unitWidth, unitHeight)
      ..moveTo(21 * unitWidth, 0)
      ..lineTo(21 * unitWidth, unitHeight)
      ..moveTo(23 * unitWidth, 0)
      ..lineTo(23 * unitWidth, unitHeight)
      ..moveTo(24 * unitWidth, 0)
      ..lineTo(24 * unitWidth, unitHeight)
      //left column
      ..moveTo(0, 3 * unitWidth)
      ..lineTo(unitHeight, 3 * unitWidth)
      ..lineTo(unitHeight, 10 * unitWidth)
      ..lineTo(2 * unitHeight, 10 * unitWidth)
      ..lineTo(2 * unitHeight, 12 * unitWidth)
      ..moveTo(0, 6 * unitWidth)
      ..lineTo(unitHeight, 6 * unitWidth)
      ..moveTo(0, 9 * unitWidth)
      ..lineTo(unitHeight, 9 * unitWidth)
      //single office
      ..moveTo(3 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(4 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(4 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(3 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(3 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      //middle
      ..moveTo(11 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(11 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(11 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..moveTo(11 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 4 * unitHeight)
      ..lineTo(11 * unitWidth, 4 * unitHeight)
      ..lineTo(11 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..moveTo(13 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(15 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(15 * unitWidth, 4 * unitHeight)
      ..lineTo(13 * unitWidth, 4 * unitHeight)
      ..lineTo(13 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..moveTo(15 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 4 * unitHeight)
      ..lineTo(15 * unitWidth, 4 * unitHeight)
      ..lineTo(15 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..moveTo(15 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(15 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(15 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..moveTo(16 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      //right-mid
      ..moveTo(22 * unitWidth, 2.5 * unitHeight)
      ..lineTo(20.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(20.5 * unitWidth, 1.5 * unitHeight)
      ..lineTo(22 * unitWidth, 1.5 * unitHeight)
      ..lineTo(22 * unitWidth, 2.5 * unitHeight)
      //right column
      ..moveTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
      ..lineTo((24 + 2 / 3) * unitWidth - math.cos(angleOfWalls) * unitHeight,
          6 * unitHeight - math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * unitWidth,
          6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * unitWidth)
      ..lineTo((24 + 2 / 3) * unitWidth + math.sin(angleOfWalls) * unitWidth,
          6 * unitHeight - math.cos(angleOfWalls) * unitWidth)
      ..lineTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
      ..moveTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight)
      ..lineTo(
          xOffset1 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight,
          yOffset1 + 6 * unitHeight - math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          xOffset1 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * unitWidth,
          yOffset1 +
              6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * unitWidth)
      ..lineTo(
          xOffset1 +
              (24 + 2 / 3) * unitWidth +
              math.sin(angleOfWalls) * unitWidth,
          yOffset1 + 6 * unitHeight - math.cos(angleOfWalls) * unitWidth)
      ..lineTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight)
      ..moveTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight)
      ..lineTo(
          xOffset2 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight,
          yOffset2 + 6 * unitHeight - math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          xOffset2 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * (unitWidth + unitWidth),
          yOffset2 +
              6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * (unitWidth + unitWidth))
      ..lineTo(
          xOffset2 +
              (24 + 2 / 3) * unitWidth +
              math.sin(angleOfWalls) * (unitWidth + unitWidth),
          yOffset2 +
              6 * unitHeight -
              math.cos(angleOfWalls) * (unitWidth + unitWidth))
      ..lineTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight)
      //tricky room
      ..moveTo(
          (22 + 5 / 12) * unitWidth +
              math.cos(0.5 * math.pi - secondaryAngleOfWalls) *
                  (2 *
                      unitWidth /
                      math.cos(secondaryAngleOfWalls - angleOfWalls)),
          8 * unitHeight -
              math.sin(0.5 * math.pi - secondaryAngleOfWalls) *
                  (2 *
                      unitWidth /
                      math.cos(secondaryAngleOfWalls - angleOfWalls)))
      ..lineTo(
          (22 + 5 / 12) * unitWidth +
              math.sin(angleOfWalls) * 2 * unitWidth -
              math.cos(angleOfWalls) * unitHeight,
          8 * unitHeight -
              math.cos(angleOfWalls) * 2 * unitWidth -
              math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          (22 + 5 / 12) * unitWidth +
              math.sin(angleOfWalls) * 2 * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * 1.1 * unitWidth,
          8 * unitHeight -
              math.cos(angleOfWalls) * 2 * unitWidth -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * 1.1 * unitWidth);
  }

  static Path getFloor11InnerWalls() {
    final xOffset1 = math.sin(angleOfWalls) * unitWidth;
    final yOffset1 = -math.cos(angleOfWalls) * unitWidth;
    final xOffset2 = math.sin(angleOfWalls) * 2 * unitWidth;
    final yOffset2 = -math.cos(angleOfWalls) * 2 * unitWidth;
    return Path()
      //SECTIONS
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
      ..lineTo(19 * unitWidth, 4 * unitHeight)

      //ROOM WALLS
      //top row
      ..moveTo(2 * unitWidth, 0)
      ..lineTo(2 * unitWidth, unitHeight)
      ..lineTo(24 * unitWidth, unitHeight)
      ..lineTo(24 * unitWidth, 0)
      ..moveTo(3 * unitWidth, 0)
      ..lineTo(3 * unitWidth, unitHeight)
      ..moveTo(4 * unitWidth, 0)
      ..lineTo(4 * unitWidth, unitHeight)
      ..moveTo(5 * unitWidth, 0)
      ..lineTo(5 * unitWidth, unitHeight)
      ..moveTo(7 * unitWidth, 0)
      ..lineTo(7 * unitWidth, unitHeight)
      ..moveTo(10 * unitWidth, 0)
      ..lineTo(10 * unitWidth, unitHeight)
      ..moveTo(12 * unitWidth, 0)
      ..lineTo(12 * unitWidth, unitHeight)
      ..moveTo(13 * unitWidth, 0)
      ..lineTo(13 * unitWidth, unitHeight)
      ..moveTo(14 * unitWidth, 0)
      ..lineTo(14 * unitWidth, unitHeight)
      ..moveTo(16 * unitWidth, 0)
      ..lineTo(16 * unitWidth, unitHeight)
      ..moveTo(17 * unitWidth, 0)
      ..lineTo(17 * unitWidth, unitHeight)
      ..moveTo(19 * unitWidth, 0)
      ..lineTo(19 * unitWidth, unitHeight)
      ..moveTo(21 * unitWidth, 0)
      ..lineTo(21 * unitWidth, unitHeight)
      ..moveTo(23 * unitWidth, 0)
      ..lineTo(23 * unitWidth, unitHeight)
      ..moveTo(24 * unitWidth, 0)
      ..lineTo(24 * unitWidth, unitHeight)
      //left column
      ..moveTo(0, 3 * unitWidth)
      ..lineTo(unitHeight, 3 * unitWidth)
      ..lineTo(unitHeight, 10 * unitWidth)
      ..lineTo(2 * unitHeight, 10 * unitWidth)
      ..lineTo(2 * unitHeight, 12 * unitWidth)
      ..moveTo(0, 6 * unitWidth)
      ..lineTo(unitHeight, 6 * unitWidth)
      ..moveTo(0, 9 * unitWidth)
      ..lineTo(unitHeight, 9 * unitWidth)
      //single office
      ..moveTo(3 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(4 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(4 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(3 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(3 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      //middle
      ..moveTo(11 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(11 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(11 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..moveTo(11 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 4 * unitHeight)
      ..lineTo(11 * unitWidth, 4 * unitHeight)
      ..lineTo(11 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..moveTo(13 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(15 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(15 * unitWidth, 4 * unitHeight)
      ..lineTo(13 * unitWidth, 4 * unitHeight)
      ..lineTo(13 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..moveTo(15 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 4 * unitHeight)
      ..lineTo(15 * unitWidth, 4 * unitHeight)
      ..lineTo(15 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..moveTo(15 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(15 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(15 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..moveTo(16 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      //right-mid
      ..moveTo(22 * unitWidth, 2.5 * unitHeight)
      ..lineTo(20.5 * unitWidth, 2.5 * unitHeight)
      ..lineTo(20.5 * unitWidth, 1.5 * unitHeight)
      ..lineTo(22 * unitWidth, 1.5 * unitHeight)
      ..lineTo(22 * unitWidth, 2.5 * unitHeight)
      //right column
      ..moveTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
      ..lineTo((24 + 2 / 3) * unitWidth - math.cos(angleOfWalls) * unitHeight,
          6 * unitHeight - math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * unitWidth,
          6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * unitWidth)
      ..lineTo((24 + 2 / 3) * unitWidth + math.sin(angleOfWalls) * unitWidth,
          6 * unitHeight - math.cos(angleOfWalls) * unitWidth)
      ..lineTo((24 + 2 / 3) * unitWidth, 6 * unitHeight)
      ..moveTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight)
      ..lineTo(
          xOffset1 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight,
          yOffset1 + 6 * unitHeight - math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          xOffset1 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * unitWidth,
          yOffset1 +
              6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * unitWidth)
      ..lineTo(
          xOffset1 +
              (24 + 2 / 3) * unitWidth +
              math.sin(angleOfWalls) * unitWidth,
          yOffset1 + 6 * unitHeight - math.cos(angleOfWalls) * unitWidth)
      ..lineTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight)
      ..moveTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight)
      ..lineTo(
          xOffset2 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight,
          yOffset2 + 6 * unitHeight - math.sin(angleOfWalls) * unitHeight)
      ..lineTo(
          xOffset2 +
              (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight +
              math.sin(angleOfWalls) * (unitWidth + unitWidth),
          yOffset2 +
              6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight -
              math.cos(angleOfWalls) * (unitWidth + unitWidth))
      ..lineTo(
          xOffset2 +
              (24 + 2 / 3) * unitWidth +
              math.sin(angleOfWalls) * (unitWidth + unitWidth),
          yOffset2 +
              6 * unitHeight -
              math.cos(angleOfWalls) * (unitWidth + unitWidth))
      ..lineTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight)
      //tricky room
      ..moveTo(
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
      ..lineTo(
          (24 + 2 / 3) * unitWidth -
              math.cos(angleOfWalls) * unitHeight -
              math.sin(angleOfWalls) * 0.3 * unitWidth,
          6 * unitHeight -
              math.sin(angleOfWalls) * unitHeight +
              math.cos(angleOfWalls) * 0.3 * unitWidth)
      ..lineTo((24 + 2 / 3) * unitWidth - math.cos(angleOfWalls) * unitHeight,
          6 * unitHeight - math.sin(angleOfWalls) * unitHeight);
  }

  static Path getFloor12InnerWalls() {
    final xOffset1 = math.sin(angleOfWalls) * unitWidth;
    final yOffset1 = -math.cos(angleOfWalls) * unitWidth;
    final xOffset2 = math.sin(angleOfWalls) * 2 * unitWidth;
    final yOffset2 = -math.cos(angleOfWalls) * 2 * unitWidth;
    return Path()
      //SECTIONS
      //middle-left wall
      ..moveTo(7 * unitWidth, 1.5 * unitHeight)
      ..lineTo(7 * unitWidth, 2.5 * unitHeight)
      //moddle-right wall
      ..moveTo(11 * unitWidth, 1.5 * unitHeight)
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
      ..moveTo(0, 4 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4 * unitHeight)
      ..lineTo(3.2 * unitWidth, 4.2 * unitHeight)
      ..lineTo(7 * unitWidth, 4.2 * unitHeight)
      //right
      ..moveTo(19 * unitWidth, 4 * unitHeight)
      ..lineTo(19.5 * unitWidth + math.tan(angleOfWalls) * unitHeight,
          1.5 * unitHeight)
      ..lineTo(22 * unitWidth + math.tan(angleOfWalls) * unitHeight,
          1.5 * unitHeight)
      ..lineTo(
          22 * unitWidth +
              math.tan(angleOfWalls) * unitHeight -
              math.sin(angleOfWalls) * 0.5 * unitWidth,
          1.5 * unitHeight + math.cos(angleOfWalls) * 0.5 * unitWidth)
      ..lineTo(
          22 * unitWidth +
              math.tan(angleOfWalls) * unitHeight -
              math.sin(angleOfWalls) * 0.5 * unitWidth +
              math.cos(angleOfWalls) * 3.8 * unitWidth,
          1.5 * unitHeight +
              math.cos(angleOfWalls) * 0.5 * unitWidth +
              math.sin(angleOfWalls) * 3.8 * unitWidth)

      //ROOM WALLS
      //top row
      ..moveTo(2 * unitWidth, 0)
      ..lineTo(2 * unitWidth, unitHeight)
      ..lineTo(24 * unitWidth, unitHeight)
      ..lineTo(24 * unitWidth, 0)
      ..moveTo(3 * unitWidth, 0)
      ..lineTo(3 * unitWidth, unitHeight)
      ..moveTo(4 * unitWidth, 0)
      ..lineTo(4 * unitWidth, unitHeight)
      ..moveTo(5 * unitWidth, 0)
      ..lineTo(5 * unitWidth, unitHeight)
      ..moveTo(7 * unitWidth, 0)
      ..lineTo(7 * unitWidth, unitHeight)
      ..moveTo(10 * unitWidth, 0)
      ..lineTo(10 * unitWidth, unitHeight)
      ..moveTo(11 * unitWidth, 0)
      ..lineTo(11 * unitWidth, unitHeight)
      ..moveTo(12 * unitWidth, 0)
      ..lineTo(12 * unitWidth, unitHeight)
      ..moveTo(14 * unitWidth, 0)
      ..lineTo(14 * unitWidth, unitHeight)
      ..moveTo(16 * unitWidth, 0)
      ..lineTo(16 * unitWidth, unitHeight)
      ..moveTo(17 * unitWidth, 0)
      ..lineTo(17 * unitWidth, unitHeight)
      ..moveTo(18 * unitWidth, 0)
      ..lineTo(18 * unitWidth, unitHeight)
      ..moveTo(19 * unitWidth, 0)
      ..lineTo(19 * unitWidth, unitHeight)
      ..moveTo(21 * unitWidth, 0)
      ..lineTo(21 * unitWidth, unitHeight)
      ..moveTo(23 * unitWidth, 0)
      ..lineTo(23 * unitWidth, unitHeight)
      ..moveTo(24 * unitWidth, 0)
      ..lineTo(24 * unitWidth, unitHeight)
      //single office
      ..moveTo(3 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(4 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(4 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(3 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(3 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      //middle
      ..moveTo(11 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(13 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(11 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(11 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..moveTo(11 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(14 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(14 * unitWidth, 4 * unitHeight)
      ..lineTo(11 * unitWidth, 4 * unitHeight)
      ..lineTo(11 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..moveTo(14 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 4 * unitHeight)
      ..lineTo(14 * unitWidth, 4 * unitHeight)
      ..lineTo(14 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..moveTo(16 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(18 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(18 * unitWidth, 4 * unitHeight)
      ..lineTo(16 * unitWidth, 4 * unitHeight)
      ..lineTo(16 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..moveTo(16 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(16 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..moveTo(17 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(18 * unitWidth, 1 * unitHeight + 0.5 * unitHeight)
      ..lineTo(18 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 2 * unitHeight + 0.5 * unitHeight)
      ..lineTo(17 * unitWidth, 1 * unitHeight + 0.5 * unitHeight);
  }

  // Equal for all floors
  static Path getOutterWalls() {
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
