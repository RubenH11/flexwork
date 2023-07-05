import 'package:flexwork/helpers/database.dart';
import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/models/request.dart';
import 'package:flexwork/models/workspace.dart';
import 'package:flexwork/widgets/floor.dart';
import 'package:flexwork/widgets/futureBuilder.dart';
import 'package:flexwork/widgets/workspaceTimelines.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class SeeMoreOfRequest extends StatelessWidget {
  final Workspace workspace;
  final Request request;

  const SeeMoreOfRequest(
      {required this.workspace, required this.request, super.key});

  @override
  Widget build(BuildContext context) {
    print("|||| SeeMoreOfRequest ||||");

    final List<DateTime> days = [];
    for (var i = DateTimeHelper.extractOnlyDay(request.getStart());
        i.isAtSameMomentAs(DateTimeHelper.extractOnlyDay(request.getEnd()));
        i = i.add(const Duration(days: 1))) {
      days.add(i);
    }

    return FlexworkFutureBuilder(
      future: DatabaseFunctions.getWorkspaceTypes(),
      builder: (legend) {
        return FlexworkFutureBuilder(
          future: DatabaseFunctions.getRequest(request.getId()),
          builder: (upToDateRequest) {
            print("ccc");
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
                          key: UniqueKey(),
                          boldFocus: true,
                          days: days,
                          numSurroundingDays: 1,
                          workspace: workspace,
                          selectedReservations: [
                            if (upToDateRequest != null)
                              Tuple2(upToDateRequest.getStart(),
                                  upToDateRequest.getEnd())
                          ]),
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
      },
    );
  }
}
