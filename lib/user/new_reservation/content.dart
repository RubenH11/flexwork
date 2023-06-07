import 'package:flexwork/database/database.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flexwork/widgets/workspaceTimelines.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:tuple/tuple.dart';
import '../../widgets/floor.dart';

class NewReservationContent extends StatelessWidget {
  const NewReservationContent({super.key});

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
          flex: 2,
          child: FlexworkFutureBuilder(
            future: getBlockedWorkspaceIds(
                newResNotif.getStartTime(), newResNotif.getEndTime()),
            builder: (blockedWorkspaceIds) {
              return Floor(
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
          flex: 1,
          child: newResNotif.getWorkspace() != null
              ? WorkspaceTimelines(
                  days: [
                    DateTimeHelper.extractOnlyDay(DateTime.now()),
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
