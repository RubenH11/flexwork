import "package:flexwork/models/newReservationNotifier.dart";
import "package:flexwork/models/workspace.dart";
import "package:flutter/material.dart";
import '../helpers/floorSketcher.dart';
import "../models/floors.dart";
import "dart:math" as math;
import "dart:typed_data";
import '../models/workspaceSelectionNotifier.dart';
import "../helpers/firebaseService.dart";
import "package:provider/provider.dart";
import '../models/workspaceSelectionNotifier.dart';

// ------------ INFO ---------------
// The Canvas width takes up the full available area minus the padding
// The Canvas height takes up 12/27 of the width
// Rooms are 1/27 wide of the Canvas width
// Rooms are 1.5/27 high of the Canvas width
// ---------------------------------

class Floor extends StatelessWidget {
  final Floors floor;
  final WorkspaceSelectionNotifier notifier;
  const Floor(
      {required this.floor,
      required this.notifier,
      super.key});

  void _handleWorkspaceTap(
    Offset tapOffset,
    List<Workspace> workspaces,
    Float64List scale,
    WorkspaceSelectionNotifier notifier,
  ) {
    var roomWasTapped = false;

    print("handling tap");

    workspaces.forEach((workspace) {
      if (workspace.getPath().transform(scale).contains(tapOffset)) {
        roomWasTapped = true;
        print("room was tapped: ${workspace.getIdentifier()}");
        notifier.setSelectedSpace(workspace);
      }
    });
    if (!roomWasTapped) {
      notifier.setSelectedSpace(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final workspaces = FirebaseService().getWorkspaces(floor);

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth;
        final canvasHeight = canvasWidth / 27 * 12;
        final pixelSize = canvasWidth / (27 * 12);
        final matrix = Matrix4.identity()..scale(pixelSize, pixelSize);
        final scale = matrix.storage;

        List<Path> scaledWorkspaces = [];
        Path? scaledSelectedWorkspace;
        for (final workspace in workspaces) {
          if (workspace == notifier.getSelectedSpace()) {
            scaledSelectedWorkspace = workspace.getPath().transform(scale);
          } else {
            scaledWorkspaces.add(workspace.getPath().transform(scale));
          }
        }

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

        return GestureDetector(
          onTapUp: (details) {
            print("tap up");
            _handleWorkspaceTap(
                details.localPosition, workspaces, scale, notifier);
          },
          child: CustomPaint(
            size: Size(canvasWidth, canvasHeight),
            painter: _FloorPainter(
              workspaces: scaledWorkspaces,
              selectedWorkspace: scaledSelectedWorkspace,
              outterWalls: scaledOutterWalls,
              innerWalls: scaledInnerWalls,
            ),
          ),
        );
      },
    );
  }
}

class _FloorPainter extends CustomPainter {
  final List<Path> workspaces;
  final Path? selectedWorkspace;
  final Path outterWalls;
  final Path innerWalls;

  _FloorPainter({
    required this.innerWalls,
    this.selectedWorkspace,
    required this.outterWalls,
    required this.workspaces,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedWorkspace != null) {
      final selectedWorkspacePaint = Paint()
        ..color = const Color.fromARGB(255, 134, 159, 249)
        ..style = PaintingStyle.fill;

      canvas.drawPath(selectedWorkspace!, selectedWorkspacePaint);
    }

    final workspacePaint = Paint()
      ..color = const Color.fromARGB(255, 135, 235, 151)
      ..style = PaintingStyle.fill;

    for (var workspace in workspaces) {
      canvas.drawPath(workspace, workspacePaint);
    }

    final innerWallsPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(innerWalls, innerWallsPaint);

    final outterWallsPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(outterWalls, outterWallsPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
