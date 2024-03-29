import 'package:flexwork/helpers/dateTimeHelper.dart';
import 'package:flexwork/database/firebaseService.dart';
import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/widgets/workspaceTimelines.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:tuple/tuple.dart';
import '../../widgets/floor.dart';

class NewReservationContent extends StatelessWidget {
  const NewReservationContent({super.key});

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
          child: Floor(
            blockedWorkspaceIds: FirebaseService()
                .reservations
                .getConflictWorkspaceIds(newResNotif),
            setSelectedWorkspace: (workspace) {
              newResNotif.setWorkspace(workspace);
            },
            selectedWorkspace: newResNotif.getWorkspace(),
            floor: newResNotif.getFloor(),
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
