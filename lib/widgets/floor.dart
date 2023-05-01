import "package:flexwork/models/newReservationNotifier.dart";
import "package:flutter/material.dart";
import "../models/floorSketcher.dart";
import "../models/floors.dart";
import "dart:math" as math;

// ------------ INFO ---------------
// The Canvas width takes up the full available area minus the padding
// The Canvas height takes up 12/27 of the width
// Rooms are 1/27 wide of the Canvas width
// Rooms are 1.5/27 high of the Canvas width
// ---------------------------------

class Floor extends StatelessWidget {
  final String? selectedRoom;
  final Floors floor;
  final NewReservationNotifier newReservationNotifier;

  const Floor(
      {required this.newReservationNotifier,
      required this.floor,
      this.selectedRoom,
      super.key});

  void _handleRoomTap(
      double unitWidth,
      double unitHeight,
      double angleOfWalls,
      Offset tapOffset,
      NewReservationNotifier newReservationNotifier,
      Map<String, Path> rooms) {
    var roomWasTapped = false;

    rooms.forEach((roomCode, path) {
      if (path.contains(tapOffset)) {
        roomWasTapped = true;
        print("pressed room number $roomCode");
        newReservationNotifier.setRoomNumber(roomCode);
      }
    });
    if (!roomWasTapped) {
      newReservationNotifier.setRoomNumber(null);
    }
  }

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

        Map<String, Path> rooms;
        Path innerWalls;
        if (floor == Floors.f9) {
          rooms =
              FloorSketcher.getFloor9Rooms(unitWidth, unitHeight, angleOfWalls);
          innerWalls = FloorSketcher.getFloor9InnerWalls(
              unitWidth, unitHeight, angleOfWalls);
        } else if (floor == Floors.f10) {
          rooms = FloorSketcher.getFloor10Rooms(
              unitWidth, unitHeight, angleOfWalls);
          innerWalls = FloorSketcher.getFloor10InnerWalls(
              unitWidth, unitHeight, angleOfWalls);
        } else if (floor == Floors.f11) {
          rooms = FloorSketcher.getFloor11Rooms(
              unitWidth, unitHeight, angleOfWalls);
          innerWalls = FloorSketcher.getFloor11InnerWalls(
              unitWidth, unitHeight, angleOfWalls);
        } else {
          rooms = FloorSketcher.getFloor12Rooms(
              unitWidth, unitHeight, angleOfWalls);
          innerWalls = FloorSketcher.getFloor12InnerWalls(
              unitWidth, unitHeight, angleOfWalls);
        }

        return GestureDetector(
          onTapUp: (details) => _handleRoomTap(unitWidth, unitHeight,
              angleOfWalls, details.localPosition, newReservationNotifier, rooms),
          child: CustomPaint(
            size: Size(canvasWidth, canvasHeigt),
            painter: FloorPainter(
                unitWidth, unitHeight, angleOfWalls, selectedRoom, rooms, innerWalls),
          ),
        );
      }),
    );
  }
}

class FloorPainter extends CustomPainter {
  double unitWidth;
  double unitHeight;
  double angleOfWalls;
  String? selectedRoom;
  Map<String, Path> rooms;
  Path innerWalls;

  FloorPainter(this.unitWidth, this.unitHeight, this.angleOfWalls,
      this.selectedRoom, this.rooms, this.innerWalls);

  @override
  void paint(Canvas canvas, Size size) {
    Paint selectedPaint = Paint()
      ..color = Color.fromARGB(255, 134, 159, 249)
      ..style = PaintingStyle.fill;

    Paint defaultPaint = Paint()
      ..color = Color.fromARGB(255, 135, 235, 151)
      ..style = PaintingStyle.fill;

    rooms.forEach((roomCode, path) {
      if (roomCode == selectedRoom) {
        canvas.drawPath(path, selectedPaint);
      } else {
        canvas.drawPath(path, defaultPaint);
      }
    });

    canvas.drawPath(
      innerWalls,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square,
    );

    canvas.drawPath(
      FloorSketcher.getOutterWalls(unitWidth, unitHeight),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 5.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.square,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
