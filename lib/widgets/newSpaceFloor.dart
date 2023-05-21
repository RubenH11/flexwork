import "dart:typed_data";

import "../helpers/firebaseService.dart";
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

class NewSpaceFloor extends StatelessWidget {
  final bool isValid;
  const NewSpaceFloor({required this.isValid, super.key});

  @override
  Widget build(BuildContext context) {
    final newSpace = Provider.of<NewSpaceNotifier>(context, listen: false);
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final canvasHeight = canvasWidth / 27 * 12;
        // final angleOfWalls = math.atan(4 / 18);
        final pixelSize = canvasWidth / (27 * 12);
        final matrix = Matrix4.identity()..scale(pixelSize, pixelSize);
        final scale = matrix.storage;

        return Stack(
          children: [
            SizedBox(
              width: canvasWidth,
              height: canvasHeight,
              child: _Workspaces(
                  floor: newSpace.getFloor(),
                  canvasHeight: canvasHeight,
                  canvasWidth: canvasWidth,
                  scale: scale),
            ),
            SizedBox(
                width: canvasWidth,
                height: canvasHeight,
                child: _NewWorkSpace(
                  floor: newSpace.getFloor(),
                  canvasHeight: canvasHeight,
                  canvasWidth: canvasWidth,
                  isValid: isValid,
                  scale: scale,
                )),
            SizedBox(
              width: canvasWidth,
              height: canvasHeight,
              child: _Walls(
                floor: newSpace.getFloor(),
                scale: scale,
                canvasHeight: canvasHeight,
                canvasWidth: canvasWidth,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Workspaces extends StatelessWidget {
  final Floors floor;
  final Float64List scale;
  final double canvasHeight;
  final double canvasWidth;
  const _Workspaces({
    required this.floor,
    required this.scale,
    required this.canvasHeight,
    required this.canvasWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Path> workspaces = [];
    for (final workspace in FirebaseService().getWorkspaces(floor)) {
      // print("adding ${workspace.toString()} to list to draw");
      workspaces.add(workspace.getPath().transform(scale));
    }

    return CustomPaint(
      size: Size(canvasWidth, canvasHeight),
      painter: _Painter(
        Paint()
          ..color = Color.fromARGB(255, 135, 235, 151)
          ..strokeWidth = 3.0
          ..style = PaintingStyle.fill,
        workspaces,
      ),
    );
  }
}

class _NewWorkSpace extends StatelessWidget {
  final bool isValid;
  final Floors floor;
  final Float64List scale;
  final double canvasHeight;
  final double canvasWidth;
  const _NewWorkSpace({
    required this.floor,
    required this.isValid,
    required this.canvasHeight,
    required this.canvasWidth,
    required this.scale,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final newSpaceNotifier =
        Provider.of<NewSpaceNotifier>(context, listen: false);
    final newSpace = newSpaceNotifier.getPath();

    final pathMetric =
        newSpace.computeMetrics().elementAt(0);
    final lengthOfPath = pathMetric.length;
    final cornerPoint = pathMetric.getTangentForOffset(0)!.position;
    final cornerPoint2 = pathMetric.getTangentForOffset(lengthOfPath-2.5)!.position;
    final cornerPoint3 = pathMetric.getTangentForOffset(2.5)!.position;
    final cornerTriangle = Path()
      ..moveTo(cornerPoint.dx, cornerPoint.dy)
      ..lineTo(cornerPoint2.dx, cornerPoint2.dy)
      ..lineTo(cornerPoint3.dx, cornerPoint3.dy)
      ..close();

    final scaledCornerTriangle = cornerTriangle.transform(scale);
    final scaledNewSpace = newSpace.transform(scale);

    return Stack(children: [
      CustomPaint(
        size: Size(canvasWidth, canvasHeight),
        painter: _Painter(
            Paint()
              ..color = isValid
                  ? Color.fromARGB(255, 134, 159, 249)
                  : Color.fromARGB(255, 239, 141, 141)
              ..style = PaintingStyle.fill,
            [scaledNewSpace]),
      ),
      CustomPaint(
        size: Size(canvasWidth, canvasHeight),
        painter: _Painter(
            Paint()
              ..color = Colors.black.withOpacity(0.3)
              ..style = PaintingStyle.fill,
            [scaledCornerTriangle]),
      ),
    ]);
  }
}

class _Walls extends StatelessWidget {
  final Floors floor;
  final Float64List scale;
  final double canvasHeight;
  final double canvasWidth;
  const _Walls({
    required this.floor,
    required this.scale,
    required this.canvasHeight,
    required this.canvasWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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

    return CustomPaint(
      size: Size(canvasWidth, canvasHeight),
      painter: _Painter(
          Paint()
            ..color = Colors.black
            ..strokeWidth = 3.0
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
          [scaledOutterWalls, scaledInnerWalls]),
    );
  }
}

class _Painter extends CustomPainter {
  List<Path> _paths;
  Paint _paint;

  _Painter(this._paint, this._paths);

  @override
  void paint(Canvas canvas, Size size) {
    for (var path in _paths) {
      canvas.drawPath(path, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
