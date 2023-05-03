import "dart:html";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "../widgets/plainTextButton.dart";
import "../widgets/plainElevatedButton.dart";
import "../models/floors.dart";
import '../models/newReservationNotifier.dart';
import "./newResTimeFrame.dart";
import "./newResFloors.dart";

const LABEL_INDENT = 10.0;

class NewReservationMenu extends StatelessWidget {
  NewReservationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    //final newReservationNotifier = Provider.of<NewReservationNotifier>(context);

    return Column(
      children: [
        NewReservationFloors(),
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
          width: LABEL_INDENT,
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
