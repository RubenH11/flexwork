import 'package:flexwork/models/floors.dart';
import 'package:flexwork/models/workspace.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import '../../widgets/floor.dart';
import '../../models/newReservationNotifier.dart';

class NewReservationContent extends StatelessWidget {
  const NewReservationContent({super.key});

  @override
  Widget build(BuildContext context) {
    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Floor(
          setSelectedWorkspace: (workspace) {
            newReservationNotifier.setWorkspace(workspace);
          },
          selectedWorkspace: newReservationNotifier.getWorkspace(),
          floor: newReservationNotifier.getFloor(),
        ),
        if (newReservationNotifier.getIdentifier() != null)
          Text(
            "Room ${newReservationNotifier.getIdentifier()}",
          ),
        if (newReservationNotifier.getStartTime() != null)
          Text("Start time is set to ${newReservationNotifier.getStartTime()}"),
        if (newReservationNotifier.getEndTime() != null)
          Text("End time is set to ${newReservationNotifier.getEndTime()}"),
      ],
    );
  }
}
