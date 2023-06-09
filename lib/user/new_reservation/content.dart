import 'package:flexwork/database/database.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flexwork/widgets/workspaceTimelines.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:tuple/tuple.dart';
import '../../widgets/floor.dart';

class NewReservationContent extends StatefulWidget {
  final Map<String, Color> legend;
  const NewReservationContent({super.key, required this.legend});

  @override
  State<NewReservationContent> createState() => _NewReservationContentState();
}

class _NewReservationContentState extends State<NewReservationContent> {
  var numMovedDays = 0;
  DateTime focusDay = DateTimeHelper.extractOnlyDay(DateTime.now());

  Future<List<int>> getBlockedWorkspaceIds(
      DateTime? start, DateTime? end) async {
    late final List<int> blockedWorkspaceIds;

    if (start == null || end == null) {
      blockedWorkspaceIds = [];
    } else {
      final blockingReservations = await DatabaseFunctions.getReservations(
          timeRange: Tuple2(start, end), others: true);
      blockedWorkspaceIds =
          blockingReservations.map((res) => res.getWorkspaceId()).toList();
    }
    return blockedWorkspaceIds;
  }

  @override
  Widget build(BuildContext context) {
    print("|||| NewReservationContent ||||");
    final newResNotif = Provider.of<NewReservationNotifier>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: FlexworkFutureBuilder(
            future: getBlockedWorkspaceIds(
                newResNotif.getStartTime(), newResNotif.getEndTime()),
            builder: (blockedWorkspaceIds) {
              return Floor(
                legend: widget.legend,
                setSelectedWorkspace: (workspace) {
                  newResNotif.setWorkspace(workspace);
                },
                selectedWorkspace: newResNotif.getWorkspace(),
                blockedWorkspaceIds: blockedWorkspaceIds,
                floor: newResNotif.getFloor(),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          flex: 2,
          child: newResNotif.getWorkspace() != null
              ? WorkspaceTimelines(
                  moveDays: true,
                  days: [
                    focusDay,
                  ],
                  boldFocus: true,
                  numSurroundingDays: 3,
                  workspace: newResNotif.getWorkspace()!,
                  selectedReservations: newResNotif.constructSchedule(),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
