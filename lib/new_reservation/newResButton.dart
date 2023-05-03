import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../models/newReservationNotifier.dart";
import "../widgets/plainElevatedButton.dart";
import "../helpers/firebase.dart";

class MakeReserationButton extends StatelessWidget {
  MakeReserationButton({super.key});
  //var isLoading =

  @override
  Widget build(BuildContext context) {
    final newRes = Provider.of<NewReservationNotifier>(context);

    return PlainElevatedButton(
      onPressed: newRes.isComplete()
          ? () {
              FirebaseService.addReservation(newRes.getStartTime()!,
                  newRes.getEndTime()!, newRes.getRoomNumber()!);
              newRes.clear();
            }
          : () {
              print("not all fields were filled, so no res could be made");
              //TODO: tell the user why they cannot yet press the make reservation button
            },
      focused: newRes.isComplete(),
      child: Text("make reservation"),
    );
  }
}
