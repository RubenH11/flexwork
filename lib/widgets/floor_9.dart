import "package:flexwork/models/newReservationNotifier.dart";
import "package:flutter/material.dart";
import "dart:math" as math;

// ------------ INFO ---------------
// The Canvas width takes up the full available area minus the padding
// The Canvas height takes up 12/27 of the width
// Rooms are 1/27 wide of the Canvas width
// Rooms are 1.5/27 high of the Canvas width
// ---------------------------------

class Floor9 extends StatelessWidget {
  final String? selectedRoom;
  final NewReservationNotifier newReservationNotifier;
  const Floor9(
      {required this.newReservationNotifier, this.selectedRoom, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final canvasHeigt = canvasWidth / 27 * 12;
        final angleOfWalls = math.atan(4 / 18);
        final unitWidth = canvasWidth / 27;
        final unitHeight = unitWidth * 1.5;

        return GestureDetector(
          onTapUp: (details) => _handleRoomTap(unitWidth, unitHeight,
              angleOfWalls, details.localPosition, newReservationNotifier),
          child: CustomPaint(
            size: Size(canvasWidth, canvasHeigt),
            painter: Floor9Painter(
                unitWidth, unitHeight, angleOfWalls, selectedRoom),
          ),
        );
      }),
    );
  }
}

void _handleRoomTap(double unitWidth, double unitHeight, double angleOfWalls,
    Offset tapOffset, NewReservationNotifier newReservationNotifier) {
  var roomWasTapped = false;

  getRooms(unitWidth, unitHeight, angleOfWalls).forEach((roomCode, path) {
    if (path.contains(tapOffset)) {
      roomWasTapped = true;
      print("pressed room number $roomCode");
      newReservationNotifier.setRoomNumber(roomCode);
      print("which is set: ${newReservationNotifier.getRoomNumber()}");
    }
  });
  if (!roomWasTapped) {
    newReservationNotifier.setRoomNumber(null);
  }
}

Map<String, Path> getRooms(
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
      ..addRect(Rect.fromLTWH(wall + 0.0, 2 * unitHeight,
          wall + unitWidth * 0.5 + roomUnitWidth, unitHeight + roomUnitHeight)),
    "09A-07": Path()
      ..addRect(Rect.fromLTWH(wall + 0.0, 4 * unitHeight,
          wall + unitWidth * 0.5 + roomUnitWidth, unitHeight + roomUnitHeight)),
    "09A-01": Path()
      ..addRect(Rect.fromLTWH(wall + 0.0, 6 * unitHeight,
          wall + unitWidth * 0.5 + roomUnitWidth, unitHeight + roomUnitHeight))
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
      ..lineTo(xOffset1 + (24 + 2 / 3) * unitWidth, yOffset1 + 6 * unitHeight),
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
      ..lineTo(xOffset2 + (24 + 2 / 3) * unitWidth, yOffset2 + 6 * unitHeight),
    //tricky room
    "09A-93": Path()
      ..moveTo((22 + 2 / 3 - 1 / 4) * unitWidth, 8 * unitHeight)
      ..lineTo(wall + 21 * unitWidth, 8 * unitHeight)
      ..lineTo(
          wall +
              21 * unitWidth +
              (math.sin(angleOfWalls) *
                  ((245 / 12) * math.sin(angleOfWalls) + 2 * unitWidth)),
          8 * unitHeight -
              (math.cos(angleOfWalls) *
                  ((245 / 12) * math.sin(angleOfWalls) + 2 * unitWidth)))
      ..lineTo(
          (22 + 2 / 3 - 1 / 4) * unitWidth +
              math.cos(math.pi / 2 - trickyAngle) *
                  math.cos(trickyAngle - angleOfWalls) *
                  2.25 *
                  unitWidth,
          8 * unitHeight -
              math.sin(math.pi / 2 - trickyAngle) *
                  math.cos(trickyAngle - angleOfWalls) *
                  2.25 *
                  unitWidth)
      ..moveTo((22 + 2 / 3 - 1 / 4) * unitWidth, 8 * unitHeight)
  });
  return rooms;
}

void drawOutterWalls(
  double unitWidth,
  double unitHeight,
  Canvas canvas,
) {
  final wallPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 5.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.square;

  Path wallPath = Path()
    ..moveTo(0.0, 0.0) //topleft
    ..lineTo(0.0, 8 * unitHeight) //bottomleft
    ..lineTo(7 * unitWidth, 8 * unitHeight) //bottom left-mid
    ..lineTo(7 * unitWidth, 4 * unitHeight) //top left-mid
    ..lineTo(19 * unitWidth, 4 * unitHeight) //top right-mid
    ..lineTo((17 + 2 / 3) * unitWidth, 8 * unitHeight) //bottom right-mid
    ..lineTo(
        (22 + 2 / 3 - 1 / 4) * unitWidth, 8 * unitHeight) //bottom right-corner
    ..lineTo((24 + 2 / 3) * unitWidth, 6 * unitHeight) //side right-corner
    ..lineTo((26 + 3 / 4) * unitWidth, 0.0) //topright
    ..lineTo(0.0, 0.0); //topleft

  canvas.drawPath(wallPath, wallPaint);
}

void drawInnerWalls(
  double unitWidth,
  double unitHeight,
  double angleOfWalls,
  Canvas canvas,
) {
  final innerWallPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.square;

  Path innerWallPath = Path()
    ..moveTo(7 * unitWidth, 4 * unitHeight)
    ..lineTo(7 * unitWidth, 3.5 * unitHeight)
    ..lineTo(7.7 * unitWidth, 3.5 * unitHeight)
    ..lineTo(7.7 * unitWidth, 2.5 * unitHeight)
    ..lineTo(2.5 * unitWidth, 2.5 * unitHeight)
    ..lineTo(2.5 * unitWidth, 5.5 * unitHeight)
    ..lineTo(7 * unitWidth, 5.5 * unitHeight)
    ..lineTo(7 * unitWidth, 4 * unitHeight)
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
            math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
            math.cos(angleOfWalls) * unitHeight,
        4 * unitHeight +
            math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
            math.sin(angleOfWalls) * unitHeight)
    ..lineTo(
        19 * unitWidth +
            math.cos(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
            math.cos(angleOfWalls) * unitHeight -
            math.sin(angleOfWalls) * 2 * unitWidth,
        4 * unitHeight +
            math.sin(angleOfWalls) * math.cos(angleOfWalls) * 2.5 * unitWidth +
            math.sin(angleOfWalls) * unitHeight +
            math.cos(angleOfWalls) * 2 * unitWidth)
    ..lineTo(19 * unitWidth - math.sin(angleOfWalls) * 2 * unitWidth,
        4 * unitHeight + math.cos(angleOfWalls) * 2 * unitWidth)
    ..lineTo(19 * unitWidth, 4 * unitHeight);

  canvas.drawPath(innerWallPath, innerWallPaint);
}

class Floor9Painter extends CustomPainter {
  double unitWidth;
  double unitHeight;
  double angleOfWalls;
  String? selectedRoom;

  Floor9Painter(
      this.unitWidth, this.unitHeight, this.angleOfWalls, this.selectedRoom);

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.drawPath(sketchRooms(unitWidth, unitHeight, angleOfWalls, canvas), paint),
    Paint selectedPaint = Paint()
      ..color = Color.fromARGB(255, 134, 159, 249)
      ..style = PaintingStyle.fill;

    Paint defaultPaint = Paint()
      ..color = Color.fromARGB(255, 135, 235, 151)
      ..style = PaintingStyle.fill;

    getRooms(unitWidth, unitHeight, angleOfWalls).forEach((roomCode, path) {
      print("$roomCode == $selectedRoom: ${roomCode == selectedRoom}");
      if (roomCode == selectedRoom) {
        canvas.drawPath(path, selectedPaint);
      } else {
        canvas.drawPath(path, defaultPaint);
      }
    });

    //drawRooms(unitWidth, unitHeight, angleOfWalls, canvas);
    drawOutterWalls(unitWidth, unitHeight, canvas);
    drawInnerWalls(unitWidth, unitHeight, angleOfWalls, canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
