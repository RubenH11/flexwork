import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/models/request.dart';
import 'package:flexwork/models/reservationConflict.dart';
import 'package:flexwork/user/new_reservation/menuConflicts.dart';
import 'package:flexwork/user/new_reservation/menuSchedule.dart';
import 'package:flexwork/user/new_reservation/menuTimepickers.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'menuTimeframes.dart';
import 'menuFloors.dart';
import 'menuConfirm.dart';

class NewReservationMenu extends StatelessWidget {
  final void Function() refreshPage;
  const NewReservationMenu({super.key, required this.refreshPage});

  @override
  Widget build(BuildContext context) {
    print("|||| NewReservationMenu ||||");
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const NewReservationMenuFloors(),
                const Divider(),
                const NewReservationMenuTimepickers(),
                const Divider(),
                Consumer<NewReservationNotifier>(
                  builder: (ctx, newRefNotif, _) =>
                      (newRefNotif.getStartTime() != null &&
                              newRefNotif.getEndTime() != null)
                          ? Column(
                            children: const [
                              NewReservationMenuSchedule(),
                              Divider(),
                            ],
                          )
                          : const SizedBox(),
                ),
                Conflicts(),
              ],
            ),
          ),
        ),
        const Divider(),
        MakeReserationButton(refreshPage: refreshPage),
      ],
    );
  }
}

class MenuAction extends StatelessWidget {
  final Widget action;
  final String label;
  const MenuAction({required this.action, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label),
        ),
        Expanded(child: action),
      ],
    );
  }
}