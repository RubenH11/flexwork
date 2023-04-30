import "dart:html";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../widgets/plainTextButton.dart";
import "../widgets/plainElevatedButton.dart";
import 'newReservationStructure.dart';
import '../models/newReservationNotifier.dart';

class NewReservationMenu extends StatelessWidget {
  NewReservationMenu({super.key});

  final LABEL_INDENT = 10.0;
  final FUNCTION_INDENT = 90.0;

  @override
  Widget build(BuildContext context) {
    final newReservationNotifier = Provider.of<NewReservationNotifier>(context);

    return Column(
      children: [
        //  -------- Floors --------
        Row(children: const [
          Icon(Icons.reorder),
          SizedBox(width: 10),
          Text("Floors")
        ]),
        Row(children: [
          SizedBox(width: LABEL_INDENT),
          Expanded(
            child: PlainTextButton(
                alignLeft: true,
                text: "Floor 12",
                selected: newReservationNotifier.getFloor() == Floors.f12,
                action: () {
                  newReservationNotifier.setFloor(Floors.f12);
                }),
          ),
        ]),
        Row(children: [
          SizedBox(width: LABEL_INDENT),
          Expanded(
            child: PlainTextButton(
                alignLeft: true,
                text: "Floor 11",
                selected: newReservationNotifier.getFloor() == Floors.f11,
                action: () {
                  newReservationNotifier.setFloor(Floors.f11);
                }),
          ),
        ]),
        Row(children: [
          SizedBox(width: LABEL_INDENT),
          Expanded(
            child: PlainTextButton(
                alignLeft: true,
                text: "Floor 10",
                selected: newReservationNotifier.getFloor() == Floors.f10,
                action: () {
                  newReservationNotifier.setFloor(Floors.f10);
                }),
          ),
        ]),
        Row(children: [
          SizedBox(width: LABEL_INDENT),
          Expanded(
            child: PlainTextButton(
                alignLeft: true,
                text: "Floor 9",
                selected: newReservationNotifier.getFloor() == Floors.f9,
                action: () {
                  newReservationNotifier.setFloor(Floors.f9);
                }),
          ),
        ]),

        Divider(),
        //  -------- Timeframe --------
        Row(children: const [
          Icon(Icons.access_time),
          SizedBox(width: 10),
          Text("Timeframe")
        ]),
        MenuItem(labelText: "Start", child: PlainTextButton(
            action: () {},
            selected: true,
            text: "12:00 - 25 May 2023",
          )),
        MenuItem(labelText: "End", child: PlainTextButton(
            action: () {},
            selected: true,
            text: "13:00 - 25 May 2023",
          )),

        Divider(),
        //  -------- Schedule --------
        Row(children: const [
          Icon(Icons.calendar_today),
          SizedBox(width: 10),
          Text("Schedule")
        ]),
        MenuItem(
            labelText: "Repeat",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PlainTextButton(
                      action: () {}, selected: true, text: "every other",),
                ),
                Expanded(child: PlainTextButton(action: () {}, selected: true, text: "week"))
              ],
            )),
        MenuItem(
            labelText: "Until",
            child: PlainTextButton(
              action: () {},
              selected: true,
              text: "29 Jul 2023",
            )),
        MenuItem(
            labelText: "Except",
            child: PlainElevatedButton(
              action: () {},
              focused: false,
              text: "add a date",
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
