import "dart:typed_data";

import "package:flexwork/admin/newSpace/newSpace.dart";
import "package:flexwork/models/newReservationNotifier.dart";
import "package:flutter/material.dart";
import '../helpers/floorSketcher.dart';
import "../models/floors.dart";
import "dart:math" as math;
import '../models/newSpaceNotifier.dart';
import "package:provider/provider.dart";

// ------------ INFO ---------------
// The Canvas width takes up the full available area minus the padding
// The Canvas height takes up 12/27 of the width
// Rooms are 1/27 wide of the Canvas width
// Rooms are 1.5/27 high of the Canvas width
// Pixels are 1/(27*12) wide of the Canvas width
// ---------------------------------

class AdminFloor extends StatelessWidget {
  final Floors floor;
  final bool isValid;

  const AdminFloor({
    required this.isValid,
    required this.floor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final newSpaceNotifier = Provider.of<NewSpaceNotifier>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final canvasHeigt = canvasWidth / 27 * 12;
        final angleOfWalls = math.atan(4 / 18);
        final pixelSize = canvasWidth / (27 * 12);
        final matrix = Matrix4.identity()..scale(pixelSize, pixelSize);
        final scale = matrix.storage;

        Path outterWalls = FloorSketcher.getOutterWalls();
        Path innerWalls;
        if (floor == Floors.f9) {
          innerWalls = FloorSketcher.getFloor9InnerWalls();
        } else if (floor == Floors.f10) {
          innerWalls = FloorSketcher.getFloor10InnerWalls();
        } else if (floor == Floors.f11) {
          innerWalls = FloorSketcher.getFloor11InnerWalls();
        } else {
          innerWalls = FloorSketcher.getFloor12InnerWalls();
        }

        final scaledInnerWalls = innerWalls.transform(scale);
        final scaledOutterWalls = outterWalls.transform(scale);
        final scaledNewSpace = newSpaceNotifier.getPath().transform(scale);

        return CustomPaint(
          size: Size(canvasWidth, canvasHeigt),
          painter: _FloorPainter(pixelSize, angleOfWalls, scaledInnerWalls,
              scaledOutterWalls, scaledNewSpace, isValid),
        );
      }),
    );
  }
}

class _FloorPainter extends CustomPainter {
  double pixelSize;
  double angleOfWalls;
  Path innerWalls;
  Path outterWalls;
  Path newSpace;
  bool newSpaceIsValid;

  _FloorPainter(
    this.pixelSize,
    this.angleOfWalls,
    this.innerWalls,
    this.outterWalls,
    this.newSpace,
    this.newSpaceIsValid,
  );

  @override
  void paint(Canvas canvas, Size size) {
    Paint newSpacePaint = Paint()
      ..color = newSpaceIsValid
          ? Color.fromARGB(255, 134, 159, 249)
          : Color.fromARGB(255, 239, 141, 141)
      ..style = PaintingStyle.fill;

    Paint defaultPaint = Paint()
      ..color = Color.fromARGB(255, 135, 235, 151)
      ..style = PaintingStyle.fill;

    canvas.drawPath(
      newSpace,
      newSpacePaint,
    );

    canvas.drawPath(
      innerWalls,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawPath(
      outterWalls,
      Paint()
        ..color = Colors.black
        ..strokeWidth = 5.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
