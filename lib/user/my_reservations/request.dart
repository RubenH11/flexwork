import 'package:flexwork/database/database.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/models/request.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flexwork/widgets/floor.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flexwork/widgets/workspaceTimelines.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class MyReservationsRequest extends StatelessWidget {
  final Workspace workspace;
  final Request request;

  const MyReservationsRequest(
      {required this.workspace, required this.request, super.key});

  @override
  Widget build(BuildContext context) {
    print("|||| MyReservationsRequest ||||");
    print(workspace);
    print(request);

    final requestStart = request.getStart();
    final requestEnd = request.getEnd();

    final List<DateTime> days = [];
    for (var i = DateTimeHelper.extractOnlyDay(requestStart);
        i.isAtSameMomentAs(DateTimeHelper.extractOnlyDay(requestEnd));
        i = i.add(const Duration(days: 1))) {
      print(i);
      days.add(i);
    }

    // final List<Tuple2<DateTime, DateTime>> personalReservations = [];
    // for (var day in days) {
    //   personalReservations.addAll(FirebaseService().reservations.get(workspace: workspace, date: day, uid: FirebaseAuth.instance.currentUser!.uid).map((res) => Tuple2(res.getStart(), res.getEnd(),),));
    // }

    return FlexworkFutureBuilder(
      future: DatabaseFunctions.getWorkspaceTypes(),
      builder: (legend) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Floor(
                legend: legend,
                floor: workspace.getFloor(),
                selectedWorkspace: workspace,
                setSelectedWorkspace: (_) {},
                blockedWorkspaceIds: const [],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WorkspaceTimelines(
                      boldFocus: true,
                      days: days,
                      numSurroundingDays: 1,
                      workspace: workspace,
                      selectedReservations: [Tuple2(requestStart, requestEnd)]),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TextField(
                      controller:
                          TextEditingController(text: request.getMessage()),
                      readOnly: true,
                      expands: true,
                      minLines: null,
                      maxLines: null,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
