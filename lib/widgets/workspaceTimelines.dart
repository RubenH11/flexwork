import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/helpers/diagonalPattern.dart';
import 'package:flexwork/database/firebaseService.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class WorkspaceTimelines extends StatelessWidget {
  final List<DateTime> days;
  final int numSurroundingDays;
  final Workspace workspace;
  final bool boldFocus;
  final List<Tuple2<DateTime, DateTime>> selectedReservations;
  const WorkspaceTimelines({
    required this.boldFocus,
    required this.days,
    this.numSurroundingDays = 0,
    required this.workspace,
    required this.selectedReservations,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    assert(numSurroundingDays >= 0);
    final List<Widget> icons = List.generate(
      workspace.getNumMonitors(),
      (index) => Icon(
        Icons.monitor,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
    icons.addAll(
      List.generate(
        workspace.getNumWhiteboards(),
        (index) => Icon(
          Icons.width_normal,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
    icons.addAll(
      List.generate(
        workspace.getNumScreens(),
        (index) => Icon(
          Icons.connected_tv,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
    for (var i = icons.length - 1; i > 0; i--) {
      icons.insert(
        i,
        const SizedBox(
          width: 5,
        ),
      );
    }

    List<DateTime> timelineDays = [];
    for (var day in days) {
      for (var i = -numSurroundingDays; i <= numSurroundingDays; i++) {
        timelineDays.add(day.add(Duration(days: i)));
      }
    }
    timelineDays.toSet();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${workspace.getIdentifier()}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "    ●    ",
              style: TextStyle(
                  fontSize: 8, color: Theme.of(context).colorScheme.background),
            ),
            Text(
              "${workspace.getType()}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "    ●    ",
              style: TextStyle(
                  fontSize: 8, color: Theme.of(context).colorScheme.background),
            ),
            ...icons,
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(width: 150),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("00:00", style: TextStyle(color: Colors.grey)),
                  Text("03:00", style: TextStyle(color: Colors.grey)),
                  Text("06:00", style: TextStyle(color: Colors.grey)),
                  Text("08:00", style: TextStyle(color: Colors.grey)),
                  Text("12:00", style: TextStyle(color: Colors.grey)),
                  Text("15:00", style: TextStyle(color: Colors.grey)),
                  Text("18:00", style: TextStyle(color: Colors.grey)),
                  Text("21:00", style: TextStyle(color: Colors.grey)),
                  Text("00:00", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: timelineDays.length * 24,
          child: ListView.builder(
            itemCount: timelineDays.length,
            itemBuilder: (context, index) {
              // print("building timeline for day ${days[index]}");

              final reservations = FirebaseService()
                  .reservations.get(workspace: workspace, date: timelineDays[index])
                  .map(
                (res) {
                  return Tuple2(res.getStart(), res.getEnd());
                },
              ).toList();
              // print("found reservations: $reservations");

              return Column(
                children: [
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          DateFormat('EEEE d MMM').format(timelineDays[index]),
                          style: TextStyle(
                              fontWeight: boldFocus && days.contains(timelineDays[index])
                                  ? FontWeight.bold
                                  : null),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: WorkspaceTimeline(
                            reservations: reservations,
                            timelineDay: timelineDays[index],
                            personalReservations: FirebaseService()
                                .reservations.get(
                                    workspace: workspace,
                                    date: timelineDays[index],
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .map((res) =>
                                    Tuple2(res.getStart(), res.getEnd()))
                                .toList(),
                            selectedReservations:
                                DateTimeHelper.getOverlappingDateRangesOverDay(
                                    selectedReservations, timelineDays[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class WorkspaceTimeline extends StatelessWidget {
  final List<Tuple2<DateTime, DateTime>> reservations;
  final List<Tuple2<DateTime, DateTime>> personalReservations;
  final List<Tuple2<DateTime, DateTime>> selectedReservations;
  final DateTime timelineDay;
  const WorkspaceTimeline(
      {required this.reservations,
      required this.timelineDay,
      required this.personalReservations,
      required this.selectedReservations,
      super.key});

  @override
  Widget build(BuildContext context) {
    assert(timelineDay.hour == 0, timelineDay.minute == 0);

    Widget getPositionedContainer(
        {required DateTime start,
        required DateTime end,
        required DateTime timelineDay,
        required Color boxColor,
        required double fullWidth,
        required double height,
        CustomPainter? overlayPattern}) {
      double startOffset = 0.0;
      // if start is within the timeline
      if (start.day == timelineDay.day) {
        final minutesOffset = start.hour * 60 + start.minute;
        startOffset = minutesOffset * fullWidth / 1440;
      }

      double blockWidth = fullWidth - startOffset;
      if (timelineDay.day == end.day) {
        final startWithinTimeline =
            start.day == timelineDay.day ? start : timelineDay;
        final hourDiff = end.hour - startWithinTimeline.hour;
        final minuteDiff = end.minute - startWithinTimeline.minute;
        final minutesOffset = 60 * hourDiff + minuteDiff;
        blockWidth = minutesOffset * fullWidth / 1440;
      }

      return Positioned(
        left: startOffset,
        child: Stack(
          children: [
            overlayPattern == null
                ? const SizedBox()
                : ClipRect(
                    child: CustomPaint(
                    size: Size(blockWidth, height),
                    painter: overlayPattern,
                  )),
            Container(width: blockWidth, height: height, color: boxColor),
          ],
        ),
      );
    }

    return SizedBox(
      height: 20,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fullWidth = constraints.maxWidth;
          final height = constraints.maxHeight;

          final timelineBlocks = reservations
              .map((res) => getPositionedContainer(
                    start: res.item1,
                    end: res.item2,
                    timelineDay: timelineDay,
                    boxColor: Theme.of(context).colorScheme.error,
                    fullWidth: fullWidth,
                    height: height,
                  ))
              .toList();

          final personalTimelineBlocks = personalReservations
              .map((res) => getPositionedContainer(
                    start: res.item1,
                    end: res.item2,
                    timelineDay: timelineDay,
                    boxColor: const Color.fromARGB(255, 86, 227, 90),
                    fullWidth: fullWidth,
                    height: height,
                  ))
              .toList();

          final selectedTimelineBlock = selectedReservations
              .map((res) => getPositionedContainer(
                    start: res.item1,
                    end: res.item2,
                    timelineDay: timelineDay,
                    boxColor: Color.fromARGB(255, 134, 159, 249),
                    fullWidth: fullWidth,
                    height: height,
                  ))
              .toList();

          final allOtherReservations = [...reservations];
          allOtherReservations.addAll(personalReservations);

          final List<Widget> overlappingBlocks = [];
          for (var res in allOtherReservations) {
            for (var selectedRes in selectedReservations) {
              if (DateTimeHelper.dateRangesOverlap(res, selectedRes)) {
                // print("found overlap");
                // print("  $res");
                // print("  $selectedRes");
                final listOfDateTimes = [
                  res.item1,
                  res.item2,
                  selectedRes.item1,
                  selectedRes.item2
                ];
                listOfDateTimes.sort();
                // print(listOfDateTimes);

                overlappingBlocks.add(getPositionedContainer(
                  start: listOfDateTimes[1],
                  end: listOfDateTimes[2],
                  timelineDay: timelineDay,
                  boxColor: Colors.transparent,
                  fullWidth: fullWidth,
                  height: height,
                  overlayPattern: DiagonalPatternPainter(),
                ));
              }
            }
          }



          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).colorScheme.background,
              ),
              ...timelineBlocks,
              ...personalTimelineBlocks,
              ...selectedTimelineBlock,
              ...overlappingBlocks,
            ],
          );
        },
      ),
    );
  }
}
