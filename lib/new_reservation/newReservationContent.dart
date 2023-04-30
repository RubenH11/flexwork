import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../widgets/floor_9.dart";
import "../models/newReservationNotifier.dart";

class NewReservationContent extends StatelessWidget {
  const NewReservationContent({super.key});

  @override
  Widget build(BuildContext context) {
    print("rebuilding NewResrvationContent");
    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);
    final selectedRoom = newReservationNotifier.getRoomNumber();
    print("selectedRoom: $selectedRoom");

    return Column(children: [
      Floor9(selectedRoom: selectedRoom, newReservationNotifier: newReservationNotifier,),
      Text("test"),
    ],);
  }
}