import 'package:flexwork/database/database.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/helpers/diagonalPattern.dart';
import 'package:flexwork/models/reservation.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flexwork/widgets/customElevatedButton.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class WorkspaceTimelines extends StatefulWidget {
  final List<DateTime> days;
  final int numSurroundingDays;
  final Workspace workspace;
  final bool boldFocus;
  final List<Tuple2<DateTime, DateTime>> selectedReservations;
  final bool moveDays;
  const WorkspaceTimelines({
    required this.boldFocus,
    required this.days,
    this.numSurroundingDays = 0,
    required this.workspace,
    required this.selectedReservations,
    this.moveDays = false,
    super.key,
  });

  @override
  State<WorkspaceTimelines> createState() => _WorkspaceTimelinesState();
}

class _WorkspaceTimelinesState extends State<WorkspaceTimelines> {
  late List<DateTime> focusDays;
  var moveDaysBy = 0;

  @override
  void initState() {
    focusDays = widget.days;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("|||| WorkspaceTimelines ||||");
    assert(widget.numSurroundingDays >= 0);

    var movedFocusDays = [];
    for (var day in focusDays) {
      movedFocusDays.add(day.add(Duration(days: moveDaysBy)));
    }


    final List<Widget> icons = List.generate(
      widget.workspace.getNumMonitors(),
      (index) => Icon(
        Icons.monitor,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );
    icons.addAll(
      List.generate(
        widget.workspace.getNumWhiteboards(),
        (index) => Icon(
          Icons.width_normal,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
    icons.addAll(
      List.generate(
        widget.workspace.getNumScreens(),
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
    for (var day in movedFocusDays) {
      for (var i = -widget.numSurroundingDays; i <= widget.numSurroundingDays; i++) {
        timelineDays.add(day.add(Duration(days: i)));
      }
    }
    timelineDays.toSet();

    return Column(
      children: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "${widget.workspace.getIdentifier()}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "    ●    ",
                style: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).colorScheme.background),
              ),
              Text(
                "${widget.workspace.getType()}",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "    ●    ",
                style: TextStyle(
                    fontSize: 8,
                    color: Theme.of(context).colorScheme.background),
              ),
              ...icons,
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            SizedBox(width: 150),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
            SizedBox(width: 50),
          ],
        ),
        SizedBox(
          height: timelineDays.length * 24,
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: timelineDays.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text(
                                DateFormat('EEEE d MMM')
                                    .format(timelineDays[index]),
                                style: TextStyle(
                                    fontWeight: widget.boldFocus &&
                                            movedFocusDays.contains(timelineDays[index])
                                        ? FontWeight.bold
                                        : null),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: WorkspaceTimeline(
                                  key: ValueKey(timelineDays[index]),
                                  timelineDay: timelineDays[index],
                                  userId: 1,
                                  workspace: widget.workspace,
                                  selectedReservations: DateTimeHelper
                                      .getOverlappingDateRangesOverDay(
                                    widget.selectedReservations,
                                    timelineDays[index],
                                  ),
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
              if (widget.moveDays)
                Container(
                  width: 50,
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            setState(() {
                              moveDaysBy = moveDaysBy - 7;
                            });
                          },
                          active: true,
                          selected: true,
                          icon: Icons.arrow_upward,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            setState(() {
                              moveDaysBy--;
                            });
                          },
                          active: true,
                          selected: true,
                          icon: Icons.arrow_drop_up,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            setState(() {
                              moveDaysBy++;
                            });
                          },
                          active: true,
                          selected: true,
                          icon: Icons.arrow_drop_down,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: () {
                            setState(() {
                              moveDaysBy = moveDaysBy + 7;
                            });
                          },
                          active: true,
                          selected: true,
                          icon: Icons.arrow_downward,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkspaceTimeline extends StatelessWidget {
  final List<Tuple2<DateTime, DateTime>> selectedReservations;
  final DateTime timelineDay;
  final Workspace workspace;
  final int userId;
  const WorkspaceTimeline(
      {required this.timelineDay,
      required this.workspace,
      required this.selectedReservations,
      required this.userId,
      super.key});

  Future<Map<String, List<Reservation>>> getReservations() async {
    final allRes = await DatabaseFunctions.getReservations(
        timeRange: DateTimeHelper.getFullDayRange(timelineDay),
        workspaceId: workspace.getId());
    final personalRes = await DatabaseFunctions.getReservations(
        timeRange: DateTimeHelper.getFullDayRange(timelineDay),
        workspaceId: workspace.getId(),
        personal: true);
    for (var res in personalRes) {
      allRes.remove(res);
    }
    return {
      "Other reservations": allRes,
      "Personal reservations": personalRes,
    };
  }

  @override
  Widget build(BuildContext context) {
    assert(timelineDay.hour == 0 || timelineDay.minute == 0);
    print("------- build timeline! ------------");

    Widget getPositionedContainer({
      required DateTime start,
      required DateTime end,
      required DateTime timelineDay,
      required Color boxColor,
      required double fullWidth,
      required double height,
      CustomPainter? overlayPattern,
    }) {
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

    return FlexworkFutureBuilder(
      future: getReservations(),
      builder: (reservationsMap) {
        final personalRes = reservationsMap["Personal reservations"]!;
        final otherRes = reservationsMap["Other reservations"]!;

        return SizedBox(
          height: 20,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final fullWidth = constraints.maxWidth;
              final height = constraints.maxHeight;

              final todaysBlockedMoments = workspace.getBlockedMoments().where(
                  (moment) =>
                      DateTimeHelper.extractOnlyDay(moment.item1) ==
                          timelineDay ||
                      DateTimeHelper.extractOnlyDay(moment.item2) ==
                          timelineDay);

              final timelineBlocks = otherRes
                  .map((res) => getPositionedContainer(
                        start: res.getStart(),
                        end: res.getEnd(),
                        timelineDay: timelineDay,
                        boxColor: Theme.of(context).colorScheme.error,
                        fullWidth: fullWidth,
                        height: height,
                      ))
                  .toList();

              timelineBlocks.addAll(todaysBlockedMoments
                  .map((moment) => getPositionedContainer(
                        start: moment.item1,
                        end: moment.item2,
                        timelineDay: timelineDay,
                        boxColor: Colors.grey,
                        fullWidth: fullWidth,
                        height: height,
                      ))
                  .toList());

              final personalTimelineBlocks = personalRes
                  .map((res) => getPositionedContainer(
                        start: res.getStart(),
                        end: res.getEnd(),
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

              final blockedMoments = otherRes
                  .map((res) => Tuple2(res.getStart(), res.getEnd()))
                  .toList();
              blockedMoments.addAll(todaysBlockedMoments);
              final List<Widget> overlappingBlocks = [];
              for (var moment in blockedMoments) {
                for (var selectedRes in selectedReservations) {
                  print(moment);
                  print(selectedRes);
                  if (DateTimeHelper.dateRangesOverlap(moment, selectedRes)) {
                    final listOfDateTimes = [
                      moment.item1,
                      moment.item2,
                      selectedRes.item1,
                      selectedRes.item2
                    ];
                    listOfDateTimes.sort();
                    print(listOfDateTimes);

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
      },
    );
  }
}
