import "package:flutter/material.dart";
import "package:provider/provider.dart";
import '../../models/newReservationNotifier.dart';
import '../../widgets/customElevatedButton.dart';
import '../../helpers/firebaseService.dart';

class MakeReserationButton extends StatelessWidget {
  MakeReserationButton({super.key});
  //var isLoading =

  @override
  Widget build(BuildContext context) {
    final newRes = Provider.of<NewReservationNotifier>(context);

    return CustomElevatedButton(
      onPressed: newRes.isComplete()
          ? () {
              FirebaseService().addReservation(
                newRes.getStartTime()!,
                newRes.getEndTime()!,
                newRes.getIdentifier()!,
              );
              newRes.clear();
            }
          : () {
              print("not all fields were filled, so no res could be made");
              //TODO: tell the user why they cannot yet press the make reservation button
            },
      active: newRes.isComplete(),
      selected: newRes.isComplete(),
      text: "make reservation",
    );
  }
}
