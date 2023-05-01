import "package:flexwork/models/newReservationNotifier.dart";
import "package:flutter/material.dart";
import "../models/floorSketcher.dart";
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

  FloorSketcher.getFloor9Rooms(unitWidth, unitHeight, angleOfWalls)
      .forEach((roomCode, path) {
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

class Floor9Painter extends CustomPainter {
  double unitWidth;
  double unitHeight;
  double angleOfWalls;
  String? selectedRoom;

  Floor9Painter(
      this.unitWidth, this.unitHeight, this.angleOfWalls, this.selectedRoom);

  @override
  void paint(Canvas canvas, Size size) {
    Paint selectedPaint = Paint()
      ..color = Color.fromARGB(255, 134, 159, 249)
      ..style = PaintingStyle.fill;

    Paint defaultPaint = Paint()
      ..color = Color.fromARGB(255, 135, 235, 151)
      ..style = PaintingStyle.fill;

    FloorSketcher.getFloor9Rooms(unitWidth, unitHeight, angleOfWalls)
        .forEach((roomCode, path) {
      print("$roomCode == $selectedRoom: ${roomCode == selectedRoom}");
      if (roomCode == selectedRoom) {
        canvas.drawPath(path, selectedPaint);
      } else {
        canvas.drawPath(path, defaultPaint);
      }
    });

    canvas.drawPath(
      FloorSketcher.getOutterWalls(unitWidth, unitHeight, canvas),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 5.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square,
    );
    canvas.drawPath(
      FloorSketcher.getFloor9InnerWalls(
          unitWidth, unitHeight, angleOfWalls, canvas),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
