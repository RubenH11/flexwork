import "package:flexwork/models/newReservationNotifier.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "./newResMenu.dart";
import '../widgets/customTextButton.dart';
import "../models/floors.dart";

class NewReservationFloors extends StatefulWidget {
  const NewReservationFloors({super.key});

  @override
  State<NewReservationFloors> createState() => _NewReservationFloorsState();
}

class _NewReservationFloorsState extends State<NewReservationFloors> {
  @override
  Widget build(BuildContext context) {
    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);
    return Column(
      children: [
        Row(children: const [
          Icon(Icons.reorder),
          SizedBox(width: 10),
          Text("Floors")
        ]),
        const SizedBox(height: 5),
        Row(children: [
          SizedBox(width: LABEL_INDENT),
          Expanded(
            child: CustomTextButton(
                alignLeft: true,
                text: "Floor 12",
                selected: newReservationNotifier.getFloor() == Floors.f12,
                onPressed: () {
                  if (newReservationNotifier.getFloor() != Floors.f12) {
                    newReservationNotifier.setFloor(Floors.f12);
                    newReservationNotifier.setRoomNumber(null);
                  }
                }),
          ),
        ]),
        Row(children: [
          SizedBox(width: LABEL_INDENT),
          Expanded(
            child: CustomTextButton(
                alignLeft: true,
                text: "Floor 11",
                selected: newReservationNotifier.getFloor() == Floors.f11,
                onPressed: () {
                  if (newReservationNotifier.getFloor() != Floors.f11) {
                    newReservationNotifier.setFloor(Floors.f11);
                    newReservationNotifier.setRoomNumber(null);
                  }
                }),
          ),
        ]),
        Row(children: [
          SizedBox(width: LABEL_INDENT),
          Expanded(
            child: CustomTextButton(
                alignLeft: true,
                text: "Floor 10",
                selected: newReservationNotifier.getFloor() == Floors.f10,
                onPressed: () {
                  if (newReservationNotifier.getFloor() != Floors.f10) {
                    newReservationNotifier.setFloor(Floors.f10);
                    newReservationNotifier.setRoomNumber(null);
                  }
                }),
          ),
        ]),
        Row(
          children: [
            SizedBox(width: LABEL_INDENT),
            Expanded(
              child: CustomTextButton(
                  alignLeft: true,
                  text: "Floor 9",
                  selected: newReservationNotifier.getFloor() == Floors.f9,
                  onPressed: () {
                    if (newReservationNotifier.getFloor() != Floors.f9) {
                      newReservationNotifier.setFloor(Floors.f9);
                      newReservationNotifier.setRoomNumber(null);
                    }
                  }),
            ),
          ],
        )
      ],
    );
  }
}
