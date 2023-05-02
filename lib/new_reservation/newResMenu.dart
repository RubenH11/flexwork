import "dart:html";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../widgets/plainTextButton.dart";
import "../widgets/plainElevatedButton.dart";
import "../models/floors.dart";
import '../models/newReservationNotifier.dart';
import "./newResTimeFrame.dart";

class NewReservationMenu extends StatelessWidget {
  NewReservationMenu({super.key});

  final LABEL_INDENT = 10.0;
  final FUNCTION_INDENT = 90.0;

  @override
  Widget build(BuildContext context) {
    //final newReservationNotifier = Provider.of<NewReservationNotifier>(context);

    return Column(
      children: [
        //  -------- Floors --------
        // Row(children: const [
        //   Icon(Icons.reorder),
        //   SizedBox(width: 10),
        //   Text("Floors")
        // ]),
        // const SizedBox(height: 5),
        // Row(children: [
        //   SizedBox(width: LABEL_INDENT),
        //   Expanded(
        //     child: PlainTextButton(
        //         alignLeft: true,
        //         text: "Floor 12",
        //         selected: newReservationNotifier.getFloor() == Floors.f12,
        //         onPressed: () {
        //           if (newReservationNotifier.getFloor() != Floors.f12) {
        //             newReservationNotifier.setFloor(Floors.f12);
        //             newReservationNotifier.setRoomNumber(null);
        //           }
        //         }),
        //   ),
        // ]),
        // Row(children: [
        //   SizedBox(width: LABEL_INDENT),
        //   Expanded(
        //     child: PlainTextButton(
        //         alignLeft: true,
        //         text: "Floor 11",
        //         selected: newReservationNotifier.getFloor() == Floors.f11,
        //         onPressed: () {
        //           if (newReservationNotifier.getFloor() != Floors.f11) {
        //             newReservationNotifier.setFloor(Floors.f11);
        //             newReservationNotifier.setRoomNumber(null);
        //           }
        //         }),
        //   ),
        // ]),
        // Row(children: [
        //   SizedBox(width: LABEL_INDENT),
        //   Expanded(
        //     child: PlainTextButton(
        //         alignLeft: true,
        //         text: "Floor 10",
        //         selected: newReservationNotifier.getFloor() == Floors.f10,
        //         onPressed: () {
        //           if (newReservationNotifier.getFloor() != Floors.f10) {
        //             newReservationNotifier.setFloor(Floors.f10);
        //             newReservationNotifier.setRoomNumber(null);
        //           }
        //         }),
        //   ),
        // ]),
        // Row(children: [
        //   SizedBox(width: LABEL_INDENT),
        //   Expanded(
        //     child: PlainTextButton(
        //         alignLeft: true,
        //         text: "Floor 9",
        //         selected: newReservationNotifier.getFloor() == Floors.f9,
        //         onPressed: () {
        //           if (newReservationNotifier.getFloor() != Floors.f9) {
        //             newReservationNotifier.setFloor(Floors.f9);
        //             newReservationNotifier.setRoomNumber(null);
        //           }
        //         }),
        //   ),
        // ]),

        Divider(),
        NewReservationTimeFrame(),
        Divider(),
        //  -------- Schedule --------
        Row(children: const [
          Icon(Icons.calendar_today),
          SizedBox(width: 10),
          Text("Schedule")
        ]),
        const SizedBox(height: 5),
        MenuItem(
            labelText: "Repeat",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PlainTextButton(
                    onPressed: () {},
                    selected: true,
                    text: "every other",
                  ),
                ),
                Expanded(
                    child: PlainTextButton(
                        onPressed: () {}, selected: true, text: "week"))
              ],
            )),
        MenuItem(
            labelText: "Until",
            child: PlainTextButton(
              onPressed: () {},
              selected: true,
              text: "29 Jul 2023",
            )),
        MenuItem(
            labelText: "Except",
            child: PlainElevatedButton(
              onPressed: () {},
              focused: false,
              child: Text("add a date"),
              icon: Icon(Icons.add),
            )),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  String labelText;
  Widget child;
  MenuItem({required this.labelText, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: 80,
          child: Text(
            labelText,
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
