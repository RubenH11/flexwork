import "package:flutter/material.dart";
import "package:provider/provider.dart";
import '../widgets/floor.dart';
import "../models/newReservationNotifier.dart";

class NewReservationContent extends StatelessWidget {
  const NewReservationContent({super.key});

  @override
  Widget build(BuildContext context) {
    print("rebuilding NewResrvationContent");
    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);
    final selectedRoom = newReservationNotifier.getRoomNumber();
    print("selectedRoom: $selectedRoom");

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Floor(selectedRoom: selectedRoom, newReservationNotifier: newReservationNotifier, floor: newReservationNotifier.getFloor()),
      if(newReservationNotifier.getRoomNumber() != null) Text("Room ${newReservationNotifier.getRoomNumber()}",),
    ],);
  }
}