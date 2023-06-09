import "package:flexwork/database/database.dart";
import "package:flexwork/helpers/dateTimeHelper.dart";
import "package:flexwork/models/workspace.dart";
import "package:flexwork/widgets/futureBuilder.dart";
import "package:flexwork/widgets/workspaceTimelines.dart";
import "package:flutter/material.dart";
import "package:collection/collection.dart";
import "package:tuple/tuple.dart";

class MyReservationsOverview extends StatelessWidget {
  const MyReservationsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return FlexworkFutureBuilder(
      future: DatabaseFunctions.getReservations(personal: true),
      builder: (reservations) {
        final groupedReservations =
            reservations.groupListsBy((res) => res.getWorkspaceId());

        return reservations.isEmpty
            ? Center(
                child: Text(
                  "You have no reservations yet",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              )
            : ListView.builder(
                itemCount: groupedReservations.length,
                itemBuilder: (context, index) {
                  final workspaceId = groupedReservations.keys.toList()[index];
                  final startDays = groupedReservations[workspaceId]!
                      .map((res) =>
                          DateTimeHelper.extractOnlyDay(res.getStart()))
                      .toSet();
                  final endDays = groupedReservations[workspaceId]!
                      .map((res) => DateTimeHelper.extractOnlyDay(res.getEnd()))
                      .toSet();
                  startDays.addAll(endDays);
                  final days = startDays.toList();
                  days.sort();

                  return FlexworkFutureBuilder(
                    future: DatabaseFunctions.getWorkspace(
                        workspaceId: workspaceId),
                    builder: (workspace) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          WorkspaceTimelines(
                            boldFocus: false,
                            days: days,
                            workspace: workspace[0],
                            selectedReservations: const [],
                          ),
                        ],
                      );
                    },
                  );
                },
              );
      },
    );
  }
}
