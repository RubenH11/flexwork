import "package:firebase_auth/firebase_auth.dart";
import "package:flexwork/helpers/dateTimeHelper.dart";
import 'package:flexwork/database/firebaseService.dart';
import "package:flexwork/widgets/workspaceTimelines.dart";
import "package:flutter/material.dart";
import "package:collection/collection.dart";
import "package:tuple/tuple.dart";

class MyReservationsOverview extends StatelessWidget {
  const MyReservationsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final reservations = FirebaseService().reservations.get(uid: FirebaseAuth.instance.currentUser!.uid);

    final groupedReservations =
        reservations.groupListsBy<String>((res) => res.getWorkspaceId());

    return ListView.builder(
      itemCount: groupedReservations.length,
      itemBuilder: (context, index) {
        final workspaceId = groupedReservations.keys.toList()[index];
        final workspace =
            FirebaseService().workspaces.get(id: workspaceId).first;
        final startDays = groupedReservations[workspaceId]!
            .map((res) => DateTimeHelper.extractOnlyDay(res.getStart()))
            .toSet();
        final endDays = groupedReservations[workspaceId]!
            .map((res) => DateTimeHelper.extractOnlyDay(res.getEnd()))
            .toSet();
        startDays.addAll(endDays);
        final days = startDays.toList();
        days.sort();
        final personalReservations = groupedReservations[workspaceId]!
            .map(
              (res) => Tuple2(res.getStart(), res.getEnd()),
            )
            .toList();

        return Column(
          children: [
            const SizedBox(height: 20),
            WorkspaceTimelines(
              boldFocus: false,
              days: days,
              workspace: workspace,
              selectedReservations: const [],
            ),
          ],
        );
      },
    );
  }
}
