import "package:flexwork/database/database.dart";
import "package:flexwork/helpers/diagonalPattern.dart";
import "package:flexwork/models/newReservationNotifier.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/futureBuilder.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:tuple/tuple.dart";
import '../helpers/floorSketcher.dart';
import "../models/floors.dart";
import "dart:typed_data";

// ------------ INFO ---------------
// The Canvas width takes up the full available area minus the padding
// The Canvas height takes up 12/27 of the width
// Rooms are 1/27 wide of the Canvas width
// Rooms are 1.5/27 high of the Canvas width
// ---------------------------------

class Floor extends StatelessWidget {
  final Floors floor;
  final Workspace? selectedWorkspace;
  final Function(Workspace?) setSelectedWorkspace;
  final List<int> blockedWorkspaceIds;
  const Floor({
    required this.floor,
    required this.selectedWorkspace,
    required this.setSelectedWorkspace,
    required this.blockedWorkspaceIds,
    super.key,
  });

  void _handleWorkspaceTap(
    Offset tapOffset,
    List<Workspace> workspaces,
    Float64List scale,
  ) {
    var roomWasTapped = false;

    for (var workspace in workspaces) {
      if (workspace.getPath().transform(scale).contains(tapOffset)) {
        roomWasTapped = true;
        // print("room was tapped: ${workspace.getIdentifier()}");
        setSelectedWorkspace(workspace);
      }
    }
    if (!roomWasTapped) {
      setSelectedWorkspace(null);
    }
  }

  @override
  Widget build(BuildContext context) {

    return FlexworkFutureBuilder(
        future: DatabaseFunctions.getWorkspaces(floor),
        builder: (workspaces) {

          return LayoutBuilder(
            builder: (context, constraints) {
              final dependentOnWidth =
                  constraints.maxHeight > constraints.maxWidth / 27 * 12;
              // print("dependentOnWidth: $dependentOnWidth");
              final canvasHeight = dependentOnWidth
                  ? constraints.maxWidth / 27 * 12
                  : constraints.maxHeight;
              final canvasWidth = dependentOnWidth
                  ? constraints.maxWidth
                  : canvasHeight / 12 * 27;
              final pixelSize = canvasWidth / (27 * 12);
              final matrix = Matrix4.identity()..scale(pixelSize, pixelSize);
              final scale = matrix.storage;

              List<Tuple2<Color, Path>> scaledWorkspaces = [];
              List<Path> scaledBlockedWorkspaces = [];
              Path? scaledSelectedWorkspace;
              for (final workspace in workspaces) {
                // print("checking workspace $workspace == $selectedWorkspace");
                if (selectedWorkspace != null &&
                    workspace.getId() == selectedWorkspace!.getId()) {
                  scaledSelectedWorkspace =
                      workspace.getPath().transform(scale);
                } else {
                  scaledWorkspaces.add(Tuple2(workspace.getColor(),
                      workspace.getPath().transform(scale)));
                }
                if (blockedWorkspaceIds.contains(workspace.getId())) {
                  scaledBlockedWorkspaces
                      .add(workspace.getPath().transform(scale));
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
                  _handleWorkspaceTap(details.localPosition, workspaces, scale);
                },
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size(canvasWidth, canvasHeight),
                      painter: _FloorPainter(
                        freeWorkspaces: scaledWorkspaces,
                        selectedWorkspace: scaledSelectedWorkspace,
                        outterWalls: scaledOutterWalls,
                        innerWalls: scaledInnerWalls,
                      ),
                    ),
                    ClipPath(
                      clipper: _BlockedSpaceClipper(scaledBlockedWorkspaces),
                      child: CustomPaint(
                        size: Size(canvasWidth, canvasHeight),
                        painter: DiagonalPatternPainter(),
                        child: Container(
                          width: canvasWidth,
                          height: canvasHeight,
                        ),
                      ),
                    ),
                    Positioned(
                      top: canvasHeight * 0.52,
                      left: canvasWidth * 0.27,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        height: canvasHeight * 0.48,
                        width: canvasWidth * 0.35,
                        child: _Legend(),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }
}

class _Legend extends StatelessWidget {
  const _Legend({super.key});

  @override
  Widget build(BuildContext context) {
    // final typeColors = FirebaseService().workspaceTypes.getColors();

    return LayoutBuilder(builder: (context, constraints) {
      final fullHeight = constraints.maxHeight;
      // final boxSize = fullHeight / (typeColors.length + 1) - 10;

      final List<Widget> legendItems = [];

      // typeColors.forEach((type, color) {
      //   legendItems.add(
      //     Expanded(
      //       child: Row(
      //         children: [
      //           Container(color: color, width: boxSize, height: boxSize),
      //           SizedBox(width: 10),
      //           Text(type),
      //         ],
      //       ),
      //     ),
      //   );
      // });

      // legendItems.add(
      //   Expanded(
      //     child: Row(
      //       children: [
      //         Container(
      //           width: boxSize,
      //           height: boxSize,
      //           child: ClipRect(
      //             child: CustomPaint(
      //               size: Size(double.infinity, double.infinity),
      //               painter: DiagonalPatternPainter(),
      //             ),
      //           ),
      //         ),
      //         SizedBox(
      //           width: 10,
      //         ),
      //         Text("Occupied"),
      //       ],
      //     ),
      //   ),
      // );

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: legendItems,
      );
    });
  }
}

class _FloorPainter extends CustomPainter {
  final List<Tuple2<Color, Path>> freeWorkspaces;
  final Path? selectedWorkspace;
  final Path outterWalls;
  final Path innerWalls;

  _FloorPainter({
    required this.innerWalls,
    required this.selectedWorkspace,
    required this.outterWalls,
    required this.freeWorkspaces,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // print("selected workspace: $selectedWorkspace");
    if (selectedWorkspace != null) {
      final selectedWorkspacePaint = Paint()
        ..color = Color.fromARGB(255, 134, 159, 249)
        ..style = PaintingStyle.fill;

      canvas.drawPath(selectedWorkspace!, selectedWorkspacePaint);
    }

    for (var workspace in freeWorkspaces) {
      canvas.drawPath(
          workspace.item2,
          Paint()
            ..color = workspace.item1
            ..style = PaintingStyle.fill);
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

class _BlockedSpaceClipper extends CustomClipper<Path> {
  final List<Path> paths;

  _BlockedSpaceClipper(this.paths);

  @override
  Path getClip(Size size) {
    if (paths.isEmpty) {
      // print("wanted to clip, but there were no paths");
      return Path();
    }
    // print("clipping something soon: $paths");
    final combinedPath = Path();
    for (final path in paths) {
      combinedPath.addPath(path, Offset.zero);
    }
    // print("found $combinedPath");
    return combinedPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

Tuple2<double, double> _getFirstPoint(Path path) {
  final pathMetrics = path.computeMetrics();

  assert(pathMetrics.isNotEmpty);

  final pathMetric = pathMetrics.first;
  final startPoint = pathMetric.getTangentForOffset(0.0)!.position;

  return Tuple2<double, double>(startPoint.dx, startPoint.dy);
}
