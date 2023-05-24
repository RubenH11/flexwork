import "dart:html";

import 'package:flexwork/models/newReservationNotifier.dart';
import 'package:flexwork/user/new_reservation/menuSchedule.dart';
import 'package:flexwork/widgets/menuItem.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../widgets/customTextButton.dart';
import '../../widgets/customElevatedButton.dart';

import 'menuTimeframes.dart';
import 'menuFloors.dart';
import 'menuConfirm.dart';

class NewReservationMenu extends StatelessWidget {
  const NewReservationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final newRefNotif = Provider.of<NewReservationNotifier>(context);
    print("rebuild NewReservationMenu");
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const NewReservationMenuFloors(),
                const Divider(),
                const NewReservationMenuTimeFrame(),
                const Divider(),
                if(newRefNotif.getStartTime() != null && newRefNotif.getEndTime() != null) const NewReservationMenuSchedule(),
              ],
            ),
          ),
        ),
        const Divider(),
        MakeReserationButton()
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
